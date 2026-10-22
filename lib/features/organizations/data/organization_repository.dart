import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/error_utils.dart';
import '../../../services/firebase_service.dart';
import '../domain/organization.dart';
import '../domain/organization_member.dart';
import '../domain/member_growth_point.dart';

class OrganizationRepository {
  OrganizationRepository({FirebaseService? firebase, Uuid? uuid})
      : _firebase = firebase ?? FirebaseService(),
        _uuid = uuid ?? const Uuid();

  final FirebaseService _firebase;
  final Uuid _uuid;

  /// High-performance in-memory cache for organization metadata
  final Map<String, Organization> _orgCache = {};

  void clearCache() {
    _orgCache.clear();
  }

  /// Creates a new Organization via the server-authoritative [createOrganization] Cloud Function.
  Future<String> createOrganization({
    required String name,
    required String type,
    required String description,
    String? country,
    String? city,
    String? website,
    String? logoUrl,
  }) async {
    final requestId = _uuid.v4();

    try {
      final callable = _firebase.functions.httpsCallable('createOrganization');
      final response = await callable.call({
        'requestId': requestId,
        'name': name.trim(),
        'type': type.trim(),
        'description': description.trim(),
        if (country != null && country.trim().isNotEmpty)
          'country': country.trim(),
        if (city != null && city.trim().isNotEmpty) 'city': city.trim(),
        if (website != null && website.trim().isNotEmpty)
          'website': website.trim(),
        if (logoUrl != null && logoUrl.trim().isNotEmpty)
          'logoUrl': logoUrl.trim(),
      });

      final data = response.data as Map<dynamic, dynamic>?;
      if (data != null &&
          data['status'] == 'success' &&
          data['organizationId'] != null) {
        return data['organizationId'] as String;
      }
      throw Exception('Unable to create organization. Please try again.');
    } on FirebaseFunctionsException catch (e) {
      throw Exception(mapFirebaseFunctionsError(e));
    } catch (_) {
      throw Exception('Unable to create organization. Please try again.');
    }
  }

  /// Resolves a joining code to the organization it belongs to, without
  /// joining, via [previewJoiningCode] - lets the member confirm it's the
  /// right organization before committing.
  Future<
      ({
        String organizationId,
        String organizationName,
        String? logoUrl,
        bool verified,
      })> previewJoiningCode(String rawCode) async {
    final trimmedCode = rawCode.trim();
    if (trimmedCode.isEmpty) {
      throw Exception('Please enter a valid joining code.');
    }

    try {
      final callable =
          _firebase.functions.httpsCallable('previewJoiningCode');
      final response = await callable.call({
        'rawCode': trimmedCode,
      });

      final data = response.data as Map<dynamic, dynamic>?;
      if (data != null &&
          data['status'] == 'success' &&
          data['organizationId'] != null) {
        return (
          organizationId: data['organizationId'] as String,
          organizationName:
              (data['organizationName'] as String?) ?? 'Organization',
          logoUrl: data['logoUrl'] as String?,
          verified: data['verified'] as bool? ?? false,
        );
      }
      throw Exception('Unable to find organization. Please try again.');
    } on FirebaseFunctionsException catch (e) {
      throw Exception(mapFirebaseFunctionsError(e));
    } catch (_) {
      throw Exception('Unable to find organization. Please try again.');
    }
  }

  /// Joins an Organization using a raw joining code via [joinOrganizationWithCode] Cloud Function.
  Future<({String organizationId, String organizationName})>
  joinOrganizationWithCode(String rawCode) async {
    final trimmedCode = rawCode.trim();
    if (trimmedCode.isEmpty) {
      throw Exception('Please enter a valid joining code.');
    }

    try {
      final callable =
          _firebase.functions.httpsCallable('joinOrganizationWithCode');
      final response = await callable.call({
        'rawCode': trimmedCode,
      });

      final data = response.data as Map<dynamic, dynamic>?;
      if (data != null &&
          data['status'] == 'success' &&
          data['organizationId'] != null) {
        return (
          organizationId: data['organizationId'] as String,
          organizationName:
              (data['organizationName'] as String?) ?? 'Organization',
        );
      }
      throw Exception('Unable to join organization. Please try again.');
    } on FirebaseFunctionsException catch (e) {
      throw Exception(mapFirebaseFunctionsError(e));
    } catch (_) {
      throw Exception('Unable to join organization. Please try again.');
    }
  }

