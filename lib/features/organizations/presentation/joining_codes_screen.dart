import '../../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/stat_tile.dart';
import '../data/organization_repository.dart';
import '../../../core/theme/raay_colors.dart';
import '../../../core/widgets/status_badge.dart';
import '../domain/organization_enums.dart';
import 'providers/organization_providers.dart';
import '../../../core/utils/friendly_error.dart';

final organizationJoiningCodesProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, orgId) {
  return ref.watch(organizationRepositoryProvider).getJoiningCodes(orgId);
});

class JoiningCodesScreen extends ConsumerStatefulWidget {
  const JoiningCodesScreen({super.key});

  @override
  ConsumerState<JoiningCodesScreen> createState() => _JoiningCodesScreenState();
}

class _JoiningCodesScreenState extends ConsumerState<JoiningCodesScreen> {
  int _expiryHours = 168;
  final _maxUsesController = TextEditingController(text: '0');
  bool _creating = false;
  final _dateFormat = DateFormat.yMMMd().add_jm();

  @override
  void dispose() {
    _maxUsesController.dispose();
    super.dispose();
  }

  Future<void> _create(String orgId) async {
    final maxUses = int.tryParse(_maxUsesController.text.trim());
    if (maxUses == null || maxUses < 0 || maxUses > 100000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).jcMaxUsesInvalid)),
      );
      return;
    }
    setState(() => _creating = true);
    try {
      final result =
          await ref.read(organizationRepositoryProvider).createJoiningCode(
                organizationId: orgId,
                expiresInHours: _expiryHours,
                maxUses: maxUses,
              );
      ref.invalidate(organizationJoiningCodesProvider(orgId));
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          var copied = false;
          return StatefulBuilder(
            builder: (context, setDialogState) => AlertDialog(
              icon: Icon(Icons.key_rounded,
                  color: RaayColors.of(context).accentText),
              title: Text(AppLocalizations.of(context).jcSaveTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(AppLocalizations.of(context).jcShownOnce),
                  const SizedBox(height: 16),
                  SelectableText(
                    result.rawCode,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: QrImageView(
                        data: 'raay-JOIN:${result.rawCode}',
                        version: QrVersions.auto,
                        size: 160,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context).jcScanHint,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              actions: [
                TextButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(
                        ClipboardData(text: result.rawCode));
                    // In-dialog feedback: a SnackBar would render behind the modal barrier.
                    if (context.mounted) setDialogState(() => copied = true);
                  },
                  icon: Icon(copied ? Icons.check_rounded : Icons.copy_rounded),
                  label: Text(copied
                      ? AppLocalizations.of(context).jcCopied
                      : AppLocalizations.of(context).jcCopy),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(AppLocalizations.of(context).jcDone),
                ),
              ],
            ),
          );
        },
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(friendlyError(error)),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  Future<void> _revoke(String orgId, Map<String, dynamic> code) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context).jcRevokeTitle),
        content: Text(AppLocalizations.of(context)
            .jcRevokeBody((code['displayId'] ?? 'Joining code').toString())),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(AppLocalizations.of(context).jcCancel)),
          FilledButton.tonal(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(AppLocalizations.of(context).jcRevoke)),
        ],
      ),
    );
    if (confirmed != true) return;
    final codeId = code['codeId'] as String?;
    if (codeId == null || codeId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).jcRevokeNoId),
            backgroundColor: AppTheme.error,
          ),
        );
      }
      return;
    }
    try {
      await ref.read(organizationRepositoryProvider).revokeJoiningCode(codeId);
      ref.invalidate(organizationJoiningCodesProvider(orgId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).jcRevoked)),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(friendlyError(error)),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final contextState = ref.watch(activeOrganizationContextProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).jcTitle),
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context).jcRefresh,
            onPressed: () {
              final orgId = contextState.valueOrNull?.context?.organization.id;
              if (orgId != null) {
                ref.invalidate(organizationJoiningCodesProvider(orgId));
              }
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: contextState.when(
        loading: () =>
            LoadingView(message: AppLocalizations.of(context).jcLoading),
        error: (error, _) => ErrorView(
          type: ErrorViewType.generic,
          message: AppLocalizations.of(context).jcOrgLoadError,
          onRetry: () => ref.invalidate(activeOrganizationContextProvider),
        ),
        data: (active) {
          final orgContext = active.context;
          if (orgContext == null) {
            return EmptyView(
              icon: Icons.business_outlined,
              title: AppLocalizations.of(context).jcNoOrgTitle,
              message: AppLocalizations.of(context).jcNoOrgBody,
            );
          }
          final role = orgContext.member.role;
          if (!role.isAdmin) {
            return ErrorView(
              type: ErrorViewType.generic,
              title: AppLocalizations.of(context).jcAdminTitle,
              message: AppLocalizations.of(context).jcAdminBody,
            );
          }

          final orgId = orgContext.organization.id;
          final codes = ref.watch(organizationJoiningCodesProvider(orgId));
          final compact = ResponsiveLayout.isCompact(context);
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: ListView(
                padding: EdgeInsets.all(compact ? 16 : 28),
                children: [
                  Text(orgContext.organization.name,
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 6),
                  Text(AppLocalizations.of(context).jcSubtitle),
                  const SizedBox(height: 20),
                  codes.maybeWhen(
                    data: (items) {
                      final c = countJoiningCodes(items);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: StatTileRow(columnsWide: 3, tiles: [
                          StatTile(
                              label: AppLocalizations.of(context).jcStatActive,
                              value: c.active),
                          StatTile(
                              label: AppLocalizations.of(context).jcStatExpired,
                              value: c.expired),
                          StatTile(
                              label: AppLocalizations.of(context).jcStatRevoked,
                              value: c.revoked),
                        ]),
                      );
                    },
                    orElse: () => const SizedBox.shrink(),
                  ),
                  _buildCreateCard(compact, orgId),
                  const SizedBox(height: 20),
                  Text(AppLocalizations.of(context).jcExisting,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  codes.when(
                    loading: () => const LoadingView(),
                    error: (error, _) => ErrorView(
                      type: ErrorViewType.generic,
                      message: AppLocalizations.of(context).jcLoadError,
                      onRetry: () => ref
                          .invalidate(organizationJoiningCodesProvider(orgId)),
                    ),
                    data: (items) => items.isEmpty
                        ? Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(AppLocalizations.of(context).jcEmpty),
                            ),
                          )
                        : Column(
                            children: items
                                .map((item) => _codeCard(orgId, item))
                                .toList(),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCreateCard(bool compact, String orgId) => Card(
        child: Padding(
          padding: EdgeInsets.all(compact ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(AppLocalizations.of(context).jcCreateTitle,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(AppLocalizations.of(context).jcCreateNote),
              const SizedBox(height: 16),
              if (compact)
                Column(
                  children: [
                    _expiryPicker(),
                    const SizedBox(height: 12),
                    _maxUsesField(),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(child: _expiryPicker()),
                    const SizedBox(width: 14),
                    Expanded(child: _maxUsesField()),
                  ],
                ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _creating ? null : () => _create(orgId),
                icon: _creating
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.add_link_rounded),
                label: Text(_creating
                    ? AppLocalizations.of(context).jcCreating
                    : AppLocalizations.of(context).jcCreate),
              ),
            ],
          ),
        ),
      );

  Widget _expiryPicker() => DropdownButtonFormField<int>(
        initialValue: _expiryHours,
        isExpanded: true,
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context).jcExpiresAfter),
        items: [
          DropdownMenuItem(
              value: 24, child: Text(AppLocalizations.of(context).jcExp24h)),
          DropdownMenuItem(
              value: 72, child: Text(AppLocalizations.of(context).jcExp3d)),
          DropdownMenuItem(
              value: 168, child: Text(AppLocalizations.of(context).jcExp7d)),
          DropdownMenuItem(
              value: 720, child: Text(AppLocalizations.of(context).jcExp30d)),
          DropdownMenuItem(
              value: 8760, child: Text(AppLocalizations.of(context).jcExp1y)),
        ],
        onChanged: (value) => setState(() => _expiryHours = value ?? 168),
      );

  Widget _maxUsesField() => TextFormField(
        controller: _maxUsesController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).jcMaxUses,
          helperText: AppLocalizations.of(context).jcMaxUsesHint,
        ),
      );

  Widget _codeCard(String orgId, Map<String, dynamic> code) {
    final rawStatus = code['status'] as String? ?? 'unknown';
    final uses = (code['currentUses'] as num?)?.toInt() ?? 0;
    final maxUses = (code['maxUses'] as num?)?.toInt() ?? 0;
    final expiry = parseFirestoreDate(code['expiresAt']);
    // The server status can lag behind reality, so derive what the code can
    // actually do right now.
    final status = effectiveJoiningCodeStatus(code);
    final expiryLabel = expiry == null
        ? AppLocalizations.of(context).jcExpiryUnknown
        : AppLocalizations.of(context)
            .jcExpires((_dateFormat.format(expiry.toLocal())).toString());
    final active = rawStatus == 'active';
    final kc = RaayColors.of(context);
    final Color tone = switch (status) {
      'active' => kc.successText,
      'expired' || 'exhausted' => kc.warningText,
      'revoked' => kc.errorText,
      _ => kc.textSecondary,
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kc.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.key_outlined, color: kc.accentText),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                    AppLocalizations.of(context).jcCodeLabel(
                        (code['displayId'] ?? '••••••••').toString()),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: kc.textPrimary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                StatusBadge(
                  label: switch (status) {
                    'active' => AppLocalizations.of(context).statusActive,
                    'exhausted' => AppLocalizations.of(context).statusExhausted,
                    'expired' => AppLocalizations.of(context).statusExpired,
                    'revoked' => AppLocalizations.of(context).statusRevoked,
                    _ => status.toUpperCase(),
                  },
                  backgroundColor:
                      tone.withValues(alpha: kc.isDark ? 0.16 : 0.10),
                  textColor: tone,
                ),
                Text(
                    maxUses == 0
                        ? AppLocalizations.of(context).jcUses(uses.toString())
                        : AppLocalizations.of(context)
                            .jcUsesOf(uses.toString(), maxUses.toString()),
                    style: TextStyle(fontSize: 14, color: kc.textSecondary)),
              ]),
          const SizedBox(height: 6),
          Text(expiryLabel,
              style: TextStyle(fontSize: 14, color: kc.textSecondary)),
          if (active) ...[
            const SizedBox(height: 8),
            TextButton(
              style: TextButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  foregroundColor: kc.errorText),
              onPressed: () => _revoke(orgId, code),
              child: Text(AppLocalizations.of(context).jcRevoke),
            ),
          ],
        ],
      ),
    );
  }
}

