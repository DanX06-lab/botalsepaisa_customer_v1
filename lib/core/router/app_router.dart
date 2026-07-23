import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/authentication/screens/login_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/home/screens/main_layout.dart';
import '../../features/scanner/screens/scanner_screen.dart';
import '../../features/scanner/screens/bottle_scanner_screen.dart';
import '../../features/scanner/screens/bottle_details_screen.dart';
import '../../features/scanner/screens/reward_success_screen.dart';
import '../../features/wallet/screens/wallet_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/settings/screens/edit_profile_screen.dart';
import '../../features/profile/screens/refer_and_earn_screen.dart';
import '../../features/profile/screens/achievements_screen.dart';
import '../../features/settings/screens/settings_screens.dart';
import '../../features/settings/screens/contact_support_screen.dart';
import '../../features/settings/screens/report_problem_screen.dart';
import '../../features/settings/screens/change_password_screen.dart';
import '../../features/settings/screens/active_sessions_screen.dart';
import '../../features/authentication/screens/register_screen.dart';
import '../../features/authentication/screens/forgot_password_screen.dart';
import '../../features/authentication/screens/otp_verification_screen.dart';
import '../../features/authentication/screens/reset_password_screen.dart';
import '../../features/authentication/screens/reset_success_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // ── Auth / Onboarding ──────────────────────────────────────────────────
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/otp-verification',
      builder: (context, state) => const OtpVerificationScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/reset-success',
      builder: (context, state) => const ResetSuccessScreen(),
    ),

    // ── Main App (Shell) ───────────────────────────────────────────────────
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainLayout(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/scanner',
          builder: (context, state) => const ScannerScreen(),
        ),
        GoRoute(
          path: '/wallet',
          builder: (context, state) => const WalletScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),

    // ── Scanning Workflow ──────────────────────────────────────────────────
    GoRoute(
      path: '/bottle-scanner',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return BottleScannerScreen(
          shopId: extra['shopId'] as String? ?? '',
        );
      },
    ),
    GoRoute(
      path: '/bottle-details',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return BottleDetailsScreen(
          shopId: extra['shopId'] as String? ?? '',
          barcode: extra['barcode'] as String? ?? '',
        );
      },
    ),
    GoRoute(
      path: '/reward-success',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return RewardSuccessScreen(
          amount: extra['amount'] as double? ?? 10.0,
          code: extra['code'] as String? ?? 'Unknown',
        );
      },
    ),

    // ── Notifications ──────────────────────────────────────────────────────
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),

    // ── Settings ──────────────────────────────────────────────────────────
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/refer-and-earn',
      builder: (context, state) => const ReferAndEarnScreen(),
    ),
    GoRoute(
      path: '/achievements',
      builder: (context, state) => const AchievementsScreen(),
    ),
    GoRoute(
      path: '/notification-settings',
      builder: (context, state) => const NotificationSettingsScreen(),
    ),
    GoRoute(
      path: '/theme-settings',
      builder: (context, state) => const ThemeSettingsScreen(),
    ),
    GoRoute(
      path: '/language-settings',
      builder: (context, state) => const LanguageSettingsScreen(),
    ),
    GoRoute(
      path: '/privacy-policy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: '/terms-conditions',
      builder: (context, state) => const TermsConditionsScreen(),
    ),
    GoRoute(
      path: '/help-support',
      builder: (context, state) => const HelpSupportScreen(),
    ),
    GoRoute(
      path: '/faq',
      builder: (context, state) => const FaqScreen(),
    ),
    GoRoute(
      path: '/contact-support',
      builder: (context, state) => const ContactSupportScreen(),
    ),
    GoRoute(
      path: '/report-problem',
      builder: (context, state) => const ReportProblemScreen(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: '/active-sessions',
      builder: (context, state) => const ActiveSessionsScreen(),
    ),
    GoRoute(
      path: '/permissions',
      builder: (context, state) => const PermissionsScreen(),
    ),
    GoRoute(
      path: '/security',
      builder: (context, state) => const SecurityScreen(),
    ),
    GoRoute(
      path: '/about-app',
      builder: (context, state) => const AboutAppScreen(),
    ),
    GoRoute(
      path: '/open-source-licenses',
      builder: (context, state) => const OpenSourceLicensesScreen(),
    ),
    GoRoute(
      path: '/delete-account',
      builder: (context, state) => const DeleteAccountScreen(),
    ),
  ],
);
