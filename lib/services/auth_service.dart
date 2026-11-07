import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_service.dart';

class AuthService {
  final FirebaseService _firebase = FirebaseService();

  // Single, lazily-created instance (never touched on web, where Firebase's
  // popup flow is used instead).
  late final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: const ['email']);

  Future<void> _googleSignOutSafe() async {
    if (kIsWeb) return;
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }

  User? get currentUser => _firebase.auth.currentUser;

  Stream<User?> get authStateChanges => _firebase.auth.authStateChanges();

  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _firebase.auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    if (credential.user != null) {
      await credential.user!.reload();
      // Force-refresh the ID token so Firestore receives fresh auth token claims
      await credential.user!.getIdToken(true);
    }

    return credential;
  }

  /// Returns the [UserCredential] on success, or `null` if the user cancelled.
  /// Throws a user-friendly [Exception] (or [FirebaseAuthException]) on failure.
  Future<UserCredential?> signInWithGoogle() async {
    UserCredential userCredential;

    try {
      if (kIsWeb) {
        // On web, google_sign_in does not reliably return an idToken.
        // Firebase's own popup flow is the supported path.
        final provider = GoogleAuthProvider()
          ..addScope('email')
          ..setCustomParameters({'prompt': 'select_account'});
        userCredential = await _firebase.auth.signInWithPopup(provider);
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return null; // Cancelled by user

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        if (googleAuth.idToken == null && googleAuth.accessToken == null) {
          await _googleSignOutSafe();
          throw Exception('Google did not return valid credentials. Please try again.');
        }

        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _firebase.auth.signInWithCredential(credential);
      }
    } on PlatformException catch (e) {
      await _googleSignOutSafe();
      switch (e.code) {
        case 'sign_in_canceled':
          return null;
        case 'network_error':
          throw Exception('Network error. Check your connection and try again.');
        case 'sign_in_failed':
          // Usually ApiException 10 / 12500: SHA-1/SHA-256 or OAuth client misconfigured.
          throw Exception('Google sign-in is not configured correctly for this build. Please contact support.');
        default:
          throw Exception('Google sign-in failed. Please try again.');
      }
    } on FirebaseAuthException catch (e) {
      await _googleSignOutSafe();
      switch (e.code) {
        case 'popup-closed-by-user':
        case 'cancelled-popup-request':
        case 'web-context-canceled':
          return null;
        case 'popup-blocked':
          throw Exception('Your browser blocked the Google sign-in popup. Please allow popups and try again.');
        case 'account-exists-with-different-credential':
          throw Exception('Sign-in could not be completed. Try another sign-in method or use password recovery.');
        default:
          rethrow;
      }
    }

    final user = userCredential.user;
    if (user == null) {
      await _googleSignOutSafe();
      throw Exception('Google sign-in failed. Please try again.');
    }

    try {
      await _ensureUserProfile(user);
      await user.reload();
      await user.getIdToken(true);
    } catch (e) {
      // Do NOT leave a half-provisioned session behind: without this the
      // auth-state listener would treat the user as signed in.
      await _googleSignOutSafe();
      await _firebase.auth.signOut();
      if (e is Exception && e.toString().startsWith('Exception: Secure account setup')) {
        rethrow;
      }
      throw Exception('Secure account setup failed. Please sign in again or contact support.');
    }

    return userCredential;
  }

  /// Links the Google provider to the already-signed-in account, for the
  /// "Connected Accounts" settings tab. Unlike [signInWithGoogle], this never
  /// starts a new session - it attaches a second sign-in method to the
  /// current one, so a user who registered with email/password gains the
  /// option to also sign in with Google without losing their account.
  Future<void> linkGoogleAccount() async {
    final user = currentUser;
    if (user == null) throw Exception('You must be signed in to link an account.');

    try {
      if (kIsWeb) {
        final provider = GoogleAuthProvider()
          ..addScope('email')
          ..setCustomParameters({'prompt': 'select_account'});
        await user.linkWithPopup(provider);
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return; // Cancelled by user

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await user.linkWithCredential(credential);
      }
      await user.reload();
    } on PlatformException catch (e) {
      if (e.code == 'sign_in_canceled') return;
      throw Exception('Could not link your Google account. Please try again.');
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'popup-closed-by-user':
        case 'cancelled-popup-request':
        case 'web-context-canceled':
          return;
        case 'credential-already-in-use':
          throw Exception('This Google account is already linked to a different Raay account.');
        case 'provider-already-linked':
          throw Exception('Your account is already linked to Google.');
        default:
          throw Exception('Could not link your Google account. Please try again.');
      }
    }
  }

  /// Unlinks a sign-in provider from the current account. Firebase does NOT
  /// refuse to remove the last remaining provider - doing so would strand
  /// the user with no way to sign back in - so the caller (the Connected
  /// Accounts UI) must only offer this action while 2+ providers are linked.
  Future<void> unlinkProvider(String providerId) async {
    final user = currentUser;
    if (user == null) throw Exception('You must be signed in to do this.');

    try {
      await user.unlink(providerId);
      await user.reload();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'no-such-provider') return;
      throw Exception('Could not disconnect this account. Please try again.');
    }
  }

  /// Creates the Firestore profile (via backend function) on first Google login.
  Future<void> _ensureUserProfile(User user) async {
    final userDoc = await _firebase.firestore.collection('users').doc(user.uid).get();
    if (userDoc.exists) return;

    final rawName = (user.displayName ?? '').trim();
    final parts = rawName.isEmpty ? <String>[] : rawName.split(RegExp(r'\s+'));
    final firstName = parts.isNotEmpty ? parts.first : 'Google';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : 'User';

    try {
      await _firebase.functions.httpsCallable('completeRegistration').call({
        'firstName': firstName,
        'lastName': lastName,
      });
    } catch (_) {
      throw Exception('Secure account setup failed. Please sign in again or contact support.');
    }

    if (user.photoURL != null) {
      try {
        await _firebase.firestore
            .collection('users')
            .doc(user.uid)
            .update({'photoUrl': user.photoURL});
      } catch (_) {
        // Non-critical: profile photo is optional.
      }
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final credential = await _firebase.auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    if (credential.user != null) {
      // Complete registration securely via backend function
      await _firebase.functions.httpsCallable('completeRegistration').call({
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
      });
      // Optionally update local auth cache
      await credential.user!.updateDisplayName('${firstName.trim()} ${lastName.trim()}');
      
      // Automatically trigger initial email verification
      await sendEmailVerification();
    }
  }

  Future<void> sendEmailVerification() async {
    final user = currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<bool> checkEmailVerified() async {
    final user = currentUser;
    if (user != null) {
      await user.reload();
      // Force-refresh the ID token so Firestore receives fresh auth token claims
      await user.getIdToken(true);
      return currentUser?.emailVerified ?? false;
    }
    return false;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final trimmedEmail = email.trim();
    try {
      await _firebase.auth.sendPasswordResetEmail(email: trimmedEmail);
    } on FirebaseAuthException catch (e) {
      // Avoid account enumeration: treat user-not-found gracefully without revealing account non-existence
      if (e.code == 'user-not-found') {
        return;
      }
      rethrow;
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = currentUser;
    if (user == null) throw Exception('No authenticated user found.');

    final hasPasswordProvider = user.providerData.any((p) => p.providerId == 'password');
    if (!hasPasswordProvider || user.email == null) {
      throw Exception('Password change is not available for Google-only or non-password accounts.');
    }

    try {
      // 1. Reauthenticate (Exact string match, no trimming)
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // 2. Update Password (Exact string match, no trimming)
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw Exception('Current password is incorrect.');
      } else if (e.code == 'weak-password') {
        throw Exception('New password is too weak. Please choose a stronger password.');
      } else if (e.code == 'requires-recent-login') {
        throw Exception('Please sign out and sign in again before changing your password.');
      } else {
        throw Exception('Failed to update password: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred while updating password.');
    }
  }

  /// Re-proves the current user's identity without signing them out, so a
  /// fresh `auth_time` satisfies the server's recent-authentication window
  /// (FR-10) after a [RequiresRecentAuthException]. [password] is required
  /// for email/password accounts and ignored otherwise.
  Future<void> reauthenticate({String? password}) async {
    final user = currentUser;
    if (user == null) throw Exception('No authenticated user found.');

    final isGoogleUser = user.providerData.any((p) => p.providerId == 'google.com');
    final isPasswordUser = user.providerData.any((p) => p.providerId == 'password');

    try {
      if (isGoogleUser) {
        if (kIsWeb) {
          final provider = GoogleAuthProvider()
            ..addScope('email')
            ..setCustomParameters({'prompt': 'select_account'});
          await user.reauthenticateWithPopup(provider);
        } else {
          final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
          if (googleUser == null) {
            throw Exception('Verification cancelled.');
          }
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          await user.reauthenticateWithCredential(credential);
        }
      } else if (isPasswordUser) {
        if (password == null || password.isEmpty) {
          throw Exception('Enter your password to continue.');
        }
        final credential = EmailAuthProvider.credential(email: user.email!, password: password);
        await user.reauthenticateWithCredential(credential);
      } else {
        throw Exception('Please sign out and sign back in to continue.');
      }

      await user.getIdToken(true);
    } on FirebaseAuthMultiFactorException catch (e) {
      throw MfaRequiredException(e.resolver);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw Exception('Incorrect password.');
      }
      throw Exception(e.message ?? 'Verification failed. Please try again.');
    }
  }

  Future<void> deleteAccount() async {
    final user = currentUser;
    if (user == null) throw Exception('No authenticated user found.');

    try {
      // Runs server-side with Admin privileges: deletes the Firestore `users/{uid}`
      // document (which the client is never allowed to do) and the Auth record.
      await _firebase.functions.httpsCallable('deleteAccount').call();
      await _googleSignOutSafe();
      await _firebase.auth.signOut();
    } on FirebaseFunctionsException catch (e) {
      if (e.code == 'failed-precondition') {
        throw Exception('For security reasons, please sign out and sign back in before deleting your account.');
      }
      throw Exception(e.message ?? 'Failed to delete account.');
    } catch (e) {
      throw Exception('Failed to delete account: ${e.toString().replaceAll("Exception: ", "")}');
    }
  }

  Future<void> signOut() async {
    await _googleSignOutSafe();
    await _firebase.auth.signOut();
  }
}

/// Thrown by [AuthService.reauthenticate] when the account has a second factor
/// enrolled; callers resolve it with showTotpChallengeDialog.
class MfaRequiredException implements Exception {
  final MultiFactorResolver resolver;
  const MfaRequiredException(this.resolver);
  @override
  String toString() => 'Two-factor verification is required to continue.';
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final platformAdminProvider = FutureProvider<bool>((ref) async {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return false;
  final token = await user.getIdTokenResult();
  return token.claims?['platformAdmin'] == true;
});