/// What a joining code can actually do right now. The stored status can lag
/// behind reality (a code past its expiry or at its use limit is still
/// "active" until something updates it).
String effectiveJoiningCodeStatus(Map<String, dynamic> code, {DateTime? now}) {
  final raw = code['status'] as String? ?? 'unknown';
  if (raw != 'active') {
    return raw;
  }
  final uses = (code['currentUses'] as num?)?.toInt() ?? 0;
  final maxUses = (code['maxUses'] as num?)?.toInt() ?? 0;
  final expiry = parseFirestoreDate(code['expiresAt']);
  if (expiry != null && expiry.isBefore(now ?? DateTime.now())) {
    return 'expired';
  }
  if (maxUses > 0 && uses >= maxUses) {
    return 'exhausted';
  }
  return 'active';
}

({int active, int expired, int revoked}) countJoiningCodes(
    List<Map<String, dynamic>> codes,
    {DateTime? now}) {
  var active = 0, expired = 0, revoked = 0;
  for (final c in codes) {
    switch (effectiveJoiningCodeStatus(c, now: now)) {
      case 'active':
        active++;
      case 'expired' || 'exhausted':
        expired++;
      case 'revoked':
        revoked++;
    }
  }
  return (active: active, expired: expired, revoked: revoked);
}
