import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/audit_log_repository.dart';

class OrganizationAuditLogsScreen extends ConsumerWidget {
  final String organizationId;

  const OrganizationAuditLogsScreen({
    super.key,
    required this.organizationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync =
        ref.watch(organizationAuditLogsStreamProvider(organizationId));
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Audit Logs'),
      ),
      body: logsAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.security, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No audit logs recorded for this organization.'),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12.0),
            itemCount: logs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final log = logs[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getActionColor(log.action),
                  child: Icon(
                    _getActionIcon(log.action),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                title: Text(
                  log.action,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Actor: ${log.actorUid.isEmpty ? 'System' : log.actorUid}\nTarget: ${log.resourceType.isEmpty ? log.resourceId : '${log.resourceType} ${log.resourceId}'}',
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
          child: Text('Error loading audit logs: $err'),
        ),
      ),
    );
  }

  Color _getActionColor(String action) {
    if (action.contains('DELETE') || action.contains('REVOKE')) return Colors.red;
    if (action.contains('CREATE') || action.contains('PUBLISH')) return Colors.green;
    if (action.contains('UPDATE') || action.contains('ROLE')) return Colors.orange;
    return Colors.blue;
  }

  IconData _getActionIcon(String action) {
    if (action.contains('VOTE')) return Icons.how_to_vote;
    if (action.contains('MEMBER') || action.contains('ROLE')) return Icons.people;
    if (action.contains('EVENT')) return Icons.event;
    return Icons.security;
  }
}