  /// Creates a joining code and returns its raw value exactly once.
  Future<({String codeId, String rawCode})> createJoiningCode({
    required String organizationId,
    required int expiresInHours,
    required int maxUses,
  }) async {
    try {
      final response = await _firebase.functions
          .httpsCallable('createJoiningCode')
          .call({
        'organizationId': organizationId.trim(),
        'expiresInHours': expiresInHours,
        'maxUses': maxUses,
      });
      final data = response.data as Map<dynamic, dynamic>?;
      final codeId = data?['joiningCodeId'];
      final rawCode = data?['rawCode'];
      if (data?['status'] == 'success' &&
          codeId is String &&
          rawCode is String &&
          rawCode.isNotEmpty) {
        return (codeId: codeId, rawCode: rawCode);
      }
      throw Exception('The server did not return a joining code. Please try again.');
    } on FirebaseFunctionsException catch (error) {
      throw Exception(mapFirebaseFunctionsError(error));
    } catch (error) {
      if (error is Exception) rethrow;
      throw Exception('Unable to create a joining code. Please try again.');
    }
  }

  /// Lists safe metadata about joining codes for an organization.
  Future<List<Map<String, dynamic>>> getJoiningCodes(
      String organizationId) async {
    try {
      final response = await _firebase.functions
          .httpsCallable('getJoiningCodes')
          .call({'organizationId': organizationId.trim()});
      final data = response.data as Map<dynamic, dynamic>?;
      if (data?['status'] == 'success' && data?['codes'] is List) {
        return (data!['codes'] as List<dynamic>)
            .map((code) => Map<String, dynamic>.from(code as Map))
            .toList();
      }
      throw Exception('The joining-code list could not be read. Please try again.');
    } on FirebaseFunctionsException catch (error) {
      throw Exception(mapFirebaseFunctionsError(error));
    } catch (error) {
      if (error is Exception) rethrow;
      throw Exception('Unable to load joining codes. Please try again.');
    }
  }

  Future<void> revokeJoiningCode(String codeId) async {
    try {
      await _firebase.functions
          .httpsCallable('revokeJoiningCode')
          .call({'codeId': codeId});
    } on FirebaseFunctionsException catch (error) {
      throw Exception(mapFirebaseFunctionsError(error));
    } catch (_) {
      throw Exception('Unable to revoke this joining code. Please try again.');
    }
  }

  /// Creates a recipient-visible invitation through the server-authoritative function.
  /// [rawToken] is returned only once - use it to build a shareable invite
  /// link (see [buildInviteLink]); it cannot be recovered later.
  Future<({String invitationId, String email, String rawToken})> inviteMember({
    required String organizationId,
    required String email,
    required String role,
    int expiresInHours = 168,
  }) async {
    try {
      final callable = _firebase.functions.httpsCallable('inviteMember');
      final response = await callable.call({
        'organizationId': organizationId.trim(),
        'email': email.trim(),
        'role': role.trim(),
        'expiresInHours': expiresInHours,
      });

      final data = response.data as Map<dynamic, dynamic>?;
      if (data != null &&
          data['status'] == 'success' &&
          data['invitationId'] != null) {
        return (
          invitationId: (data['invitationId'] as String?) ?? '',
          email: (data['email'] as String?) ?? email,
          rawToken: (data['rawToken'] as String?) ?? '',
        );
      }
    } on FirebaseFunctionsException catch (error) {
      final detailMessage = switch (error.details) {
        String message => message,
        Map details when details['message'] is String =>
          details['message'] as String,
        _ => null,
      };
      final messageIsGeneric =
          error.message?.trim().toLowerCase() == error.code.toLowerCase();
      final serverMessage =
          detailMessage ?? (messageIsGeneric ? null : error.message?.trim());
      final message = switch (error.code) {
        'unauthenticated' =>
          'Please sign in again before sending an invitation.',
        'permission-denied' =>
          serverMessage ?? 'You do not have permission to invite members.',
        'already-exists' => serverMessage ??
            'An active invitation already exists for this email.',
        'invalid-argument' =>
          serverMessage ?? 'Check the email address and invitation details.',
        'failed-precondition' =>
          serverMessage ?? 'Invitation service is not configured correctly.',
        'unavailable' ||
        'deadline-exceeded' =>
          'Invitation service is unavailable. Please try again shortly.',
        'internal' => serverMessage ??
            'The invitation service could not process this request. Please try again shortly.',
        _ => serverMessage ??
            'The invitation failed (${error.code}). Please try again or contact your administrator.',
      };
      throw Exception(message);
    } catch (error) {
      throw Exception('Unable to send invitation: $error');
    }
    throw Exception(
        'Invitation service returned an invalid response. Please try again.');
  }

