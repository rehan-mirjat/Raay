import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/kivora_colors.dart';
import '../../../../core/layout/responsive.dart';
import '../../domain/voting_event.dart';
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

    _titleCtrl.addListener(() => setState(() {}));
    _descCtrl.addListener(() => setState(() {}));
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
  }

  void _showTemplateSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Election Template',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose a pre-configured template to speed up your election creation.',
                  style: TextStyle(
                      fontSize: 13,
                      color: KivoraColors.textSecondaryOf(context)),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.stars_rounded,
                      color: AppTheme.primaryBlue),
                  title: const Text('Executive / Board Election',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Candidate Election • Anonymous Ballot'),
                  onTap: () {
                    _applyTemplate(
                      'Executive Board Election',
                      'Annual election to select executive board representatives. Ballots are strictly anonymous.',
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
                  title: const Text('Policy / Resolution Vote',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Yes/No Poll • Anonymous Ballot'),
                  onTap: () {
                    _applyTemplate(
                      'Organization Policy Resolution',
                      'Vote on the proposed amendment to organization bylaws. Please review the attached documentation before voting.',
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
                  title: const Text('Community Opinion Poll',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Single-Choice Poll • Identifiable'),
                  onTap: () {
                    _applyTemplate(
                      'Community Feedback Survey',
                      'Short survey to collect community sentiment on upcoming initiatives.',
                      VotingType.singleChoicePoll,
                      PrivacyMode.identifiable,
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
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
    final kc = KivoraColors.of(context);
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
                color: KivoraColors.surfaceOf(context),
                borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                border: Border.all(color: KivoraColors.borderOf(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isDraft) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: KivoraColors.surfaceOf(context),
                        border:
                            Border.all(color: KivoraColors.borderOf(context)),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusInput),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lock_outline_rounded,
                              size: 16,
                              color: KivoraColors.textSecondaryOf(context)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Event is no longer a DRAFT. Basic info is strictly immutable.',
                              style: TextStyle(
                                  color: KivoraColors.textSecondaryOf(context),
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
                              'Election details',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kc.textPrimary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Provide the basic information about your election.',
                              style: TextStyle(
                                  fontSize: 14, color: kc.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      if (isDraft)
                        TextButton.icon(
                          style: TextButton.styleFrom(
                              minimumSize: const Size(48, 48)),
                          onPressed: () => _showTemplateSelector(context),
                          icon:
                              const Icon(Icons.auto_awesome_rounded, size: 18),
                          label: const Text('Use template'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Event Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        'Event Title *',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: KivoraColors.textPrimaryOf(context),
                        ),
                      )),
                      Text(
                        '${_titleCtrl.text.length}/100',
                        style: TextStyle(
                            fontSize: 12,
                            color: KivoraColors.textSecondaryOf(context)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _titleCtrl,
                    enabled: isDraft,
                    maxLength: 100,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Annual Team Selection',
                      counterText: '',
                    ),
                    validator: (v) {
                      if (v == null ||
                          v.trim().length < 3 ||
                          v.trim().length > 100) {
                        return 'Title must be 3-100 characters.';
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
                        'Description *',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: KivoraColors.textPrimaryOf(context),
                        ),
                      )),
                      Text(
                        '${_descCtrl.text.length}/500',
                        style: TextStyle(
                            fontSize: 12,
                            color: KivoraColors.textSecondaryOf(context)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _descCtrl,
                    enabled: isDraft,
                    maxLines: 4,
                    maxLength: 500,
                    decoration: const InputDecoration(
                      hintText:
                          'Describe the purpose, context and important details about this event...',
                      counterText: '',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Description is required.';
                      }
                      if (v.trim().length > 500) {
                        return 'Description cannot exceed 500 characters.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Voting Type
                  Text(
                    'Voting Type',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: KivoraColors.textPrimaryOf(context),
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
                            title: 'Candidate Election',
                            subtitle:
                                'Voters select one candidate from a roster.',
                            icon: Icons.person_outline_rounded,
                            width: cardWidth,
                            enabled: isDraft,
                          ),
                          _buildVotingTypeOption(
                            type: VotingType.singleChoicePoll,
                            title: 'Single-Choice Poll',
                            subtitle: 'Voters select one option from a list.',
                            icon: Icons.format_list_bulleted_rounded,
                            width: cardWidth,
                            enabled: isDraft,
                          ),
                          _buildVotingTypeOption(
                            type: VotingType.yesNoPoll,
                            title: 'Yes/No Poll',
                            subtitle: 'Voters approve or reject a proposal.',
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
                  Text(
                    'Ballot privacy',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: KivoraColors.textPrimaryOf(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<PrivacyMode>(
                    isExpanded: true,
                    initialValue: _privacyMode,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.shield_outlined, size: 20),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: PrivacyMode.anonymous,
                        child: Text('Anonymous'),
                      ),
                      DropdownMenuItem(
                        value: PrivacyMode.identifiable,
                        child: Text('Identifiable'),
                      ),
                    ],
                    onChanged: isDraft
                        ? (value) {
                            if (value != null) {
                              setState(() => _privacyMode = value);
                            }
                          }
                        : null,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _privacyMode == PrivacyMode.anonymous
                        ? 'Voter identity is stored separately from the ballot.'
                        : 'Each ballot is associated with the voter’s account. Voters will see this notice before confirming.',
                    style: TextStyle(
                        fontSize: 14,
                        color: KivoraColors.textSecondaryOf(context)),
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
                            child: const Text('Next: Schedule'),
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
        onTap: enabled ? () => setState(() => _type = type) : null,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: width,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.10)
                : KivoraColors.surfaceOf(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : KivoraColors.borderOf(context),
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
                    ? KivoraColors.of(context).accentText
                    : KivoraColors.textSecondaryOf(context),
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
                            color: KivoraColors.of(context).accentText),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: isSelected
                                  ? KivoraColors.of(context).accentText
                                  : KivoraColors.textPrimaryOf(context),
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
                          color: KivoraColors.textSecondaryOf(context),
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
