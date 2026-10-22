import '../navigation/route_access.dart' show routeNeed, roleMayOpen;
import '../../features/voting/presentation/receipt_verification_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/loading_view.dart';
import '../../features/support/presentation/help_support_screen.dart';
import '../../features/landing/presentation/landing_page_screen.dart';
import '../../features/onboarding/presentation/mobile_onboarding_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/email_verification_screen.dart';
import '../../features/auth/presentation/profile_screen.dart';
import '../../features/organizations/presentation/organization_list_screen.dart';
import '../../features/organizations/presentation/organization_settings_screen.dart';
import '../../features/organizations/presentation/organization_audit_screen.dart';
import '../../features/organizations/presentation/platform_organizations_screen.dart';
import '../../features/organizations/presentation/platform_admin_screen.dart';
import '../../features/organizations/presentation/membership_directory_screen.dart';
import '../../features/departments/presentation/department_members_screen.dart';
import '../../features/departments/presentation/departments_screen.dart';
import '../../features/organizations/presentation/join_organization_screen.dart';
import '../../features/organizations/presentation/scan_join_code_screen.dart';
import '../../features/organizations/presentation/invitation_inbox_screen.dart';
import '../../features/organizations/presentation/accept_invitation_link_screen.dart';
import '../../features/organizations/presentation/joining_codes_screen.dart';
import '../../features/organizations/presentation/create_organization_screen.dart';
import '../../features/voting_events/presentation/dashboard/admin_event_dashboard_screen.dart';
import '../../features/voting_events/presentation/builder/event_builder_screen.dart';
import '../../features/transparency/presentation/transparency_center_screen.dart';
import '../../features/voting_events/presentation/election_calendar_screen.dart';
import '../../features/billing/presentation/plans_screen.dart';
import '../../features/voting_events/presentation/election_command_center_screen.dart';
import '../../features/voting_events/presentation/observer_dashboard_screen.dart';
import '../../features/voting_events/presentation/event_detail_screen.dart';
import '../../features/voting_events/presentation/event_results_screen.dart';
import '../../features/voting_events/presentation/event_monitoring_screen.dart';
import '../../features/voting/presentation/cast_vote_screen.dart';
import '../../features/voting/presentation/vote_receipt_screen.dart';
import '../../features/voting/domain/vote_receipt.dart';
import '../../services/auth_service.dart';
import '../../services/firebase_service.dart';
import '../../features/organizations/presentation/providers/organization_providers.dart';
import '../../features/organizations/domain/organization_enums.dart';

import '../presentation/home_screen.dart';
import '../presentation/splash_screen.dart';
import '../presentation/app_navigation_shell.dart';
import '../../features/onboarding/providers/onboarding_providers.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorHomeKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final GlobalKey<NavigatorState> _shellNavigatorOrgsKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellOrgs');
final GlobalKey<NavigatorState> _shellNavigatorSettingsKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellSettings');
final GlobalKey<NavigatorState> _shellNavigatorAdminKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellAdmin');

