import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../services/firebase_service.dart';
import 'providers/organization_providers.dart';

/// One stable Firestore listener per organization.
final organizationAuditLogsProvider = StreamProvider.autoDispose
    .family<QuerySnapshot<Map<String, dynamic>>, String>((ref, organizationId) {
  return FirebaseService()
      .firestore
      .collection('auditLogs')
      .where('organizationId', isEqualTo: organizationId)
      .orderBy('timestamp', descending: true)
      .limit(100)
      .snapshots();
});

class OrganizationAuditScreen extends ConsumerStatefulWidget {
  const OrganizationAuditScreen({super.key});

  @override
  ConsumerState<OrganizationAuditScreen> createState() =>
      _OrganizationAuditScreenState();
}

class _OrganizationAuditScreenState
    extends ConsumerState<OrganizationAuditScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'all'; // 'all', 'members', 'invitations'
  String _selectedRecordType = 'all'; // 'all' or specific resourceType
  String _selectedActorUid = 'all'; // 'all' or specific actorUid
  DateTimeRange? _selectedDateRange;
  bool _newestFirst = true;
  String? _expandedDocId;
  String? _hoveredDocId;

  static final _dayFormat = DateFormat('MMM d, yyyy');
  static final _timeFormat = DateFormat('h:mm a');
  static final _fullFormat = DateFormat('MMM d, yyyy · h:mm a');

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() {
        _searchQuery = _searchCtrl.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _formatActionTitle(String raw) {
    final text = raw.replaceAll('_', ' ').trim().toLowerCase();
    if (text.isEmpty) return 'Admin action';
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  String _truncateAccountId(String raw) {
    if (raw.isEmpty || raw == 'System') return 'System';
    if (raw.length <= 8) return raw;
    return '${raw.substring(0, 4)}...${raw.substring(raw.length - 4)}';
  }

  (IconData, Color, Color) _getActionVisuals(
      String rawAction, String recordType) {
    final action = rawAction.toUpperCase();
    if (action.contains('REMOVE') ||
        action.contains('DELETE') ||
        action.contains('CANCEL') ||
        action.contains('DECLINE') ||
        action.contains('SUSPEND')) {
      return (
        Icons.person_remove_outlined,
        AppTheme.error,
        AppTheme.error.withValues(alpha: 0.1),
      );
    }
    if (action.contains('INVITE') || action.contains('INVITATION')) {
      return (
        Icons.mail_outline_rounded,
        AppTheme.primaryBlue,
        AppTheme.primaryBlue.withValues(alpha: 0.12),
      );
    }
    if (action.contains('ADD') ||
        action.contains('ACCEPT') ||
        action.contains('VERIFY') ||
        action.contains('CREATE')) {
      return (
        Icons.person_add_alt_1_outlined,
        AppTheme.success,
        AppTheme.success.withValues(alpha: 0.1),
      );
    }
    if (action.contains('ROLE') ||
        action.contains('UPDATE') ||
        action.contains('STATUS')) {
      return (
        Icons.shield_outlined,
        Colors.purple.shade700,
        Colors.purple.withValues(alpha: 0.1),
      );
    }
    return (
      Icons.history_rounded,
      AppTheme.primaryBlue,
      AppTheme.primaryBlue.withValues(alpha: 0.12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(activeOrganizationContextProvider);
    final isDesktop = ResponsiveLayout.isWide(context);

    if (state.isLoading && !state.hasValue) {
      return const Scaffold(
          body: LoadingView(message: 'Loading organization activity…'));
    }
    if (state.hasError && !state.hasValue) {
      return Scaffold(
        body: ErrorView(
          type: ErrorViewType.generic,
          message: 'Could not load active organization: ${state.error}',
          onRetry: () => ref.invalidate(activeOrganizationContextProvider),
        ),
      );
    }

    final orgContext = state.valueOrNull?.context;
    if (orgContext == null) {
      return const Scaffold(
        body: EmptyView(
          icon: Icons.business_outlined,
          title: 'Select an organization',
          message: 'Choose an organization to view its activity.',
        ),
      );
    }
    if (!orgContext.member.isAdmin) {
      return const Scaffold(
        body: ErrorView(
          type: ErrorViewType.accessDenied,
          title: 'Access denied',
          message:
              'Only this organization’s Owner and Admins can view its audit history.',
        ),
      );
    }

    final logsAsync =
        ref.watch(organizationAuditLogsProvider(orgContext.organization.id));

    return Scaffold(
      backgroundColor: KivoraColors.backgroundOf(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 32 : 16,
          vertical: 24,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1140),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Breadcrumb
                Row(
                  children: [
                    InkWell(
                      onTap: () => context.go('/orgs'),
                      borderRadius: BorderRadius.circular(4),
                      child: Text('Organization',
                          style: TextStyle(
                              fontSize: 13,
                              color: KivoraColors.textSecondaryOf(context),
                              fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.chevron_right_rounded,
                        size: 16, color: KivoraColors.textSecondaryOf(context)),
                    const SizedBox(width: 6),
                    Text('Activity',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: KivoraColors.textPrimaryOf(context))),
                  ],
                ),
                const SizedBox(height: 16),

                // 2. Page Title & Subtitle
                Text(
                  'Organization activity',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: KivoraColors.textPrimaryOf(context),
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Review membership and invitation changes across your organization.',
                  style: TextStyle(color: KivoraColors.textSecondaryOf(context), fontSize: 14),
                ),
                const SizedBox(height: 24),

                // 3. Search & Filter Bar & Table Content
                logsAsync.when(
                  loading: () =>
                      const LoadingView(message: 'Loading audit history…'),
                  error: (error, _) => ErrorView(
                    type: ErrorViewType.generic,
                    message: 'Could not load organization activity: $error',
                    onRetry: () => ref.invalidate(organizationAuditLogsProvider(
                        orgContext.organization.id)),
                  ),
                  data: (snapshot) {
                    return Column(
                      children: [
                        _buildToolbar(context, snapshot.docs, isDesktop),
                        const SizedBox(height: 20),
                        _buildAuditTableContent(
                            context, snapshot.docs, isDesktop),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // SEARCH & FILTER CONTROLS TOOLBAR
  // ===========================================================================
  Widget _buildToolbar(
    BuildContext context,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    bool isDesktop,
  ) {
    final hasActiveFilters = _selectedRecordType != 'all' ||
        _selectedActorUid != 'all' ||
        _selectedDateRange != null ||
        _searchQuery.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isDesktop)
          Row(
            children: [
              Expanded(
                flex: 5,
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Search by activity, account ID or record type',
                    prefixIcon: Icon(Icons.search_rounded,
                        color: KivoraColors.textSecondaryOf(context), size: 20),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: KivoraColors.borderOf(context))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: KivoraColors.borderOf(context))),
                    fillColor: KivoraColors.surfaceOf(context),
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _buildRecordTypeMenu(docs),
              const SizedBox(width: 8),
              _buildAccountsMenu(docs),
              const SizedBox(width: 8),
              _buildDateRangeButton(context),
              if (hasActiveFilters) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _searchCtrl.clear();
                      _searchQuery = '';
                      _selectedRecordType = 'all';
                      _selectedActorUid = 'all';
                      _selectedDateRange = null;
                      _selectedCategory = 'all';
                    });
                  },
                  child: const Text('Reset',
                      style: TextStyle(
                          color: AppTheme.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                ),
              ],
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Search activity...',
                  prefixIcon: Icon(Icons.search_rounded,
                      color: KivoraColors.textSecondaryOf(context), size: 20),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  fillColor: KivoraColors.surfaceOf(context),
                  filled: true,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildRecordTypeMenu(docs),
                  _buildAccountsMenu(docs),
                  _buildDateRangeButton(context),
                  if (hasActiveFilters)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _searchCtrl.clear();
                          _searchQuery = '';
                          _selectedRecordType = 'all';
                          _selectedActorUid = 'all';
                          _selectedDateRange = null;
                          _selectedCategory = 'all';
                        });
                      },
                      child: const Text('Reset',
                          style: TextStyle(
                              color: AppTheme.error,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildRecordTypeMenu(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    final types = <String>{'all'};
    for (final d in docs) {
      final t = d.data()['resourceType'] as String?;
      if (t != null && t.isNotEmpty) types.add(t);
    }

    final currentLabel =
        _selectedRecordType == 'all' ? 'All record types' : _selectedRecordType;

    return PopupMenuButton<String>(
      tooltip: 'Filter by record type',
      offset: const Offset(0, 42),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: KivoraColors.borderOf(context)),
      ),
      color: KivoraColors.surfaceOf(context),
      onSelected: (val) {
        setState(() {
          _selectedRecordType = val;
        });
      },
      itemBuilder: (ctx) => types.map((t) {
        final label = t == 'all' ? 'All record types' : t;
        final isSelected = _selectedRecordType == t;
        return PopupMenuItem<String>(
          value: t,
          child: Row(
            children: [
              if (isSelected)
                const Icon(Icons.check_rounded,
                    size: 16, color: AppTheme.primaryBlue)
              else
                const SizedBox(width: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? AppTheme.primaryBlue
                      : KivoraColors.textPrimaryOf(context),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      child: _filterPillContainer(
          currentLabel, Icons.tune_rounded, _selectedRecordType != 'all'),
    );
  }

  Widget _buildAccountsMenu(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    final accounts = <String>{'all'};
    for (final d in docs) {
      final a = d.data()['actorUid'] as String?;
      if (a != null && a.isNotEmpty) accounts.add(a);
    }

    final currentLabel = _selectedActorUid == 'all'
        ? 'All accounts'
        : 'Account ${_truncateAccountId(_selectedActorUid)}';

    return PopupMenuButton<String>(
      tooltip: 'Filter by account',
      offset: const Offset(0, 42),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: KivoraColors.borderOf(context)),
      ),
      color: KivoraColors.surfaceOf(context),
      onSelected: (val) {
        setState(() {
          _selectedActorUid = val;
        });
      },
      itemBuilder: (ctx) => accounts.map((a) {
        final label =
            a == 'all' ? 'All accounts' : 'Account ${_truncateAccountId(a)}';
        final isSelected = _selectedActorUid == a;
        return PopupMenuItem<String>(
          value: a,
          child: Row(
            children: [
              if (isSelected)
                const Icon(Icons.check_rounded,
                    size: 16, color: AppTheme.primaryBlue)
              else
                const SizedBox(width: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? AppTheme.primaryBlue
                      : KivoraColors.textPrimaryOf(context),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      child: _filterPillContainer(currentLabel, Icons.person_outline_rounded,
          _selectedActorUid != 'all'),
    );
  }

  Widget _buildDateRangeButton(BuildContext context) {
    final String currentLabel;
    if (_selectedDateRange == null) {
      currentLabel = 'Date range';
    } else {
      final startStr = DateFormat('MMM d').format(_selectedDateRange!.start);
      final endStr = DateFormat('MMM d').format(_selectedDateRange!.end);
      currentLabel = '$startStr - $endStr';
    }

    return PopupMenuButton<String>(
      tooltip: 'Filter by date range',
      offset: const Offset(0, 42),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: KivoraColors.borderOf(context)),
      ),
      color: KivoraColors.surfaceOf(context),
      onSelected: (val) async {
        if (val == 'all') {
          setState(() {
            _selectedDateRange = null;
          });
        } else if (val == 'today') {
          final now = DateTime.now();
          setState(() {
            _selectedDateRange = DateTimeRange(start: now, end: now);
          });
        } else if (val == '7days') {
          final now = DateTime.now();
          setState(() {
            _selectedDateRange = DateTimeRange(
              start: now.subtract(const Duration(days: 7)),
              end: now,
            );
          });
        } else if (val == '30days') {
          final now = DateTime.now();
          setState(() {
            _selectedDateRange = DateTimeRange(
              start: now.subtract(const Duration(days: 30)),
              end: now,
            );
          });
        } else if (val == 'custom') {
          final now = DateTime.now();
          final picked = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2020),
            lastDate: now.add(const Duration(days: 365)),
            initialDateRange: _selectedDateRange ??
                DateTimeRange(
                  start: now.subtract(const Duration(days: 7)),
                  end: now,
                ),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: AppTheme.primaryBlue,
                      ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null && mounted) {
            setState(() {
              _selectedDateRange = picked;
            });
          }
        }
      },
      itemBuilder: (ctx) => [
        PopupMenuItem<String>(
          value: 'all',
          child: Row(
            children: [
              if (_selectedDateRange == null)
                const Icon(Icons.check_rounded,
                    size: 16, color: AppTheme.primaryBlue)
              else
                const SizedBox(width: 16),
              const SizedBox(width: 8),
              Text(
                'All time',
                style: TextStyle(
                  fontWeight: _selectedDateRange == null
                      ? FontWeight.bold
                      : FontWeight.w500,
                  color: _selectedDateRange == null
                      ? AppTheme.primaryBlue
                      : KivoraColors.textPrimaryOf(context),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'today',
          child: Row(
            children: [
              const SizedBox(width: 24),
              Text('Today',
                  style:
                      TextStyle(fontSize: 13, color: KivoraColors.textPrimaryOf(context))),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '7days',
          child: Row(
            children: [
              const SizedBox(width: 24),
              Text('Last 7 days',
                  style:
                      TextStyle(fontSize: 13, color: KivoraColors.textPrimaryOf(context))),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '30days',
          child: Row(
            children: [
              const SizedBox(width: 24),
              Text('Last 30 days',
                  style:
                      TextStyle(fontSize: 13, color: KivoraColors.textPrimaryOf(context))),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'custom',
          child: Row(
            children: [
              Icon(Icons.date_range_rounded,
                  size: 16, color: AppTheme.primaryBlue),
              SizedBox(width: 8),
              Text('Custom date range...',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                      fontSize: 13)),
            ],
          ),
        ),
      ],
      child: _filterPillContainer(currentLabel, Icons.calendar_today_rounded,
          _selectedDateRange != null),
    );
  }

  Widget _filterPillContainer(String label, IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryBlue.withValues(alpha: 0.12) : KivoraColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? AppTheme.primaryBlue : KivoraColors.borderOf(context),
          width: isActive ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 16,
              color: isActive ? AppTheme.primaryBlue : KivoraColors.textSecondaryOf(context)),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? AppTheme.primaryBlue : KivoraColors.textPrimaryOf(context),
            ),
          ),
          const SizedBox(width: 6),
          Icon(Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: isActive ? AppTheme.primaryBlue : KivoraColors.textSecondaryOf(context)),
        ],
      ),
    );
  }

  // ===========================================================================
  // AUDIT TABLE / LIST CONTENT
  // ===========================================================================
  Widget _buildAuditTableContent(
    BuildContext context,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs,
    bool isDesktop,
  ) {
    // 1. Filter docs by search query, category tab, record type, account, and date range
    var filteredDocs = allDocs.where((doc) {
      final data = doc.data();
      final action = (data['action'] as String? ?? '').toLowerCase();
      final actorUid = data['actorUid'] as String? ?? 'System';
      final resourceType = data['resourceType'] as String? ?? 'record';
      final resourceId = (data['resourceId'] as String? ?? '').toLowerCase();
      final stamp = data['timestamp'];

      // Category tab filter
      if (_selectedCategory == 'members') {
        if (!resourceType.toLowerCase().contains('member') &&
            !action.contains('member')) {
          return false;
        }
      } else if (_selectedCategory == 'invitations') {
        if (!resourceType.toLowerCase().contains('invitation') &&
            !action.contains('invitation')) {
          return false;
        }
      }

      // Record type filter
      if (_selectedRecordType != 'all' && resourceType != _selectedRecordType) {
        return false;
      }

      // Account filter
      if (_selectedActorUid != 'all' && actorUid != _selectedActorUid) {
        return false;
      }

      // Date range filter
      if (_selectedDateRange != null && stamp is Timestamp) {
        final docDate = stamp.toDate().toLocal();
        final start = DateTime(_selectedDateRange!.start.year,
            _selectedDateRange!.start.month, _selectedDateRange!.start.day);
        final end = DateTime(
            _selectedDateRange!.end.year,
            _selectedDateRange!.end.month,
            _selectedDateRange!.end.day,
            23,
            59,
            59);
        if (docDate.isBefore(start) || docDate.isAfter(end)) {
          return false;
        }
      }

      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final matches = action.toLowerCase().contains(_searchQuery) ||
            actorUid.toLowerCase().contains(_searchQuery) ||
            resourceType.toLowerCase().contains(_searchQuery) ||
            resourceId.toLowerCase().contains(_searchQuery);
        if (!matches) return false;
      }

      return true;
    }).toList();

    // Sort order
    if (!_newestFirst) {
      filteredDocs = filteredDocs.reversed.toList();
    }

    // Counts for Category Tabs
    final allCount = allDocs.length;
    final membersCount = allDocs.where((doc) {
      final data = doc.data();
      final action = (data['action'] as String? ?? '').toLowerCase();
      final resourceType =
          (data['resourceType'] as String? ?? '').toLowerCase();
      return resourceType.contains('member') || action.contains('member');
    }).length;
    final invitationsCount = allDocs.where((doc) {
      final data = doc.data();
      final action = (data['action'] as String? ?? '').toLowerCase();
      final resourceType =
          (data['resourceType'] as String? ?? '').toLowerCase();
      return resourceType.contains('invitation') ||
          action.contains('invitation');
    }).length;

    // Grouping by Date
    final Map<String, List<QueryDocumentSnapshot<Map<String, dynamic>>>>
        groupedDocs = {};
    for (final doc in filteredDocs) {
      final data = doc.data();
      final stamp = data['timestamp'];
      final dateStr = stamp is Timestamp
          ? _dayFormat.format(stamp.toDate().toLocal())
          : 'Date unavailable';
      groupedDocs.putIfAbsent(dateStr, () => []).add(doc);
    }

    return Column(
      children: [
        // Category Filter Tabs & Sort Row (wraps on narrow screens, matching
        // the toolbar above it instead of risking overflow like a plain Row)
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment:
              isDesktop ? WrapAlignment.spaceBetween : WrapAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildCategoryTab('all', 'All records', allCount),
                _buildCategoryTab('members', 'Members', membersCount),
                _buildCategoryTab(
                    'invitations', 'Invitations', invitationsCount),
              ],
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _newestFirst = !_newestFirst;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    Icon(Icons.swap_vert_rounded,
                        size: 16, color: KivoraColors.textSecondaryOf(context)),
                    const SizedBox(width: 6),
                    Text(
                      _newestFirst ? 'Newest first' : 'Oldest first',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: KivoraColors.textSecondaryOf(context)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Main Table Container Card
        Container(
          decoration: BoxDecoration(
            color: KivoraColors.surfaceOf(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: KivoraColors.borderOf(context)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Column Headers Row (Desktop)
              if (isDesktop)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: KivoraColors.borderOf(context))),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 5,
                          child: Text('ACTIVITY',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: KivoraColors.textSecondaryOf(context),
                                  letterSpacing: 0.8))),
                      Expanded(
                          flex: 3,
                          child: Text('RECORD TYPE',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: KivoraColors.textSecondaryOf(context),
                                  letterSpacing: 0.8))),
                      Expanded(
                          flex: 3,
                          child: Text('ACCOUNT ID',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: KivoraColors.textSecondaryOf(context),
                                  letterSpacing: 0.8))),
                      SizedBox(
                          width: 90,
                          child: Text('TIME',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: KivoraColors.textSecondaryOf(context),
                                  letterSpacing: 0.8))),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),

              if (groupedDocs.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: Text('No activity records match your criteria.',
                        style: TextStyle(
                            color: KivoraColors.textSecondaryOf(context), fontSize: 14)),
                  ),
                )
              else
                ...groupedDocs.entries.map((group) {
                  final dayLabel = group.key;
                  final dayDocs = group.value;

                  return Column(
                    children: [
                      // Date Group Header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                        color: KivoraColors.surfaceOf(context),
                        child: Row(
                          children: [
                            Text(
                              dayLabel,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: KivoraColors.textPrimaryOf(context)),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${dayDocs.length} ${dayDocs.length == 1 ? 'record' : 'records'}',
                              style: TextStyle(
                                  fontSize: 12, color: KivoraColors.textSecondaryOf(context)),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: KivoraColors.borderOf(context)),

                      // Rows for this Day
                      ...dayDocs.map(
                          (doc) => _buildActivityRow(context, doc, isDesktop)),
                    ],
                  );
                }),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Bottom Summary Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${filteredDocs.length} records shown · Repeated records retained',
              style:
                  TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context)),
            ),
            Text(
              'Dates and times as recorded',
              style: TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryTab(String key, String label, int count) {
    final isSelected = _selectedCategory == key;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = key;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3))
              : null,
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color:
                    isSelected ? AppTheme.primaryBlue : KivoraColors.textSecondaryOf(context),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color:
                    isSelected ? AppTheme.primaryBlue : KivoraColors.textSecondaryOf(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityRow(
    BuildContext context,
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
    bool isDesktop,
  ) {
    final docId = doc.id;
    final data = doc.data();
    final rawAction = data['action'] as String? ?? 'ADMIN_ACTION';
    final actionTitle = _formatActionTitle(rawAction);
    final recordType = data['resourceType'] as String? ?? 'record';
    final rawActor = data['actorUid'] as String? ?? 'System';
    final accountIdTruncated = _truncateAccountId(rawActor);

    final stamp = data['timestamp'];
    final timeStr = stamp is Timestamp
        ? _timeFormat.format(stamp.toDate().toLocal())
        : 'Unavailable';
    final fullDateStr = stamp is Timestamp
        ? _fullFormat.format(stamp.toDate().toLocal())
        : 'Time unavailable';

    final (iconData, iconColor, iconBg) =
        _getActionVisuals(rawAction, recordType);
    final isExpanded = _expandedDocId == docId;
    final isHovered = _hoveredDocId == docId;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredDocId = docId),
      onExit: (_) => setState(() => _hoveredDocId = null),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedDocId = isExpanded ? null : docId;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              color: isExpanded
                  ? AppTheme.primaryBlue.withValues(alpha: 0.1)
                  : (isHovered
                      ? AppTheme.primaryBlue.withValues(alpha: 0.12).withValues(alpha: 0.5)
                      : KivoraColors.surfaceOf(context)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: isDesktop
                  ? Row(
                      children: [
                        // Column 1: Action Title + Icon
                        Expanded(
                          flex: 5,
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: iconBg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child:
                                    Icon(iconData, size: 18, color: iconColor),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  actionTitle,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: KivoraColors.textPrimaryOf(context)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Column 2: Record Type
                        Expanded(
                          flex: 3,
                          child: Text(
                            recordType,
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'monospace',
                                color: KivoraColors.textSecondaryOf(context)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Column 3: Account ID
                        Expanded(
                          flex: 3,
                          child: Text(
                            accountIdTruncated,
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'monospace',
                                color: KivoraColors.textPrimaryOf(context),
                                fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Column 4: Time
                        SizedBox(
                          width: 90,
                          child: Text(
                            timeStr,
                            style: TextStyle(
                                fontSize: 13, color: KivoraColors.textSecondaryOf(context)),
                          ),
                        ),

                        // Chevron / View details
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isHovered && !isExpanded)
                              const Text('View details ',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.primaryBlue,
                                      fontWeight: FontWeight.bold)),
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: isExpanded
                                  ? AppTheme.primaryBlue
                                  : KivoraColors.textSecondaryOf(context),
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: iconBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(iconData, size: 16, color: iconColor),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                actionTitle,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: KivoraColors.textPrimaryOf(context)),
                              ),
                            ),
                            Text(timeStr,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: KivoraColors.textSecondaryOf(context))),
                            const SizedBox(width: 4),
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: KivoraColors.textSecondaryOf(context),
                              size: 18,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(recordType,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'monospace',
                                    color: KivoraColors.textSecondaryOf(context))),
                            const SizedBox(width: 8),
                            Text('• $accountIdTruncated',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'monospace',
                                    color: KivoraColors.textPrimaryOf(context),
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
            ),
          ),

          // Expanded Details Card Panel
          if (isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: KivoraColors.surfaceOf(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 32,
                    runSpacing: 12,
                    children: [
                      _detailField('Recorded at', fullDateStr),
                      _detailField('Record type', recordType, isCode: true),
                      _detailField('Account ID', rawActor, isCode: true),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          size: 14, color: KivoraColors.textSecondaryOf(context)),
                      const SizedBox(width: 6),
                      Text(
                        'Actor identity and change details are not provided in this record.',
                        style: TextStyle(
                            fontSize: 11, color: KivoraColors.textSecondaryOf(context)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          Divider(height: 1, color: KivoraColors.borderOf(context)),
        ],
      ),
    );
  }

  Widget _detailField(String label, String value, {bool isCode = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                TextStyle(fontSize: 11, color: KivoraColors.textSecondaryOf(context))),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: isCode ? 'monospace' : null,
            color: KivoraColors.textPrimaryOf(context),
          ),
        ),
      ],
    );
  }
}
