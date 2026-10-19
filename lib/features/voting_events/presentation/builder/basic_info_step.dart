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

  @override
  Widget build(BuildContext context) {
    final isDraft = ref.watch(draftEventProvider(widget.orgId)).status == VotingEventStatus.draft;
    final isDesktop = ResponsiveLayout.isWide(context);

    return Form(
      key: _formKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Main Form Card
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: KivoraColors.surfaceOf(context),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: KivoraColors.borderOf(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isDraft) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lock_outline_rounded, size: 16, color: KivoraColors.textSecondaryOf(context)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Event is no longer a DRAFT. Basic info is strictly immutable.',
                              style: TextStyle(color: KivoraColors.textSecondaryOf(context), fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],

                  // Form Section Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.edit_calendar_outlined,
                          color: AppTheme.primaryBlue,
                          size: 22,
                        ),
                      ),
                      SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Event Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: KivoraColors.textPrimaryOf(context),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Provide the basic information about your voting event.',
                            style: TextStyle(fontSize: 13, color: KivoraColors.textSecondaryOf(context)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 28),

                  // Event Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Event Title *',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: KivoraColors.textPrimaryOf(context),
                        ),
                      ),
                      Text(
                        '${_titleCtrl.text.length}/100',
                        style: TextStyle(fontSize: 11, color: KivoraColors.textSecondaryOf(context)),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  TextFormField(
                    controller: _titleCtrl,
                    enabled: isDraft,
                    maxLength: 100,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Annual Team Selection',
                      counterText: '',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().length < 3 || v.trim().length > 100) {
                        return 'Title must be 3-100 characters.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Description
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Description *',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: KivoraColors.textPrimaryOf(context),
                        ),
                      ),
                      Text(
                        '${_descCtrl.text.length}/500',
                        style: TextStyle(fontSize: 11, color: KivoraColors.textSecondaryOf(context)),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  TextFormField(
                    controller: _descCtrl,
                    enabled: isDraft,
                    maxLines: 4,
                    maxLength: 500,
                    decoration: const InputDecoration(
                      hintText: 'Describe the purpose, context and important details about this event...',
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
                  SizedBox(height: 24),

                  // Voting Type
                  Text(
                    'Voting Type',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: KivoraColors.textPrimaryOf(context),
                    ),
                  ),
                  SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cardWidth = constraints.maxWidth >= 600
                          ? (constraints.maxWidth - 24) / 3
                          : double.infinity;

                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildVotingTypeOption(
                            type: VotingType.candidateElection,
                            title: 'Candidate Election',
                            subtitle: 'Voters select one candidate from a roster.',
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
                  SizedBox(height: 24),

                  // Ballot Privacy Dropdown
                  Text(
                    'Ballot privacy',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: KivoraColors.textPrimaryOf(context),
                    ),
                  ),
                  SizedBox(height: 6),
                  DropdownButtonFormField<PrivacyMode>(
                    initialValue: _privacyMode,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.shield_outlined, color: AppTheme.primaryBlue, size: 20),
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
                            if (value != null) setState(() => _privacyMode = value);
                          }
                        : null,
                  ),
                  SizedBox(height: 6),
                  Text(
                    _privacyMode == PrivacyMode.anonymous
                        ? 'Voter identity is stored separately from the ballot.'
                        : 'Each ballot is associated with the voter’s account. Voters will see this notice before confirming.',
                    style: TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context)),
                  ),

                  SizedBox(height: 32),

                  // Bottom Action Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton.icon(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ref.read(draftEventProvider(widget.orgId).notifier).updateBasicInfo(
                                  _titleCtrl.text.trim(),
                                  _descCtrl.text.trim(),
                                  _type,
                                  _privacyMode,
                                );
                            widget.onNext();
                          }
                        },
                        icon: Text('Next: Schedule'),
                        label: Icon(Icons.arrow_forward_rounded, size: 16),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Right Quick Tips Sidebar (Desktop)
          if (isDesktop) ...[
            SizedBox(width: 24),
            SizedBox(
              width: 300,
              child: _buildQuickTipsCard(context),
            ),
          ],
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
            color: isSelected ? AppTheme.primaryBlue.withValues(alpha: 0.12).withValues(alpha: 0.5) : KivoraColors.surfaceOf(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppTheme.primaryBlue : KivoraColors.borderOf(context),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
                color: isSelected ? AppTheme.primaryBlue : KivoraColors.textSecondaryOf(context),
                size: 18,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, size: 16, color: AppTheme.primaryBlue),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: isSelected ? AppTheme.primaryBlue : KivoraColors.textPrimaryOf(context),
                            ),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 11, color: KivoraColors.textSecondaryOf(context), height: 1.3),
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

  Widget _buildQuickTipsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: KivoraColors.borderOf(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.lightbulb_outline_rounded, color: AppTheme.primaryBlue, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                'Quick Tips',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: KivoraColors.textPrimaryOf(context)),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'A well-structured event helps you get better participation and more meaningful results.',
            style: TextStyle(color: KivoraColors.textSecondaryOf(context), fontSize: 13, height: 1.4),
          ),
          SizedBox(height: 20),
          Divider(height: 1, color: KivoraColors.borderOf(context)),
          SizedBox(height: 20),

          _buildCheckItem('Use a clear and specific title'),
          _buildCheckItem('Add relevant details in the description'),
          _buildCheckItem('Choose the right voting type'),
          _buildCheckItem('Keep your audience in mind'),

          SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: KivoraColors.surfaceOf(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: KivoraColors.borderOf(context)),
            ),
            child: Row(
              children: [
                Icon(Icons.shield_outlined, color: AppTheme.primaryBlue, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Your event will be visible to all eligible members in your organization.',
                    style: TextStyle(fontSize: 11, color: KivoraColors.textSecondaryOf(context), height: 1.3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, size: 10, color: Colors.white),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: KivoraColors.textPrimaryOf(context), fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
