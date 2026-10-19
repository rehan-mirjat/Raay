import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/utils/validators.dart';
import '../data/organization_repository.dart';

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
          _error = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_invitedEmail != null) {
      return AlertDialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        scrollable: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle_outline, color: AppTheme.success, size: 24),
            SizedBox(width: 10),
            Expanded(
                child: Text('Invitation Created',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: KivoraColors.textPrimaryOf(context)))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'An invitation was created for $_invitedEmail.',
              style:
                  TextStyle(fontSize: 14, color: KivoraColors.textSecondaryOf(context)),
            ),
            SizedBox(height: 16),
            Text(
              'The invitee will see it in Kivora Notifications after creating or signing into a verified account with this email address. They can accept or decline it there.',
              style: TextStyle(
                  fontSize: 13, color: KivoraColors.textSecondaryOf(context), height: 1.45),
            ),
            if (_inviteLink != null) ...[
              SizedBox(height: 16),
              Text(
                'Or share this invite link directly - there\'s no automatic email, so share it however you prefer (email, chat, etc.):',
                style: TextStyle(
                    fontSize: 12, color: KivoraColors.textSecondaryOf(context), height: 1.4),
              ),
              SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: KivoraColors.backgroundOf(context),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: KivoraColors.borderOf(context)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _inviteLink!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12, color: KivoraColors.textPrimaryOf(context)),
                      ),
                    ),
                    SizedBox(width: 4),
                    IconButton(
                      tooltip: _linkCopied ? 'Copied' : 'Copy link',
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: _inviteLink!));
                        if (mounted) setState(() => _linkCopied = true);
                      },
                      constraints: const BoxConstraints(
                          minWidth: 44, minHeight: 44),
                      icon: Icon(
                        _linkCopied
                            ? Icons.check_rounded
                            : Icons.copy_rounded,
                        size: 18,
                        color: _linkCopied
                            ? AppTheme.success
                            : AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Done'),
          ),
        ],
      );
    }

    return AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Invite a new member',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: KivoraColors.textPrimaryOf(context)),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close,
                    color: KivoraColors.textSecondaryOf(context), size: 20),
                onPressed: _isLoading ? null : () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            'Invite someone to your organization. They can respond from Notifications.',
            style: TextStyle(fontSize: 13, color: KivoraColors.textSecondaryOf(context)),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 8),
                Text('EMAIL ADDRESS',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        color: KivoraColors.textPrimaryOf(context),
                        letterSpacing: 0.5)),
                SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Recipient Email Address *',
                    hintText: 'voter@organization.com',
                    prefixIcon: Icon(Icons.email_outlined, size: 20),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: Validators.email,
                ),
                SizedBox(height: 20),
                Text('ORGANIZATION',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        color: KivoraColors.textPrimaryOf(context),
                        letterSpacing: 0.5)),
                SizedBox(height: 8),
                TextFormField(
                  initialValue: widget.organizationName,
                  readOnly: true,
                  enabled: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.business_outlined, size: 20),
                  ),
                ),
                SizedBox(height: 20),
                Text('ROLE',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        color: KivoraColors.textPrimaryOf(context),
                        letterSpacing: 0.5)),
                SizedBox(height: 8),
                if (widget.isOwner)
                  DropdownButtonFormField<String>(
                    initialValue: _selectedRole,
                    decoration: const InputDecoration(
                      prefixIcon:
                          Icon(Icons.admin_panel_settings_outlined, size: 20),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'member', child: Text('Member')),
                      DropdownMenuItem(value: 'admin', child: Text('Admin')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedRole = val);
                    },
                  )
                else
                  TextFormField(
                    initialValue: 'Member',
                    readOnly: true,
                    enabled: false,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline, size: 20),
                      suffixIcon: Tooltip(
                        message: 'Admins can invite Member role only',
                        child: Icon(Icons.lock_outline,
                            size: 18, color: KivoraColors.textSecondaryOf(context)),
                      ),
                    ),
                  ),
                if (_error != null) ...[
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppTheme.error.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline,
                            color: AppTheme.error, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(_error!,
                              style: TextStyle(
                                  color: AppTheme.error,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _submit,
          icon: _isLoading
              ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
              : Icon(Icons.send_outlined, size: 18),
          label: Text(_isLoading ? 'Sending...' : 'Send Invitation'),
        ),
      ],
    );
  }
}
