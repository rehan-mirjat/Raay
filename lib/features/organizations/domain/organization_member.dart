import 'package:cloud_firestore/cloud_firestore.dart';
import 'organization_enums.dart';

/// Represents a user's multi-tenant relationship to a specific Organization.
/// This defines exactly what a user is allowed to do within a given tenant context.
class OrganizationMember {
  const OrganizationMember({
    required this.membershipId,
    required this.organizationId,
    required this.userId,
    required this.role,
    required this.status,
    this.employeeId,
    this.departmentId,
    required this.joinedAt,
    required this.updatedAt,
    this.isObserver = false,
  });

  final String membershipId;
  final String organizationId;
  final String userId;
  final OrganizationRole role;
  final MembershipStatus status;
  final String? employeeId;
  final String? departmentId;
  final DateTime joinedAt;
  final DateTime updatedAt;

  /// Package D2: a narrow read-only capability flag, NOT a role. Grants
  /// access to live election monitoring aggregates (via getEventMonitoring)
  /// on top of whatever this member's actual role already allows - see
  /// setObserverStatus.ts for why this isn't a new entry in [role] instead.
  final bool isObserver;

  // UI Convenience Helpers ONLY (Never used as the source of security/authorization)
  bool get isOwner => role == OrganizationRole.owner;
  bool get isAdmin => role == OrganizationRole.admin || role == OrganizationRole.owner;
  bool get isMember => role == OrganizationRole.member;
  bool get isActive => status == MembershipStatus.active;

  factory OrganizationMember.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return OrganizationMember(
      membershipId: doc.id,
      organizationId: data['organizationId'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      role: OrganizationRole.fromString(data['role'] as String? ?? 'member'),
      status: MembershipStatus.fromString(data['status'] as String? ?? 'pending'),
      employeeId: data['employeeId'] as String?,
      departmentId: data['departmentId'] as String?,
      joinedAt: (data['joinedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isObserver: data['isObserver'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'organizationId': organizationId,
      'userId': userId,
      'role': role.value,
      'status': status.value,
      if (employeeId != null) 'employeeId': employeeId,
      if (departmentId != null) 'departmentId': departmentId,
      'joinedAt': Timestamp.fromDate(joinedAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