  /// Builds a shareable https:// invitation link for the given raw token.
  /// There is no transactional email sender in this project, so invitations
  /// aren't emailed automatically - the admin copies this link and shares it
  /// through whatever channel they choose (email client, chat, etc.). Uses
  /// the current web origin when running as a web build (so it works
  /// correctly behind any custom domain), and the project's default Firebase
  /// Hosting domain otherwise - the link always opens correctly in a browser
  /// regardless of the recipient's platform, whether or not they have the
  /// app installed.
  static String buildInviteLink(String rawToken) {
    final base = kIsWeb ? Uri.base.origin : 'https://vote-d1ae4.web.app';
    return '$base/invite?token=${Uri.encodeQueryComponent(rawToken)}';
  }

  /// Accepts an invitation by its raw token (from a shared invite link) via
  /// the server-authoritative [acceptInvitation] Cloud Function.
  Future<({String organizationId, String organizationName})>
      acceptInvitationByToken(String rawToken) async {
    final trimmedToken = rawToken.trim();
    if (trimmedToken.isEmpty) {
      throw Exception('This invitation link is missing its token.');
    }

    try {
      final callable = _firebase.functions.httpsCallable('acceptInvitation');
      final response = await callable.call({
        'rawToken': trimmedToken,
      });

      final data = response.data as Map<dynamic, dynamic>?;
      if (data != null &&
          data['status'] == 'success' &&
          data['organizationId'] != null) {
        return (
          organizationId: data['organizationId'] as String,
          organizationName:
              (data['organizationName'] as String?) ?? 'Organization',
        );
      }
      throw Exception('Unable to accept this invitation. Please try again.');
    } on FirebaseFunctionsException catch (e) {
      throw Exception(mapFirebaseFunctionsError(e));
    } catch (_) {
      throw Exception('Unable to accept this invitation. Please try again.');
    }
  }

  /// Adds an existing verified Kivora account directly as a regular member.
  Future<void> addMember({
    required String organizationId,
    required String email,
  }) async {
    try {
      await _firebase.functions.httpsCallable('addMember').call({
        'organizationId': organizationId.trim(),
        'email': email.trim(),
      });
    } on FirebaseFunctionsException catch (error) {
      throw Exception(mapFirebaseFunctionsError(error));
    } catch (_) {
      throw Exception('Unable to add this member. Please try again.');
    }
  }

  /// Loads invitations addressed to the signed-in account.
  Future<List<Map<String, dynamic>>> getMyInvitations() async {
    try {
      final response = await _firebase.functions
          .httpsCallable('memberInvitations')
          .call({'action': 'list'});
      final data = response.data as Map<dynamic, dynamic>?;
      if (data != null &&
          data['status'] == 'success' &&
          data['invitations'] is List) {
        return (data['invitations'] as List<dynamic>)
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      }
      throw Exception('Unable to load your invitations. Please try again.');
    } on FirebaseFunctionsException catch (error) {
      if (error.code == 'not-found') {
        throw Exception(
            'Invitation notifications are not available yet. The server function must be deployed.');
      }
      throw Exception(mapFirebaseFunctionsError(error));
    } catch (_) {
      throw Exception('Unable to load your invitations. Please try again.');
    }
  }

