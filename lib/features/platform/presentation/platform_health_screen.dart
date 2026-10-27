import '../../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/kivora_colors.dart';
import '../../../core/utils/date_text.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../data/platform_providers.dart';
import 'platform_scaffold.dart';

/// Shows only checks returned by the protected health callable. Services with
/// no probe are explicitly marked as unmonitored rather than assumed healthy.
class PlatformHealthScreen extends ConsumerWidget {
  const PlatformHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(platformHealthProvider);
    return PlatformPage(
      title: AppLocalizations.of(context).phTitle,
      subtitle: AppLocalizations.of(context).phSubtitle,
      actions: [
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
          onPressed: () => ref.invalidate(platformHealthProvider),
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: Text(AppLocalizations.of(context).phRun),
        ),
      ],
      builder: (context) {
        final kc = KivoraColors.of(context);
        return health.when(
          loading: () =>
              const Padding(padding: EdgeInsets.all(32), child: LoadingView()),
          error: (_, __) => ErrorView(
            type: ErrorViewType.generic,
            title: AppLocalizations.of(context).phUnavailTitle,
            message: AppLocalizations.of(context).phUnavailBody,
            onRetry: () => ref.invalidate(platformHealthProvider),
          ),
          data: (data) {
            final functionOk = data['functions'] == 'ok';
            final firestoreOk = data['firestore'] == 'ok';
            final checkedAt =
                DateTime.tryParse(data['checkedAt'] as String? ?? '');
            final latency = (data['firestoreLatencyMs'] as num?)?.toInt();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PlatformPanel(
                  title: functionOk && firestoreOk
                      ? AppLocalizations.of(context).phOkTitle
                      : AppLocalizations.of(context).phBadTitle,
                  child: Column(
                    children: [
                      _HealthRow(
                        name: AppLocalizations.of(context).phFunctions,
                        detail: AppLocalizations.of(context).phFunctionsOk,
                        ok: functionOk,
                      ),
                      Divider(color: kc.border),
                      _HealthRow(
                        name: AppLocalizations.of(context).phFirestore,
                        detail: firestoreOk
                            ? (latency == null
                                ? AppLocalizations.of(context).phProbeOk
                                : AppLocalizations.of(context)
                                    .phProbeOkMs('$latency'))
                            : AppLocalizations.of(context).phProbeFailed,
                        ok: firestoreOk,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PlatformPanel(
                  title: AppLocalizations.of(context).phCoverage,
                  child: Text(
                    AppLocalizations.of(context).phCoverageBody,
                    style: TextStyle(color: kc.textSecondary, height: 1.45),
                  ),
                ),
                if (checkedAt != null) ...[
                  const SizedBox(height: 12),
                  Text(
                      AppLocalizations.of(context)
                          .phLast(formatDateTimeText(context, checkedAt)),
                      style: TextStyle(color: kc.textSecondary, fontSize: 13)),
                ],
              ],
            );
          },
        );
      },
    );
  }
}

class _HealthRow extends StatelessWidget {
  const _HealthRow(
      {required this.name, required this.detail, required this.ok});

  final String name;
  final String detail;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final statusColor = ok ? kc.successText : kc.errorText;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(ok ? Icons.check_circle_rounded : Icons.error_rounded,
            color: statusColor),
        const SizedBox(width: 12),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name,
                style: TextStyle(
                    color: kc.textPrimary, fontWeight: FontWeight.w700)),
            const SizedBox(height: 3),
            Text(detail,
                style: TextStyle(color: kc.textSecondary, height: 1.4)),
          ]),
        ),
        const SizedBox(width: 8),
        Text(
            ok
                ? AppLocalizations.of(context).phOperational
                : AppLocalizations.of(context).phDown,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
