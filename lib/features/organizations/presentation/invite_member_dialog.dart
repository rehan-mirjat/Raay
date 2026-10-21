import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kivora/core/theme/kivora_icons.dart';
import 'package:kivora/core/widgets/ui_kit/kivora_button.dart';
import 'package:kivora/core/widgets/ui_kit/kivora_text_field.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/utils/validators.dart';
import '../data/organization_repository.dart';
import '../../../core/utils/friendly_error.dart';

class InviteMemberDialog extends ConsumerStatefulWidget {
  const InviteMemberDialog({
    super.key,
    required this.organizationId,
    required this.organizationName,
    required this.isOwner,
  });

  final String organizationId;
  final String organizationName;
  final bool isOwner;

  @override
  ConsumerState<InviteMemberDialog> createState() => _InviteMemberDialogState();
}

class _InviteMemberDialogState extends ConsumerState<InviteMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  late String _selectedRole;
  bool _isLoading = false;
  String? _error;
  String? _invitedEmail;
  String? _inviteLink;
  bool _linkCopied = false;

  @override
  void initState() {
    super.initState();
    _selectedRole = 'member';
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repo = ref.read(organizationRepositoryProvider);
      final result = await repo.inviteMember(
        organizationId: widget.organizationId,
        email: _emailController.text.trim(),
        role: widget.isOwner ? _selectedRole : 'member',
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _invitedEmail = result.email;
          _inviteLink = result.rawToken.isNotEmpty
              ? OrganizationRepository.buildInviteLink(result.rawToken)
              : null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = friendlyError(e);
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    if (_invitedEmail != null) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: kc.surface,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(KivoraIcons.checkCircle2,
                          color: AppTheme.success, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Invitation Created',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kc.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'An invitation was created for $_invitedEmail.',
                  style: TextStyle(fontSize: 14, color: kc.textPrimary, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'The invitee will see it in Kivora Notifications after logging in. They can accept or decline there.',
                  style: TextStyle(fontSize: 13, color: kc.textSecondary, height: 1.4),
                ),
                if (_inviteLink != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Share this direct link with the invitee:',
                    style: TextStyle(fontSize: 12, color: kc.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: kc.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: kc.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _inviteLink!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, color: kc.textPrimary),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _linkCopied ? KivoraIcons.check : KivoraIcons.copy,
                            size: 18,
                            color: _linkCopied ? AppTheme.success : AppTheme.primaryBlue,
                          ),
                          onPressed: () async {
                            await Clipboard.setData(ClipboardData(text: _inviteLink!));
                            if (mounted) setState(() => _linkCopied = true);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                KivoraButton(
                  label: 'Done',
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: kc.surface,
      child: SizedBox(
        width: (screenWidth - 80).clamp(280.0, 480.0),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(KivoraIcons.userPlus,
                                color: AppTheme.primaryBlue, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Invite Member',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kc.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(KivoraIcons.x, size: 20),
                        onPressed: _isLoading ? null : () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Invite someone to join your workspace.',
                    style: TextStyle(fontSize: 13, color: kc.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  KivoraTextField(
                    controller: _emailController,
                    label: 'Recipient Email Address *',
                    hint: 'voter@organization.com',
                    prefixIcon: KivoraIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),
                  KivoraTextField(
                    label: 'Organization',
                    controller: TextEditingController(text: widget.organizationName),
                    prefixIcon: KivoraIcons.building,
                  ),
                  const SizedBox(height: 16),
                  if (widget.isOwner) ...[
                    const Text(
                      'Role Permission',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedRole,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(KivoraIcons.shieldCheck, size: 20),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'member', child: Text('Member')),
                        DropdownMenuItem(value: 'admin', child: Text('Admin')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedRole = val);
                      },
                    ),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Text(_error!, style: const TextStyle(color: AppTheme.error, fontSize: 13)),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: KivoraButton(
                          type: KivoraButtonType.secondary,
                          label: 'Cancel',
                          onPressed: _isLoading ? null : () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: KivoraButton(
                          label: 'Send Invitation',
                          icon: KivoraIcons.send,
                          isLoading: _isLoading,
                          onPressed: _submit,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