  /// Accepts or declines an invitation addressed to the signed-in account.
  Future<({String organizationId, String organizationName})>
      respondToInvitation({
    required String invitationId,
    required bool accept,
  }) async {
    try {
      final response = await _firebase.functions
          .httpsCallable('memberInvitations')
          .call({
        'action': accept ? 'accept' : 'decline',
        'invitationId': invitationId,
      });
      final data = response.data as Map<dynamic, dynamic>?;
      if (data != null &&
          data['status'] == 'success' &&
          (data['organizationId'] as String?)?.isNotEmpty == true) {
        return (
          organizationId: data['organizationId'] as String,
          organizationName:
              (data['organizationName'] as String?) ?? 'Organization',
        );
      }
      throw Exception('Unable to update this invitation. Please try again.');
    } on FirebaseFunctionsException catch (error) {
      if (error.code == 'not-found') {
        throw Exception(
            'Invitation responses are not available yet. The server function must be deployed.');
      }
      throw Exception(mapFirebaseFunctionsError(error));
    } catch (_) {
      throw Exception('Unable to update this invitation. Please try again.');
    }
  }

  /// Revokes an invitation via [revokeInvitation] Cloud Function.
  Future<void> revokeInvitation(String invitationId) async {
    try {
      final callable = _firebase.functions.httpsCallable('revokeInvitation');
      await callable.call({
        'invitationId': invitationId,
      });
    } on FirebaseFunctionsException catch (e) {
      throw Exception(mapFirebaseFunctionsError(e));
    } catch (_) {
      throw Exception('Unable to revoke invitation. Please try again.');
    }
  }

  /// Fetches pending invitations through the server-authoritative
  /// [getPendingInvitations] Cloud Function. Do not fall back to client-side
  /// reads: invitation documents contain recipient and organization data.
  Future<List<Map<String, dynamic>>> getPendingInvitations(
      String organizationId) async {
    try {
      final callable =
          _firebase.functions.httpsCallable('getPendingInvitations');
      final response = await callable.call({
        'organizationId': organizationId,
      });

      final data = response.data as Map<dynamic, dynamic>?;
      if (data != null &&
          data['status'] == 'success' &&
          data['invitations'] is List) {
        final list = data['invitations'] as List<dynamic>;
        return list
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      }
      throw Exception(
          'The invitation service returned an unexpected response. Please try again.');
    } on FirebaseFunctionsException catch (error) {
      throw Exception(mapFirebaseFunctionsError(error));
    } catch (error) {
      if (error is Exception) rethrow;
      throw Exception('Unable to load pending invitations. Please try again.');
    }
  }

  /// Fetches paginated organization members through the server-authoritative
  /// [getOrganizationMembers] Cloud Function. Directory errors are surfaced so
  /// a backend failure cannot be mistaken for an organization with no members.
  Future<({List<Map<String, dynamic>> members, String? nextPageToken})>
      getOrganizationMembers({
    required String organizationId,
    int pageSize = 50,
    String? pageToken,
  }) async {
    try {
      final callable =
          _firebase.functions.httpsCallable('getOrganizationMembers');
      final response = await callable.call({
        'organizationId': organizationId.trim(),
        'pageSize': pageSize,
        if (pageToken != null && pageToken.isNotEmpty) 'pageToken': pageToken,
      });

      final data = response.data as Map<dynamic, dynamic>?;
      if (data == null ||
          data['status'] != 'success' ||
          data['members'] is! List) {
        throw Exception(
            'The member directory returned an unexpected response. Please try again.');
      }

      final rawList = data['members'] as List<dynamic>;
      final members =
          rawList.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      return (
        members: members,
        nextPageToken: data['nextPageToken'] as String?,
      );
    } on FirebaseFunctionsException catch (error) {
      throw Exception(mapFirebaseFunctionsError(error));
    } catch (error) {
      if (error is Exception) rethrow;
      throw Exception('Unable to load organization members. Please try again.');
    }
  }

