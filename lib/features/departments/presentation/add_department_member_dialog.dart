import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kivora/core/theme/kivora_icons.dart';
import 'package:kivora/core/widgets/ui_kit/kivora_button.dart';
import 'package:kivora/core/widgets/ui_kit/kivora_text_field.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../organizations/presentation/membership_directory_screen.dart';
import '../data/department_repository.dart';
import '../../../core/utils/friendly_error.dart';

class AddDepartmentMemberDialog extends ConsumerStatefulWidget {
  const AddDepartmentMemberDialog({
    super.key,
    required this.organizationId,
    required this.departmentId,
    required this.allMembers,
  });

  final String organizationId;
  final String departmentId;
  final List<Map<String, dynamic>> allMembers;

  @override
  ConsumerState<AddDepartmentMemberDialog> createState() => _AddDepartmentMemberDialogState();
}

class _AddDepartmentMemberDialogState extends ConsumerState<AddDepartmentMemberDialog> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _loadingUid;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _assignMember(String targetUid) async {
    setState(() => _loadingUid = targetUid);
    try {
      await ref.read(departmentRepositoryProvider).assignMemberToDepartment(
            organizationId: widget.organizationId,
            targetUid: targetUid,
            departmentId: widget.departmentId,
          );
      ref.invalidate(organizationMembersDirectoryProvider(widget.organizationId));
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member assigned successfully.'), backgroundColor: AppTheme.success),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loadingUid = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to assign member: ${friendlyError(e)}'), backgroundColor: AppTheme.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final kc = KivoraColors.of(context);
    final availableMembers = widget.allMembers.where((m) {
      final isNotInDept = m['departmentId'] != widget.departmentId;
      final isActive = m['status'] == 'active';
      final name = (m['displayName'] as String? ?? '').toLowerCase();
      final email = (m['email'] as String? ?? '').toLowerCase();
      final matchesSearch = _searchQuery.isEmpty || name.contains(_searchQuery) || email.contains(_searchQuery);
      // A row without a user id cannot be assigned, so it is not offered.
      final hasUserId = (m['userId'] as String?)?.isNotEmpty ?? false;
      return isNotInDept && isActive && hasUserId && matchesSearch;
    }).toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: kc.surface,
      child: SizedBox(
        width: (screenSize.width - 80).clamp(280.0, 520.0),
        height: (screenSize.height * 0.92).clamp(320.0, 800.0),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(KivoraIcons.userPlus,
                            color: KivoraColors.of(context).accentText, size: 20),
                      ),
                      const SizedBox(width: 12),
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        'Add Member to Department',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kc.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                    icon: const Icon(KivoraIcons.x, size: 20),
                  onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              KivoraTextField(
                controller: _searchController,
                label: 'Search Active Members',
                hint: 'Type a name or email...',
                prefixIcon: KivoraIcons.search,
                onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: availableMembers.isEmpty
                    ? Center(
                        child: Text(
                          'No eligible active members found.',
                          style: TextStyle(color: kc.textSecondary),
                        ),
                      )
                    : ListView.separated(
                        itemCount: availableMembers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final member = availableMembers[index];
                          final name = member['displayName'] as String? ?? 'Unknown User';
                          final email = member['email'] as String? ?? '';
                          final targetUid = member['userId'] as String;
                          final currentDept = member['departmentName'] as String?;

                          final isAssigningThis = _loadingUid == targetUid;
                          final isDisabled = _loadingUid != null;

                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: kc.background,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: kc.border),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.14),
                                  child: Text(
                                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                                    style: TextStyle(
                                        color: kc.accentText, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: kc.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        '$email${currentDept != null ? ' • currently in $currentDept' : ''}',
                                        style: TextStyle(fontSize: 14, color: kc.textSecondary),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton.filledTonal(
                                  tooltip: 'Add $name to this department',
                                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                                  onPressed: isDisabled ? null : () => _assignMember(targetUid),
                                  icon: isAssigningThis
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(strokeWidth: 2))
                                      : const Icon(KivoraIcons.userPlus, size: 20),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              KivoraButton(
                type: KivoraButtonType.ghost,
                label: 'Close',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
