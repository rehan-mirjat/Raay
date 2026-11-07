import '../../../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/raay_colors.dart';
import '../../../../core/layout/responsive.dart';
import '../../domain/voting_event.dart';
import '../../domain/event_template_store.dart';
import '../providers/draft_event_provider.dart';

class BasicInfoStep extends ConsumerStatefulWidget {
  final String orgId;
  final VoidCallback onNext;

  const BasicInfoStep({super.key, required this.orgId, required this.onNext});

  @override
  ConsumerState<BasicInfoStep> createState() => _BasicInfoStepState();
}

class _BasicInfoStepState extends ConsumerState<BasicInfoStep> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  VotingType _type = VotingType.candidateElection;
  PrivacyMode _privacyMode = PrivacyMode.anonymous;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(draftEventProvider(widget.orgId));
    _titleCtrl = TextEditingController(text: draft.title);
    _descCtrl = TextEditingController(text: draft.description);
    _type = draft.votingType;
    _privacyMode = draft.privacyMode;

    // Every edit goes to the draft right away, so the builder's exit guard
    // sees typed-but-not-yet-continued changes as unsaved work.
    _titleCtrl.addListener(() {
      setState(() {});
      _syncDraft();
    });
    _descCtrl.addListener(() {
      setState(() {});
      _syncDraft();
    });
  }

  void _syncDraft() {
    if (!mounted) return;
    ref
        .read(draftEventProvider(widget.orgId).notifier)
        .updateBasicInfo(_titleCtrl.text, _descCtrl.text, _type, _privacyMode);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _applyTemplate(
    String title,
    String desc,
    VotingType type,
    PrivacyMode privacy,
  ) {
    setState(() {
      _titleCtrl.text = title;
      _descCtrl.text = desc;
      _type = type;
      _privacyMode = privacy;
    });
    _syncDraft();
  }

  Future<void> _saveCurrentTemplate() async {
    final nameController = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(dialogContext).tplSaveTitle),
        content: TextField(
          controller: nameController,
          autofocus: true,
          maxLength: 48,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(dialogContext).tplNameLabel),
          onSubmitted: (value) => Navigator.pop(dialogContext, value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child:
                Text(MaterialLocalizations.of(dialogContext).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, nameController.text.trim()),
            child: Text(AppLocalizations.of(dialogContext).tplSave),
          ),
        ],
      ),
    );
    nameController.dispose();
    if (name == null || name.isEmpty || !mounted) return;
    try {
      await CloudEventTemplateStore.save(
        organizationId: widget.orgId,
        name: name,
        title: _titleCtrl.text,
        description: _descCtrl.text,
        votingType: _type,
        privacyMode: _privacyMode,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).tplShared)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).tplSaveFailed)),
        );
      }
    }
  }

  Future<void> _showTemplateSelector() async {
    final l10n = AppLocalizations.of(context);
    final savedTemplates = await EventTemplateStore.load(widget.orgId);
    List<EventTemplate> sharedTemplates = const [];
    String? sharedLoadError;
    try {
      sharedTemplates = await CloudEventTemplateStore.load(widget.orgId);
    } catch (_) {
      sharedLoadError = l10n.tplLoadSharedFailed;
    }
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: MediaQuery.sizeOf(context).height * 0.82,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context).biTemplateTitle,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).biTemplateBody,
                    style: TextStyle(
                        fontSize: 13,
                        color: RaayColors.textSecondaryOf(context)),
                  ),
                  const SizedBox(height: 20),
                  if (sharedLoadError != null) ...[
                    Text(sharedLoadError,
                        style: TextStyle(
                            color: RaayColors.of(context).errorText)),
                    const SizedBox(height: 8),
                  ],
                  ListTile(
                    leading: Icon(Icons.stars_rounded,
                        color: RaayColors.of(context).accentText),
                    title: Text(AppLocalizations.of(context).biT1Name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(AppLocalizations.of(context).biT1Sub),
                    onTap: () {
                      _applyTemplate(
                        AppLocalizations.of(context).biT1Title,
                        AppLocalizations.of(context).biT1Desc,
                        VotingType.candidateElection,
                        PrivacyMode.anonymous,
                      );
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.gavel_rounded,
                        color: AppTheme.accentTeal),
                    title: Text(AppLocalizations.of(context).biT2Name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(AppLocalizations.of(context).biT2Sub),
                    onTap: () {
                      _applyTemplate(
                        AppLocalizations.of(context).biT2Title,
                        AppLocalizations.of(context).biT2Desc,
                        VotingType.yesNoPoll,
                        PrivacyMode.anonymous,
                      );
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.poll_rounded,
                        color: AppTheme.accentGold),
                    title: Text(AppLocalizations.of(context).biT3Name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(AppLocalizations.of(context).biT3Sub),
                    onTap: () {
                      _applyTemplate(
                        AppLocalizations.of(context).biT3Title,
                        AppLocalizations.of(context).biT3Desc,
                        VotingType.singleChoicePoll,
                        PrivacyMode.identifiable,
                      );
                      Navigator.pop(context);
                    },
                  ),
                  if (savedTemplates.isNotEmpty) ...[
                    const Divider(height: 24),
                    Text(AppLocalizations.of(context).tplLegacyHeading,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    ...savedTemplates.map((template) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.bookmark_outline_rounded),
                          title: Text(template.name),
                          subtitle: Text(template.title),
                          onTap: () {
                            _applyTemplate(template.title, template.description,
                                template.votingType, template.privacyMode);
                            Navigator.pop(context);
                          },
                          trailing: IconButton(
                            tooltip: AppLocalizations.of(context).tplDelete,
                            icon: const Icon(Icons.delete_outline_rounded),
                            onPressed: () async {
                              await EventTemplateStore.delete(
                                  widget.orgId, template.id);
                              if (context.mounted) Navigator.pop(context);
                              if (mounted) _showTemplateSelector();
                            },
                          ),
                        )),
                  ],
                  if (sharedTemplates.isNotEmpty) ...[
                    const Divider(height: 24),
                    Text(AppLocalizations.of(context).tplSharedHeading,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    ...sharedTemplates.map((template) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.groups_2_outlined),
                          title: Text(template.name),
                          subtitle: Text(template.title),
                          onTap: () {
                            _applyTemplate(template.title, template.description,
                                template.votingType, template.privacyMode);
                            Navigator.pop(context);
                          },
                          trailing: IconButton(
                            tooltip: AppLocalizations.of(context).tplDeleteShared,
                            icon: const Icon(Icons.delete_outline_rounded),
                            onPressed: () async {
                              try {
                                await CloudEventTemplateStore.delete(
                                    widget.orgId, template.id);
                                if (context.mounted) Navigator.pop(context);
                                if (mounted) _showTemplateSelector();
                              } catch (_) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(AppLocalizations.of(context)
                                            .tplDeleteSharedFailed)),
                                  );
                                }
                              }
                            },
                          ),
                        )),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDraft = ref.watch(draftEventProvider(widget.orgId)).status ==
        VotingEventStatus.draft;
    final kc = RaayColors.of(context);
    final compact = ResponsiveLayout.isCompact(context);

    return Form(
      key: _formKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Main Form Card
          Expanded(
            child: Container(
              padding: EdgeInsets.all(compact ? 16 : 24),
              decoration: BoxDecoration(
                color: RaayColors.surfaceOf(context),
                borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                border: Border.all(color: RaayColors.borderOf(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isDraft) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: RaayColors.surfaceOf(context),
                        border:
                            Border.all(color: RaayColors.borderOf(context)),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusInput),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lock_outline_rounded,
                              size: 16,
                              color: RaayColors.textSecondaryOf(context)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context).biLocked,
                              style: TextStyle(
                                  color: RaayColors.textSecondaryOf(context),
                                  fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Form Section Header
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context).biTitle,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kc.textPrimary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              AppLocalizations.of(context).biSubtitle,
                              style: TextStyle(
                                  fontSize: 14, color: kc.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      if (isDraft)
                        Wrap(spacing: 4, runSpacing: 4, children: [
                          TextButton.icon(
                            style: TextButton.styleFrom(
                                minimumSize: const Size(48, 48)),
                            onPressed: _showTemplateSelector,
                            icon: const Icon(Icons.auto_awesome_rounded,
                                size: 18),
                            label: Text(
                                AppLocalizations.of(context).biUseTemplate),
                          ),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                                minimumSize: const Size(48, 48)),
                            onPressed: _saveCurrentTemplate,
                            icon: const Icon(Icons.bookmark_add_outlined,
                                size: 18),
                            label: Text(AppLocalizations.of(context).tplSaveSetup),
                          ),
                        ]),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Event Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        AppLocalizations.of(context).biTitleLabel,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: RaayColors.textPrimaryOf(context),
                        ),
                      )),
                      Text(
                        '${_titleCtrl.text.length}/100',
                        style: TextStyle(
                            fontSize: 12,
                            color: RaayColors.textSecondaryOf(context)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _titleCtrl,
                    enabled: isDraft,
                    maxLength: 100,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).biTitleHint,
                      counterText: '',
                    ),
                    validator: (v) {
                      if (v == null ||
                          v.trim().length < 3 ||
                          v.trim().length > 100) {
                        return AppLocalizations.of(context).biTitleInvalid;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        AppLocalizations.of(context).biDescLabel,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: RaayColors.textPrimaryOf(context),
                        ),
                      )),
                      Text(
                        '${_descCtrl.text.length}/500',
                        style: TextStyle(
                            fontSize: 12,
                            color: RaayColors.textSecondaryOf(context)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _descCtrl,
                    enabled: isDraft,
                    maxLines: 4,
                    maxLength: 500,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).biDescHint,
                      counterText: '',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return AppLocalizations.of(context).biDescRequired;
                      }
                      if (v.trim().length > 500) {
                        return AppLocalizations.of(context).biDescLong;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Voting Type
                  Text(
                    AppLocalizations.of(context).biVotingType,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: RaayColors.textPrimaryOf(context),
                    ),
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cardWidth = constraints.maxWidth >= 560
                          ? (constraints.maxWidth - 24) / 3
                          : double.infinity;

                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildVotingTypeOption(
                            type: VotingType.candidateElection,
                            title: AppLocalizations.of(context).biTypeCandidate,
                            subtitle:
                                AppLocalizations.of(context).biTypeCandidateSub,
                            icon: Icons.person_outline_rounded,
                            width: cardWidth,
                            enabled: isDraft,
                          ),
                          _buildVotingTypeOption(
                            type: VotingType.singleChoicePoll,
                            title: AppLocalizations.of(context).biTypeSingle,
                            subtitle:
                                AppLocalizations.of(context).biTypeSingleSub,
                            icon: Icons.format_list_bulleted_rounded,
                            width: cardWidth,
                            enabled: isDraft,
                          ),
                          _buildVotingTypeOption(
                            type: VotingType.yesNoPoll,
                            title: AppLocalizations.of(context).biTypeYesNo,
                            subtitle:
                                AppLocalizations.of(context).biTypeYesNoSub,
                            icon: Icons.check_box_outlined,
                            width: cardWidth,
                            enabled: isDraft,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Ballot Privacy Dropdown
                  if (_type == VotingType.candidateElection) Material(
                    type: MaterialType.transparency,
                    child: SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(AppLocalizations.of(context).mcMode),
                    subtitle: Text(AppLocalizations.of(context).mcPolicy),
                    value: ref.watch(draftEventProvider(widget.orgId)).multiContest,
                    onChanged: !isDraft || ref.watch(draftEventProvider(widget.orgId)).serverEventId != null ? null
                        : (value) => ref.read(draftEventProvider(widget.orgId).notifier).setMultiContest(value),
                  )),
                  Text(
                    AppLocalizations.of(context).biPrivacy,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: RaayColors.textPrimaryOf(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<PrivacyMode>(
                    isExpanded: true,
                    initialValue: _privacyMode,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.shield_outlined, size: 20),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: PrivacyMode.anonymous,
                        child: Text(AppLocalizations.of(context).biAnonymous),
                      ),
                      DropdownMenuItem(
                        value: PrivacyMode.identifiable,
                        child:
                            Text(AppLocalizations.of(context).biIdentifiable),
                      ),
                    ],
                    onChanged: isDraft
                        ? (value) {
                            if (value != null) {
                              setState(() => _privacyMode = value);
                              _syncDraft();
                            }
                          }
                        : null,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _privacyMode == PrivacyMode.anonymous
                        ? AppLocalizations.of(context).biAnonymousNote
                        : AppLocalizations.of(context).biIdentifiableNote,
                    style: TextStyle(
                        fontSize: 14,
                        color: RaayColors.textSecondaryOf(context)),
                  ),

                  const SizedBox(height: 32),

                  // Bottom Action Button
                  Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Wrap(
                        children: [
                          FilledButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ref
                                    .read(draftEventProvider(widget.orgId)
                                        .notifier)
                                    .updateBasicInfo(
                                      _titleCtrl.text.trim(),
                                      _descCtrl.text.trim(),
                                      _type,
                                      _privacyMode,
                                    );
                                widget.onNext();
                              }
                            },
                            style: FilledButton.styleFrom(
                                minimumSize: const Size(48, 48)),
                            child: Text(AppLocalizations.of(context).biNext),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVotingTypeOption({
    required VotingType type,
    required String title,
    required String subtitle,
    required IconData icon,
    required double width,
    required bool enabled,
  }) {
    final isSelected = _type == type;

    return Opacity(
      // Matches the disabled look TextFormField already gets from `enabled:
      // isDraft` elsewhere on this screen - without this, a locked (non-draft)
      // event's cards looked exactly as interactive as an editable one, even
      // though onTap below is already correctly a no-op.
      opacity: enabled ? 1.0 : 0.5,
      child: InkWell(
        onTap: enabled
            ? () {
                setState(() => _type = type);
                _syncDraft();
              }
            : null,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: width,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.10)
                : RaayColors.surfaceOf(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : RaayColors.borderOf(context),
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: isSelected
                    ? RaayColors.of(context).accentText
                    : RaayColors.textSecondaryOf(context),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon,
                            size: 16,
                            color: RaayColors.of(context).accentText),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: isSelected
                                  ? RaayColors.of(context).accentText
                                  : RaayColors.textPrimaryOf(context),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                          fontSize: 13,
                          color: RaayColors.textSecondaryOf(context),
                          height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