  /// Updates a member's role via [updateMemberRole] Cloud Function.
  Future<void> updateMemberRole({
    required String organizationId,
    required String targetUid,
    required String newRole,
  }) async {
    try {
      final callable = _firebase.functions.httpsCallable('updateMemberRole');
      await callable.call({
        'organizationId': organizationId.trim(),
        'targetUid': targetUid.trim(),
        'newRole': newRole.trim(),
      });
    } on FirebaseFunctionsException catch (e) {
      throw Exception(mapFirebaseFunctionsError(e));
    } catch (_) {
      throw Exception('Unable to update member role.');
    }
  }

  /// Updates a member's status via [updateMemberStatus] Cloud Function.
  Future<void> updateMemberStatus({
    required String organizationId,
    required String targetUid,
    required String newStatus,
  }) async {
    try {
      final callable = _firebase.functions.httpsCallable('updateMemberStatus');
      await callable.call({
        'organizationId': organizationId.trim(),
        'targetUid': targetUid.trim(),
        'newStatus': newStatus.trim(),
      });
    } on FirebaseFunctionsException catch (e) {
      throw Exception(mapFirebaseFunctionsError(e));
    } catch (_) {
      throw Exception('Unable to update member status.');
    }
  }

  /// Grants/revokes Package D2's Observer capability via [setObserverStatus].
  /// This is NOT a role change - it layers read-only access to live election
  /// monitoring aggregates on top of the member's existing role.
  Future<void> setObserverStatus({
    required String organizationId,
    required String targetUid,
    required bool isObserver,
  }) async {
    try {
      final callable = _firebase.functions.httpsCallable('setObserverStatus');
      await callable.call({
        'organizationId': organizationId.trim(),
        'targetUid': targetUid.trim(),
        'isObserver': isObserver,
      });
    } on FirebaseFunctionsException catch (e) {
      throw Exception(mapFirebaseFunctionsError(e));
    } catch (_) {
      throw Exception('Unable to update observer status.');
    }
  }

  /// Removes a member via [removeMember] Cloud Function.
  Future<void> removeMember({
    required String organizationId,
    required String targetUid,
  }) async {
    try {
      final callable = _firebase.functions.httpsCallable('removeMember');
      await callable.call({
        'organizationId': organizationId.trim(),
        'targetUid': targetUid.trim(),
      });
    } on FirebaseFunctionsException catch (e) {
      throw Exception(mapFirebaseFunctionsError(e));
    } catch (_) {
      throw Exception('Unable to remove member.');
    }
  }

  /// Voluntarily leaves an organization via [leaveOrganization] Cloud Function.
  Future<void> leaveOrganization({required String organizationId}) async {
    try {
      final callable = _firebase.functions.httpsCallable('leaveOrganization');
      await callable.call({
        'organizationId': organizationId.trim(),
      });
      _orgCache.remove(organizationId);
    } on FirebaseFunctionsException catch (e) {
      throw Exception(mapFirebaseFunctionsError(e));
    } catch (_) {
      throw Exception('Unable to leave organization.');
    }
  }

  /// Deletes an organization via [deleteOrganization] Cloud Function (Owner only).
  Future<void> deleteOrganization({required String organizationId}) async {
    try {
      final callable = _firebase.functions.httpsCallable('deleteOrganization');
      await callable.call({
        'organizationId': organizationId.trim(),
      });
      _orgCache.remove(organizationId);
    } on FirebaseFunctionsException catch (e) {
      throw Exception(mapFirebaseFunctionsError(e));
    } catch (_) {
      throw Exception('Unable to delete organization.');
    }
  }