/// Holds an invitation token received via a kivora://invite deep link while
/// the user is not yet signed in/verified, so RouterNotifier's redirect can
/// send them to /invite once auth completes instead of dropping them at
/// /home and losing the invitation. Cleared once the invite screen has
/// consumed it (accepted, dismissed, or shown an error).
final pendingInviteTokenProvider = StateProvider<String?>((ref) => null);

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  bool _isAuthLoading = true;
  bool _isAuth = false;
  bool _isEmailVerified = false;
  bool _isOrgLoading = true;
  OrganizationRole? _activeRole;

  RouterNotifier(this._ref) {
    _ref.listen(authStateChangesProvider, (_, next) {
      if (next.isLoading) {
        _isAuthLoading = true;
      } else {
        _isAuthLoading = false;
        final user = next.value;
        _isAuth = user != null;

        final bool isEmulator = FirebaseService.isEmulatorMode;
        _isEmailVerified = isEmulator ? true : (user?.emailVerified ?? false);
      }
      notifyListeners();
    });

    _ref.listen(activeOrganizationContextProvider, (_, next) {
      if (next.isLoading) {
        _isOrgLoading = true;
      } else {
        _isOrgLoading = false;
        final orgContext = next.valueOrNull?.context;
        _activeRole = orgContext?.member.role;
      }
      notifyListeners();
    });

    _ref.listen(pendingInviteTokenProvider, (_, __) => notifyListeners());
  }

  bool get isAuthLoading => _isAuthLoading;
  bool get isAuth => _isAuth;
  bool get isEmailVerified => _isEmailVerified;
  bool get isOrgLoading => _isOrgLoading;
  bool get hasSeenIntro => _ref.read(hasSeenIntroProvider);
  OrganizationRole? get activeRole => _activeRole;
  bool get isAdmin =>
      _activeRole == OrganizationRole.owner ||
      _activeRole == OrganizationRole.admin;
  String? get pendingInviteToken => _ref.read(pendingInviteTokenProvider);

  /// Captures a token carried directly on the `/invite` URL (the shared
  /// https:// link opened in a browser) before an auth/verification redirect
  /// would otherwise strip it. On native this duplicates what
  /// DeepLinkHandler already does for a kivora:// link, which is harmless -
  /// setting a StateProvider to its current value doesn't notify listeners
  /// again. On web, DeepLinkHandler never runs at all, so this is the only
  /// place the token gets captured.
  void captureInviteTokenIfPresent(String? token) {
    if (token != null && token.isNotEmpty) {
      final notifier = _ref.read(pendingInviteTokenProvider.notifier);
      if (notifier.state != token) notifier.state = token;
    }
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: kIsWeb ? '/' : '/welcome',
    refreshListenable: notifier,
    redirect: (context, state) {
      final isAuth = notifier.isAuth;
      final isVerified = notifier.isEmailVerified;

      final location = state.matchedLocation;

      if (notifier.isAuthLoading) {
        return '/splash';
      }

      final isWelcomeRoute = location == '/welcome';
      final isUnauthRoute = location == '/login' ||
          location == '/register' ||
          location == '/forgot-password' ||
          isWelcomeRoute;
      final isPublicLanding = location == '/';
      final isVerifyRoute = location == '/verify-email';
      final isSplashRoute = location == '/splash';
      final isInviteRoute = location == '/invite';

      if (isInviteRoute) {
        notifier.captureInviteTokenIfPresent(state.uri.queryParameters['token']);
      }

      if (!isAuth) {
        // Once this install has already shown the pre-login intro carousel,
        // skip straight past it on every subsequent app open (sign-out,
        // reopening later, etc.) instead of showing it again - it's a
        // first-install thing, not a "you're signed out" thing.
        if (isWelcomeRoute) {
          return notifier.hasSeenIntro ? '/login' : null;
        }
        if (isUnauthRoute || isPublicLanding) return null;
        return kIsWeb
            ? '/'
            : (notifier.hasSeenIntro ? '/login' : '/welcome');
      }

      if (!isVerified) {
        return isVerifyRoute ? null : '/verify-email';
      }

      if (isUnauthRoute || isVerifyRoute || isSplashRoute || isPublicLanding) {
        final pendingToken = notifier.pendingInviteToken;
        if (pendingToken != null && pendingToken.isNotEmpty) {
          return '/invite?token=${Uri.encodeQueryComponent(pendingToken)}';
        }
        return '/home';
      }

      // Central role guard (see route_access.dart). While the organization is
      // still loading we cannot know the role yet, so wait instead of
      // redirecting; the notifier refreshes the router when it resolves.
      if (routeNeed(location) != null && !notifier.isOrgLoading) {
        if (!roleMayOpen(location, notifier.activeRole)) return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingPageScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const MobileOnboardingScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(
          onRegisterTap: () => context.go('/register'),
          onForgotPasswordTap: () => context.go('/forgot-password'),
        ),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterScreen(
          onBackToLoginTap: () => context.go('/login'),
        ),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => ForgotPasswordScreen(
          onBackToLoginTap: () => context.go('/login'),
        ),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) => EmailVerificationScreen(
          onSignOut: () async {
            await ref.read(authServiceProvider).signOut();
          },
          onVerified: () {
            ref.invalidate(authStateChangesProvider);
          },
        ),
      ),
      GoRoute(
        path: '/receipt-verify',
        builder: (context, state) => const ReceiptVerificationScreen(),
      ),
      GoRoute(
        path: '/transparency',
        builder: (context, state) => const TransparencyCenterScreen(),
      ),
      GoRoute(
        path: '/receipt',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final receipt = extra['receipt'] as VoteReceipt;
          final eventTitle = extra['eventTitle'] as String?;
          return VoteReceiptScreen(receipt: receipt, eventTitle: eventTitle);
        },
      ),
      GoRoute(
        path: '/platform/organizations',
        builder: (context, state) => const PlatformOrganizationsScreen(),
      ),
      GoRoute(
        path: '/platform/admin',
        builder: (context, state) => const PlatformAdminScreen(),
      ),
      GoRoute(
        path: '/invite',
        builder: (context, state) => AcceptInvitationLinkScreen(
          rawToken: state.uri.queryParameters['token'],
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) =>
                    const HomeScreen(key: ValueKey('home_screen')),
              ),
              GoRoute(
                path: '/plans',
                builder: (context, state) => const PlansScreen(),
              ),
              GoRoute(
                path: '/calendar',
                builder: (context, state) => const ElectionCalendarScreen(),
              ),
              GoRoute(
                path: '/observer',
                builder: (context, state) => const ObserverDashboardScreen(),
              ),
              GoRoute(
                path: '/elections/:eventId',
                builder: (context, state) => EventDetailScreen(
                  eventId: state.pathParameters['eventId']!,
                ),
                routes: [
                  GoRoute(
                    path: 'results',
                    builder: (context, state) => EventResultsScreen(
                      eventId: state.pathParameters['eventId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'vote',
                    builder: (context, state) => CastVoteScreen(
                      eventId: state.pathParameters['eventId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorOrgsKey,
            routes: [
              GoRoute(
                path: '/orgs',
                builder: (context, state) => const OrganizationListScreen(),
                routes: [
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) =>
                        const OrganizationSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'audit',
                    builder: (context, state) =>
                        const OrganizationAuditScreen(),
                  ),
                  GoRoute(
                    path: 'join',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>?;
                      return JoinOrganizationScreen(
                        initialCode: extra?['initialCode'] as String?,
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'scan',
                        builder: (context, state) => const ScanJoinCodeScreen(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'invitations',
                    builder: (context, state) => const InvitationInboxScreen(),
                  ),
                  GoRoute(
                    path: 'dashboard',
                    // Merged into the Overview at /home; old links keep working.
                    redirect: (context, state) => '/home',
                  ),
                  GoRoute(
                    path: 'joining-codes',
                    builder: (context, state) => const JoiningCodesScreen(),
                  ),
                  GoRoute(
                    path: 'create',
                    builder: (context, state) => CreateOrganizationScreen(
                      onOrganizationCreated: (orgId) {
                        context.go('/orgs');
                      },
                      onCancelTap: () => context.go('/orgs'),
                    ),
                  ),
                  GoRoute(
                    path: 'members',
                    builder: (context, state) =>
                        const MembershipDirectoryScreen(),
                  ),
                  GoRoute(
                    path: 'departments',
                    builder: (context, state) => const DepartmentsScreen(),
                  ),
                  GoRoute(
                    path: 'departments/:id',
                    builder: (context, state) => DepartmentMembersScreen(
                      departmentId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSettingsKey,
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>? ?? {};
                  final user = ref.watch(authServiceProvider).currentUser;
                  if (user == null) return const Scaffold(body: LoadingView());
                  return ProfileScreen(
                    uid: user.uid,
                    initialTab: extra['initialTab'] as int? ?? 0,
                    onSignOut: () {
                      ref.read(activeOrgIdProvider.notifier).clearSelection();
                    },
                  );
                },
              ),
              GoRoute(
                path: '/help',
                builder: (context, state) => const HelpSupportScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorAdminKey,
            routes: [
              GoRoute(
                path: '/admin/command-center',
                builder: (context, state) => const ElectionCommandCenterScreen(),
              ),
              GoRoute(
                path: '/admin/events',
                builder: (context, state) => const AdminEventDashboardScreen(),
                routes: [
                  GoRoute(
                    path: ':eventId/monitor',
                    builder: (context, state) => EventMonitoringScreen(
                      eventId: state.pathParameters['eventId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'new',
                    builder: (context, state) => const EventBuilderScreen(),
                  ),
                  GoRoute(
                    path: ':eventId/edit',
                    builder: (context, state) => EventBuilderScreen(
                        existingEventId: state.pathParameters['eventId']),
                  ),
                  GoRoute(
                    path: ':eventId/choices',
                    builder: (context, state) => EventBuilderScreen(
                      existingEventId: state.pathParameters['eventId'],
                      initialStep: 3,
                    ),
                  ),
                  GoRoute(
                    path: ':eventId/review',
                    builder: (context, state) => EventBuilderScreen(
                      existingEventId: state.pathParameters['eventId'],
                      initialStep: 4,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
