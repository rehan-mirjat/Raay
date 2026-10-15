import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/functions_service.dart';

class VerifyOrganizationsScreen extends ConsumerStatefulWidget {
  const VerifyOrganizationsScreen({super.key});

  @override
  ConsumerState<VerifyOrganizationsScreen> createState() =>
      _VerifyOrganizationsScreenState();
}

class _VerifyOrganizationsScreenState
    extends ConsumerState<VerifyOrganizationsScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _organizations = [];

  @override
  void initState() {
    super.initState();
    _fetchOrganizations();
  }

  Future<void> _fetchOrganizations() async {
    setState(() => _isLoading = true);
    try {
      final res = await ref.read(functionsServiceProvider).listOrganizations();
      final list = (res['organizations'] as List<dynamic>? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      setState(() {
        _organizations = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading organizations: $e')),
        );
      }
    }
  }

  Future<void> _reviewOrg(String orgId, String status) async {
    try {
      await ref.read(functionsServiceProvider).reviewOrganization(
            organizationId: orgId,
            status: status,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Organization set to $status')),
        );
      }
      await _fetchOrganizations();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Organizations'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _organizations.isEmpty
              ? const Center(child: Text('No organization applications found.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: _organizations.length,
                  itemBuilder: (context, index) {
                    final org = _organizations[index];
                    final status = org['status'] as String? ?? 'pending';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      child: ListTile(
                        title: Text(
                          org['name'] as String? ?? 'Unnamed Organization',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Slug: ${org['slug']}\nStatus: ${status.toUpperCase()}',
                        ),
                        isThreeLine: true,
                        trailing: status == 'pending'
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.check_circle,
                                        color: Colors.green),
                                    onPressed: () => _reviewOrg(
                                        org['id'] as String, 'verified'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.cancel,
                                        color: Colors.red),
                                    onPressed: () => _reviewOrg(
                                        org['id'] as String, 'rejected'),
                                  ),
                                ],
                              )
                            : Chip(
                                label: Text(
                                  status.toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                                backgroundColor: status == 'verified'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                      ),
                    );
                  },
                ),
    );
  }
}
