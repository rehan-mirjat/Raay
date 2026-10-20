import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Thrown by repository methods in place of a generic Exception when the
/// server rejected a sensitive action (publish/close event, role changes,
/// account deletion, etc.) because the caller's sign-in is more than 15
/// minutes old (FR-10's 900-second recent-authentication window). Callers
/// should catch this specifically and prompt the user to reauthenticate,
/// then retry - the server's own 900s window makes re-signing-in-fully
/// (not just a silent token refresh) the only way to satisfy the check.
class RequiresRecentAuthException implements Exception {
  const RequiresRecentAuthException();
  @override
  String toString() =>
      'For security, please verify your identity again before continuing.';
}

/// requireRecentAuthentication() on the server always throws this exact
/// failed-precondition message - distinct from the many OTHER reasons a
/// failed-precondition can occur (wrong event status, no eligible voters,
/// etc.), so message-matching (not just the error code) is required.
bool isRecentAuthError(dynamic error) {
  return error is FirebaseFunctionsException &&
      error.code == 'failed-precondition' &&
      (error.message?.contains('sign back in') ?? false);
}

bool isMfaRequiredError(dynamic error) {
  return error is FirebaseFunctionsException &&
      error.code == 'failed-precondition' &&
      (error.message?.contains('Two-factor authentication is required') ?? false);
}

String mapFirebaseAuthError(FirebaseAuthException error) {
  switch (error.code) {
    case 'email-already-in-use':
      return 'Could not create the account with these details. Check the information and try again.';
    case 'invalid-email':
      return 'Please enter a valid email address.';
    case 'weak-password':
      return 'Password must be at least 6 characters.';
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return 'Invalid email or password.';
    case 'user-disabled':
      return 'This account has been disabled by an administrator.';
    case 'too-many-requests':
      return 'Too many failed attempts. Please try again later.';
    case 'network-request-failed':
      return 'Network error. Please check your internet connection.';
    case 'operation-not-allowed':
      return 'This sign-in method is not enabled.';
    default:
      return error.message ?? 'Authentication failed.';
  }
}

String mapFirebaseFunctionsError(dynamic error) {
  if (error is FirebaseFunctionsException) {
    final details = error.details;
    final detailMessage = switch (details) {
      String message when message.trim().isNotEmpty => message.trim(),
      Map details
          when details['message'] is String &&
              (details['message'] as String).trim().isNotEmpty =>
        (details['message'] as String).trim(),
      _ => null,
    };
    final functionMessage = error.message?.trim();
    final usefulMessage = detailMessage ??
        (functionMessage != null &&
                functionMessage.isNotEmpty &&
                functionMessage.toLowerCase() != error.code.toLowerCase()
            ? functionMessage
            : null);

    switch (error.code) {
      case 'unauthenticated':
        return 'You must be signed in to perform this action.';
      case 'permission-denied':
        return error.message ?? 'You do not have permission for this action.';
      case 'invalid-argument':
        return error.message ?? 'Invalid request parameter.';
      case 'failed-precondition':
        return error.message ??
            'This request cannot be completed in the current state.';
      case 'already-exists':
        return error.message ?? 'Resource already exists.';
      case 'resource-exhausted':
        return 'Too many failed attempts. Please wait 5 minutes before trying again.';
      case 'internal':
        return usefulMessage ??
            'The server could not complete this request. Please try again shortly.';
      default:
        return error.message ?? 'Unable to process request. Please try again.';
    }
  }
  return error.toString();
}