  /// Streams active membership records for the specified user ID.
  Stream<List<OrganizationMember>> watchUserMemberships(String userId) {
    if (userId.isEmpty) return Stream.value([]);

    return _firebase.firestore
        .collection(AppConstants.orgMembersCollection)
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: AppConstants.memberStatusActive)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrganizationMember.fromFirestore(doc))
            .toList());
  }

  /// Streams a single organization document in real-time with local caching.
  Stream<Organization?> watchOrganization(String organizationId) {
    if (organizationId.isEmpty) return Stream.value(null);

    return _firebase.firestore
        .collection(AppConstants.organizationsCollection)
        .doc(organizationId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        final org = Organization.fromFirestore(doc);
        _orgCache[organizationId] = org;
        return org;
      }
      _orgCache.remove(organizationId);
      return null;
    });
  }

  /// Streams the last [days] daily member-count snapshots written by the
  /// snapshotMemberGrowth Cloud Function, oldest first, for the "Members
  /// Growth" chart. Returns whatever history exists - a freshly created
  /// organization will have few or no points until the scheduler has run.
  Stream<List<MemberGrowthPoint>> watchMemberGrowth(
    String organizationId, {
    int days = 30,
  }) {
    if (organizationId.isEmpty) return Stream.value(const []);

    return _firebase.firestore
        .collection(AppConstants.organizationsCollection)
        .doc(organizationId)
        .collection('memberGrowthSnapshots')
        .orderBy('date', descending: true)
        .limit(days)
        .snapshots()
        .map((snap) => snap.docs
            .map(MemberGrowthPoint.fromFirestore)
            .toList()
            .reversed
            .toList());
  }

  /// Fetches a single organization document once with high-performance cache.
  Future<Organization?> getOrganization(String organizationId) async {
    if (organizationId.isEmpty) return null;

    if (_orgCache.containsKey(organizationId)) {
      return _orgCache[organizationId];
    }

    try {
      final doc = await _firebase.firestore
          .collection(AppConstants.organizationsCollection)
          .doc(organizationId)
          .get();

      if (doc.exists) {
        final org = Organization.fromFirestore(doc);
        _orgCache[organizationId] = org;
        return org;
      }
    } catch (e) {
      // Catch permission-denied or network errors to prevent crashing
      // providers that parallelize these requests.
      return null;
    }
    return null;
  }

  /// Uploads an organization logo to storage and updates the organization document via Cloud Function.
  Future<String> uploadOrganizationLogo({
    required String organizationId,
    required List<int> imageBytes,
  }) async {
    final currentUser = _firebase.auth.currentUser;
    if (currentUser == null) {
      throw Exception('Unauthorized organization logo upload.');
    }

    // Same limit as the Storage rule (2 MB); the rule rejects anything larger.
    if (imageBytes.length > 2 * 1024 * 1024) {
      throw Exception('The logo is larger than 2 MB. Choose a smaller image.');
    }

    // Determine content type
    String contentType = 'image/jpeg';
    String extension = 'jpg';
    if (imageBytes.length >= 8 && imageBytes[0] == 0x89 && imageBytes[1] == 0x50 && imageBytes[2] == 0x4E && imageBytes[3] == 0x47) {
      contentType = 'image/png';
      extension = 'png';
    } else if (imageBytes.length >= 4 && imageBytes[0] == 0x52 && imageBytes[1] == 0x49 && imageBytes[2] == 0x46 && imageBytes[3] == 0x46) {
      contentType = 'image/webp';
      extension = 'webp';
    }

    // Upload to organization-scoped path: organizations/{orgId}/logo/logo.{ext}
    final storageRef = _firebase.storage
        .ref()
        .child('organizations/$organizationId/logo/logo.$extension');
    final String downloadUrl;
    try {
      final uploadTask = await storageRef.putData(
        Uint8List.fromList(imageBytes),
        SettableMetadata(contentType: contentType),
      );
      downloadUrl = await uploadTask.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      debugPrint('Logo upload failed: ${e.code} ${e.message}');
      throw Exception(switch (e.code) {
        'unauthorized' || 'permission-denied' =>
          'The logo could not be uploaded. Only the Owner can change it, and it must be a PNG, JPEG or WebP under 2 MB.',
        'canceled' => 'The logo upload was cancelled.',
        'retry-limit-exceeded' || 'unavailable' =>
          'The logo upload was interrupted. Check your connection and try again.',
        _ => 'The logo could not be uploaded. Please try again.',
      });
    }

    // The caller saves the URL together with the other fields through the
    // server-authoritative updateOrganization callable (one request, one place
    // to report failure).
    return downloadUrl;
  }
}

final organizationRepositoryProvider = Provider<OrganizationRepository>((ref) {
  return OrganizationRepository();
});
