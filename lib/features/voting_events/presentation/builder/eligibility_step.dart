import '../../../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raay/core/theme/raay_icons.dart';
import 'package:raay/core/widgets/ui_kit/raay_button.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/raay_colors.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../departments/presentation/providers/department_providers.dart';
import '../../../organizations/presentation/membership_directory_screen.dart';
import '../../domain/voting_event.dart';
import '../providers/draft_event_provider.dart';
import 'csv_import/csv_import_modal.dart';

class EligibilityStep extends ConsumerStatefulWidget {
  final String orgId;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const EligibilityStep(
      {super.key,
      required this.orgId,
      required this.onNext,
      required this.onBack});

  @override
  ConsumerState<EligibilityStep> createState() => _EligibilityStepState();
}

class _EligibilityStepState extends ConsumerState<EligibilityStep> {
  late EligibilityType _type;
  List<String> _selectedDepts = [];
  List<String> _selectedUsers = [];

  @override
  void initState() {
    super.initState();
    final draft = ref.read(draftEventProvider(widget.orgId));
    _type = draft.eligibilityType;
    _selectedDepts = List.from(draft.selectedDepartmentIds);
    _selectedUsers = List.from(draft.selectedUserIds);
  }

  void _submit() async {
    _saveSelection();

    // Now, create the DRAFT on the server!
    final success = await ref
        .read(draftEventProvider(widget.orgId).notifier)
        .createServerDraft();
    if (success) {
      widget.onNext();
    }
  }

  void _saveSelection() {
    ref
        .read(draftEventProvider(widget.orgId).notifier)
        .updateEligibility(_type, _selectedDepts, _selectedUsers);
  }

  @override
  Widget build(BuildContext context) {
    final draftState = ref.watch(draftEventProvider(widget.orgId));
    final isDraft = draftState.status == VotingEventStatus.draft;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isDraft)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: RaayColors.surfaceOf(context),
                borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                border: Border.all(color: RaayColors.borderOf(context))),
            child: Text(AppLocalizations.of(context).elLocked,
                style: TextStyle(color: RaayColors.textSecondaryOf(context))),
          ),
        const SizedBox(height: 16),
        Text(AppLocalizations.of(context).elTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        DropdownButtonFormField<EligibilityType>(
          isExpanded: true,
          // ignore: deprecated_member_use
          value: _type,
          decoration:
              InputDecoration(labelText: AppLocalizations.of(context).elWho),
          items: [
            DropdownMenuItem(
                value: EligibilityType.allMembers,
                child: Text(AppLocalizations.of(context).elAll)),
            DropdownMenuItem(
                value: EligibilityType.selectedDepartments,
                child: Text(AppLocalizations.of(context).elDepts)),
            DropdownMenuItem(
                value: EligibilityType.selectedMembers,
                child: Text(AppLocalizations.of(context).elMembers)),
          ],
          onChanged: isDraft
              ? (v) {
                  if (v != null) {
                    setState(() => _type = v);
                    _saveSelection();
                  }
                }
              : null,
        ),
        const SizedBox(height: 24),
        if (_type == EligibilityType.selectedDepartments)
          _buildDepartmentSelector(isDraft),
        if (_type == EligibilityType.selectedMembers)
          _buildMemberSelector(isDraft),
        if (draftState.isLoading) const LoadingView(),
        if (draftState.error != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .error
                      .withValues(alpha: 0.35)),
            ),
            child: Text(
              draftState.error!,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer),
            ),
          ),
        ],
        const SizedBox(height: 32),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 12,
          runSpacing: 12,
          children: [
            TextButton(
                style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
                onPressed: draftState.isLoading ? null : widget.onBack,
                child: Text(AppLocalizations.of(context).elBack)),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: draftState.isLoading
                  ? null
                  : (isDraft ? _submit : widget.onNext),
              child: Text(draftState.serverEventId == null
                  ? AppLocalizations.of(context).elCreateDraft
                  : AppLocalizations.of(context).elNext),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDepartmentSelector(bool isDraft) {
    final deptsAsync = ref.watch(activeOrganizationDepartmentsProvider);
    return deptsAsync.when(
      loading: () => const LoadingView(),
      error: (e, _) => Text(AppLocalizations.of(context).elListError),
      data: (depts) {
        if (depts.isEmpty) {
          return Text(AppLocalizations.of(context).elNoDepts);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: depts.map((d) {
            return CheckboxListTile(
              title: Text(d.name),
              value: _selectedDepts.contains(d.id),
              onChanged: isDraft
                  ? (val) {
                      setState(() {
                        if (val == true) {
                          _selectedDepts.add(d.id);
                        } else {
                          _selectedDepts.remove(d.id);
                        }
                      });
                      _saveSelection();
                    }
                  : null,
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildMemberSelector(bool isDraft) {
    // For V1 UI, using a simple multi-select from directory provider
    final membersAsync =
        ref.watch(organizationMembersDirectoryProvider(widget.orgId));
    return membersAsync.when(
      loading: () => const LoadingView(),
      error: (e, _) => Text(AppLocalizations.of(context).elListError),
      data: (members) {
        final activeMembers =
            members.where((m) => m['status'] == 'active').toList();
        if (activeMembers.isEmpty) {
          return Text(AppLocalizations.of(context).elNoMembers);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                Text(
                  AppLocalizations.of(context).elSelected(
                      _selectedUsers.length.toString(),
                      activeMembers.length.toString()),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                ),
                if (isDraft)
                  RaayButton(
                    type: RaayButtonType.ghost,
                    icon: RaayIcons.fileSpreadsheet,
                    label: AppLocalizations.of(context).elCsv,
                    isExpanded: false,
                    onPressed: () async {
                      final matchedUids = await showDialog<List<String>>(
                        context: context,
                        builder: (ctx) => CsvImportModal(
                          organizationMembers: activeMembers,
                        ),
                      );
                      if (matchedUids != null && mounted) {
                        setState(() {
                          // Merge imported UIDs with existing selected users
                          _selectedUsers =
                              {..._selectedUsers, ...matchedUids}.toList();
                        });
                        _saveSelection();
                      }
                    },
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: activeMembers.length,
                itemBuilder: (ctx, i) {
                  final m = activeMembers[i];
                  final uid = m['userId'] as String;
                  final name = m['displayName'] as String;
                  return CheckboxListTile(
                    title: Text(name),
                    subtitle: Text(m['email'] as String),
                    value: _selectedUsers.contains(uid),
                    onChanged: isDraft
                        ? (val) {
                            setState(() {
                              if (val == true) {
                                _selectedUsers.add(uid);
                              } else {
                                _selectedUsers.remove(uid);
                              }
                            });
                            _saveSelection();
                          }
                        : null,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
