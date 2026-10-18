import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/error_utils.dart';
import '../../../services/firebase_service.dart';
import '../domain/organization.dart';
import '../domain/organization_member.dart';

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
  Future<({String invitationId, String email})> inviteMember({
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

  /// Fetches a single organization document once with high-performance cache.
  Future<Organization?> getOrganization(String organizationId) async {
    if (organizationId.isEmpty) return null;

    if (_orgCache.containsKey(organizationId)) {
      return _orgCache[organizationId];
    }

    final doc = await _firebase.firestore
        .collection(AppConstants.organizationsCollection)
        .doc(organizationId)
        .get();

    if (doc.exists) {
      final org = Organization.fromFirestore(doc);
      _orgCache[organizationId] = org;
      return org;
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

    // Enforce 5 MB (5,242,880 bytes) limit
    if (imageBytes.length > 5242880) {
      throw Exception(
          'Organization logo exceeds 5MB size limit.');
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
    final uploadTask = await storageRef.putData(
      Uint8List.fromList(imageBytes),
      SettableMetadata(contentType: contentType),
    );

    final downloadUrl = await uploadTask.ref.getDownloadURL();

    // Update Firestore via server-authoritative updateOrganization Cloud Function
    try {
      final callable = _firebase.functions.httpsCallable('updateOrganization');
      await callable.call({
        'organizationId': organizationId,
        'logoUrl': downloadUrl,
      });
      _orgCache.remove(organizationId);
    } on FirebaseFunctionsException catch (e) {
      throw Exception(mapFirebaseFunctionsError(e));
    }

    return downloadUrl;
  }
}

final organizationRepositoryProvider = Provider<OrganizationRepository>((ref) {
  return OrganizationRepository();
});
