import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/raay_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../voting_events/domain/csv_email_parser.dart';
import '../data/organization_repository.dart';

/// Imports up to 25 member addresses and creates one-time invitation links.
/// Links are shown for manual delivery; this flow does not send email.
class BulkInviteDialog extends ConsumerStatefulWidget {
  const BulkInviteDialog({super.key, required this.organizationId});

  final String organizationId;

  @override
  ConsumerState<BulkInviteDialog> createState() => _BulkInviteDialogState();
}

class _BulkInviteDialogState extends ConsumerState<BulkInviteDialog> {
  static const _maxBatchSize = 25;
  final _controller = TextEditingController();
  final _parser = const CsvEmailParser();
  List<String> _emails = const [];
  final List<({String email, String? link, String? error})> _outcomes = [];
  bool _sending = false;
  bool _complete = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _chooseFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['csv'],
        allowMultiple: false,
        withData: true,
      );
      if (result == null || result.files.isEmpty || !mounted) return;
      final file = result.files.single;
      final bytes = file.bytes;
      if (bytes == null) {
        throw const FormatException('unreadable');
      }
      if (bytes.length > 2 * 1024 * 1024) {
        throw const FormatException('too-large');
      }
      _controller.text = utf8.decode(bytes, allowMalformed: false);
      setState(() {
        _emails = const [];
        _error = null;
      });
    } on FormatException catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        setState(() => _error = e.message == 'too-large'
            ? l10n.bulkInviteTooLarge
            : l10n.bulkInviteFileUnreadable);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = AppLocalizations.of(context).bulkInviteOpenFailed);
      }
    }
  }

  void _preview() {
    final l10n = AppLocalizations.of(context);
    final emails = _parser.parse(_controller.text);
    setState(() {
      _error = null;
      _emails = emails.take(_maxBatchSize).toList(growable: false);
      if (emails.isEmpty) _error = l10n.bulkInviteNoValid;
      if (emails.length > _maxBatchSize) {
        _error = l10n.bulkInviteCapped(_maxBatchSize);
      }
    });
  }

  Future<void> _sendInvitations() async {
    if (_sending || _emails.isEmpty) return;
    setState(() {
      _sending = true;
      _complete = false;
      _outcomes.clear();
      _error = null;
    });
    final repository = ref.read(organizationRepositoryProvider);
    for (final email in _emails) {
      try {
        final result = await repository.inviteMember(
          organizationId: widget.organizationId,
          email: email,
          role: 'member',
        );
        _outcomes.add((
          email: email,
          link: result.rawToken.isEmpty
              ? null
              : OrganizationRepository.buildInviteLink(result.rawToken),
          error: null,
        ));
      } catch (e) {
        _outcomes.add((email: email, link: null, error: e.toString()));
      }
      if (mounted) setState(() {});
    }
    if (mounted) {
      setState(() {
        _sending = false;
        _complete = true;
      });
    }
  }

  Future<void> _copyLinks() async {
    final links =
        _outcomes.where((o) => o.link != null).map((o) => o.link!).join('\n');
    if (links.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: links));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).bulkInviteCopied)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    final l10n = AppLocalizations.of(context);
    final successCount = _outcomes.where((o) => o.link != null).length;
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: [
                Expanded(
                    child: Text(
                        _complete
                            ? l10n.bulkInviteResultsTitle
                            : l10n.bulkInviteTitle,
                        style: Theme.of(context).textTheme.titleLarge)),
                IconButton(
                    tooltip:
                        MaterialLocalizations.of(context).closeButtonTooltip,
                    onPressed: _sending ? null : () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded)),
              ]),
              const SizedBox(height: 8),
              Text(
                  _complete
                      ? l10n.bulkInviteSummary(successCount, _outcomes.length)
                      : l10n.bulkInviteIntro(_maxBatchSize),
                  style: TextStyle(color: kc.textSecondary, height: 1.4)),
              if (!_complete) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: OutlinedButton.icon(
                      onPressed: _sending ? null : _chooseFile,
                      icon: const Icon(Icons.upload_file_rounded),
                      label: Text(l10n.bulkInviteChooseFile)),
                ),
                const SizedBox(height: 8),
                TextField(
                    controller: _controller,
                    minLines: 5,
                    maxLines: 8,
                    enabled: !_sending,
                    decoration: InputDecoration(
                      labelText: l10n.bulkInviteFieldLabel,
                      hintText: 'email\nmember@example.org',
                      border: const OutlineInputBorder(),
                    )),
                if (_emails.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                        l10n.bulkInviteReady(_emails.length)),
                  ),
              ],
              if (_error != null)
                Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child:
                        Text(_error!, style: TextStyle(color: kc.errorText))),
              if (_sending) ...[
                const SizedBox(height: 16),
                LinearProgressIndicator(
                    value: _emails.isEmpty
                        ? null
                        : _outcomes.length / _emails.length),
                const SizedBox(height: 8),
                Text(
                    l10n.bulkInviteProgress(_outcomes.length + 1, _emails.length)),
              ],
              if (_complete) ...[
                const SizedBox(height: 12),
                Expanded(
                    child: ListView.builder(
                        itemCount: _outcomes.length,
                        itemBuilder: (context, index) {
                          final outcome = _outcomes[index];
                          return ListTile(
                            dense: true,
                            leading: Icon(
                                outcome.link == null
                                    ? Icons.error_outline_rounded
                                    : Icons.check_circle_outline_rounded,
                                color: outcome.link == null
                                    ? kc.errorText
                                    : kc.successText),
                            title: Text(outcome.email),
                            subtitle: outcome.link == null
                                ? Text(outcome.error ?? l10n.bulkInviteFailed)
                                : SelectableText(outcome.link!, maxLines: 2),
                          );
                        })),
                OutlinedButton.icon(
                    onPressed: successCount == 0 ? null : _copyLinks,
                    icon: const Icon(Icons.copy_rounded),
                    label: Text(l10n.bulkInviteCopyLinks)),
              ],
              const SizedBox(height: 16),
              if (!_complete)
                Row(children: [
                  Expanded(
                      child: OutlinedButton(
                          onPressed:
                              _sending ? null : () => Navigator.pop(context),
                          child: Text(MaterialLocalizations.of(context)
                              .cancelButtonLabel))),
                  const SizedBox(width: 12),
                  if (_emails.isEmpty)
                    Expanded(
                        child: FilledButton(
                            onPressed: _sending ? null : _preview,
                            child: Text(l10n.bulkInvitePreview)))
                  else
                    Expanded(
                        child: FilledButton.icon(
                            onPressed: _sending ? null : _sendInvitations,
                            icon: const Icon(Icons.send_rounded),
                            label: Text(l10n.bulkInviteCreate))),
                ])
              else
                FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                        MaterialLocalizations.of(context).closeButtonLabel)),
            ],
          ),
        ),
      ),
    );
  }
}
