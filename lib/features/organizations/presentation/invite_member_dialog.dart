import '../../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raay/core/theme/raay_icons.dart';
import 'package:raay/core/widgets/ui_kit/raay_button.dart';
import 'package:raay/core/widgets/ui_kit/raay_text_field.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/raay_colors.dart';
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
    final kc = RaayColors.of(context);
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
                      child: Icon(RaayIcons.checkCircle2,
                          color: RaayColors.of(context).successText,
                          size: 22),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      AppLocalizations.of(context).imCreatedTitle,
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
                  AppLocalizations.of(context)
                      .imCreatedBody(_invitedEmail.toString()),
                  style: TextStyle(
                      fontSize: 14,
                      color: kc.textPrimary,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context).imCreatedNote,
                  style: TextStyle(
                      fontSize: 13, color: kc.textSecondary, height: 1.4),
                ),
                if (_inviteLink != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context).imShareLink,
                    style: TextStyle(fontSize: 12, color: kc.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                            style:
                                TextStyle(fontSize: 12, color: kc.textPrimary),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _linkCopied ? RaayIcons.check : RaayIcons.copy,
                            size: 18,
                            color: _linkCopied
                                ? AppTheme.success
                                : AppTheme.primaryBlue,
                          ),
                          onPressed: () async {
                            await Clipboard.setData(
                                ClipboardData(text: _inviteLink!));
                            if (mounted) setState(() => _linkCopied = true);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                RaayButton(
                  label: AppLocalizations.of(context).imDone,
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
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(RaayIcons.userPlus,
                            color: RaayColors.of(context).accentText,
                            size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Semantics(
                          header: true,
                          child: Text(
                            AppLocalizations.of(context).imTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kc.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: AppLocalizations.of(context).imClose,
                        constraints:
                            const BoxConstraints(minWidth: 48, minHeight: 48),
                        icon: const Icon(RaayIcons.x, size: 20),
                        onPressed:
                            _isLoading ? null : () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context).imSubtitle,
                    style: TextStyle(fontSize: 13, color: kc.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  RaayTextField(
                    controller: _emailController,
                    label: AppLocalizations.of(context).imEmailLabel,
                    hint: AppLocalizations.of(context).imEmailHint,
                    prefixIcon: RaayIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),
                  // Read-only: the invitation always goes to the active organization.
                  Semantics(
                    container: true,
                    label: AppLocalizations.of(context)
                        .imOrg(widget.organizationName.toString()),
                    child: ExcludeSemantics(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(RaayIcons.building,
                              size: 18, color: kc.textSecondary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context).imOrgLabel,
                                    style: TextStyle(
                                        fontSize: 14, color: kc.textSecondary)),
                                Text(widget.organizationName,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: kc.textPrimary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.isOwner) ...[
                    Text(
                      AppLocalizations.of(context).imRole,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _selectedRole,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(RaayIcons.shieldCheck, size: 20),
                      ),
                      items: [
                        DropdownMenuItem(
                            value: 'member',
                            child: Text(
                                AppLocalizations.of(context).imRoleMember)),
                        DropdownMenuItem(
                            value: 'admin',
                            child:
                                Text(AppLocalizations.of(context).imRoleAdmin)),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedRole = val);
                      },
                    ),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Text(_error!,
                        style: TextStyle(
                            color: RaayColors.of(context).errorText,
                            fontSize: 13)),
                  ],
                  const SizedBox(height: 24),
                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            minimumSize: const Size(48, 48)),
                        onPressed:
                            _isLoading ? null : () => Navigator.pop(context),
                        child: Text(AppLocalizations.of(context).imCancel),
                      ),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                            minimumSize: const Size(48, 48)),
                        onPressed: _isLoading ? null : _submit,
                        icon: _isLoading
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(RaayIcons.send, size: 18),
                        label: Text(AppLocalizations.of(context).imSend),
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
