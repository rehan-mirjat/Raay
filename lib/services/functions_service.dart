import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_service.dart';

class FunctionsService {
  final FirebaseFunctions _functions;

  FunctionsService({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseService().functions;

  /// Calls a callable cloud function with optional parameter map and returns map result.
  Future<Map<String, dynamic>> callFunction(
    String name, [
    Map<String, dynamic>? parameters,
  ]) async {
    try {
      final callable = _functions.httpsCallable(name);
      final response = await callable.call(parameters);
      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data as Map);
      }
      return {'result': response.data};
    } on FirebaseFunctionsException catch (e) {
      throw Exception('Functions Exception [$name]: ${e.code} - ${e.message}');
    } catch (e) {
      throw Exception('Functions Error [$name]: $e');
    }
  }

  // --- Auth & User ---
  Future<Map<String, dynamic>> completeRegistration({
    required String firstName,
    required String lastName,
    required String displayName,
    String? phoneNumber,
  }) =>
      callFunction('completeRegistration', {
        'firstName': firstName,
        'lastName': lastName,
        'displayName': displayName,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
      });

  // --- Organizations ---
  Future<Map<String, dynamic>> createOrganization({
    required String name,
    required String slug,
    required String description,
    required String category,
  }) =>
      callFunction('createOrganization', {
        'name': name,
        'slug': slug,
        'description': description,
        'category': category,
      });

  Future<Map<String, dynamic>> updateOrganization({
    required String organizationId,
    String? name,
    String? description,
    String? logoUrl,
  }) =>
      callFunction('updateOrganization', {
        'organizationId': organizationId,
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (logoUrl != null) 'logoUrl': logoUrl,
      });

  // --- Membership & Invitations ---
  Future<Map<String, dynamic>> createJoiningCode({
    required String organizationId,
    required int maxUses,
    required String expiresAtIso,
  }) =>
      callFunction('createJoiningCode', {
        'organizationId': organizationId,
        'maxUses': maxUses,
        'expiresAt': expiresAtIso,
      });

  Future<Map<String, dynamic>> joinOrganizationWithCode({
    required String code,
  }) =>
      callFunction('joinOrganizationWithCode', {'code': code});

  Future<Map<String, dynamic>> revokeJoiningCode({
    required String codeId,
  }) =>
      callFunction('revokeJoiningCode', {'codeId': codeId});

  Future<Map<String, dynamic>> inviteMember({
    required String organizationId,
    required String email,
    required String role,
  }) =>
      callFunction('inviteMember', {
        'organizationId': organizationId,
        'email': email,
        'role': role,
      });

  Future<Map<String, dynamic>> acceptInvitation({
    required String invitationId,
  }) =>
      callFunction('acceptInvitation', {'invitationId': invitationId});

  Future<Map<String, dynamic>> revokeInvitation({
    required String invitationId,
  }) =>
      callFunction('revokeInvitation', {'invitationId': invitationId});

  Future<Map<String, dynamic>> updateMemberRole({
    required String organizationId,
    required String targetUserId,
    required String newRole,
  }) =>
      callFunction('updateMemberRole', {
        'organizationId': organizationId,
        'targetUserId': targetUserId,
        'newRole': newRole,
      });

  Future<Map<String, dynamic>> updateMemberStatus({
    required String organizationId,
    required String targetUserId,
    required String newStatus,
  }) =>
      callFunction('updateMemberStatus', {
        'organizationId': organizationId,
        'targetUserId': targetUserId,
        'newStatus': newStatus,
      });

  Future<Map<String, dynamic>> removeMember({
    required String organizationId,
    required String targetUserId,
  }) =>
      callFunction('removeMember', {
        'organizationId': organizationId,
        'targetUserId': targetUserId,
      });

  Future<Map<String, dynamic>> leaveOrganization({
    required String organizationId,
  }) =>
      callFunction('leaveOrganization', {'organizationId': organizationId});

  // --- Voting & Events ---
  Future<Map<String, dynamic>> castVote({
    required String eventId,
    required List<String> candidateIds,
    required List<String> optionIds,
  }) =>
      callFunction('castVote', {
        'eventId': eventId,
        'candidateIds': candidateIds,
        'optionIds': optionIds,
      });

  Future<Map<String, dynamic>> calculateResults({
    required String eventId,
  }) =>
      callFunction('calculateResults', {'eventId': eventId});

  Future<Map<String, dynamic>> publishResults({
    required String eventId,
  }) =>
      callFunction('publishResults', {'eventId': eventId});

  // --- Platform Admin ---
  Future<Map<String, dynamic>> listOrganizations() =>
      callFunction('listOrganizations');

  Future<Map<String, dynamic>> reviewOrganization({
    required String organizationId,
    required String status,
    String? reason,
  }) =>
      callFunction('reviewOrganization', {
        'organizationId': organizationId,
        'status': status,
        if (reason != null) 'reason': reason,
      });

  Future<Map<String, dynamic>> getPlatformAnalytics() =>
      callFunction('getPlatformAnalytics');
}

final functionsServiceProvider = Provider<FunctionsService>((ref) {
  return FunctionsService();
});
