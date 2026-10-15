import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../audit_logs/data/audit_log_repository.dart';

class PlatformAuditLogsScreen extends ConsumerWidget {
  const PlatformAuditLogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(platformAuditLogsStreamProvider);
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Security Audit Logs'),
      ),
      body: logsAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return const Center(
              child: Text('No global audit logs recorded.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12.0),
            itemCount: logs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final log = logs[index];
              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.indigo,
                  child: Icon(Icons.security, color: Colors.white, size: 20),
                ),
                title: Text(
                  log.action,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Actor: ${log.actorUid.isEmpty ? 'System' : log.actorUid}\nOrg: ${log.organizationId}',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Text(
                  dateFormat.format(log.timestamp),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                isThreeLine: true,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error loading platform audit logs: $err'),
        ),
      ),
    );
  }
}
