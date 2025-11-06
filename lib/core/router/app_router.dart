import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:middleproject_animind_pawong/features/auth/domain/ui/signup_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/domain/ui/social_login_page.dart';
// viewmodel
import '../../features/auth/domain/viewmodel/auth_view_model.dart';
import '../../features/home/domain/ui/home_page.dart';
// ui
import '../../features/onboarding/domain//ui/onboarding_first_page.dart';
import '../../features/onboarding/domain//ui/onboarding_fourth_page.dart';
import '../../features/onboarding/domain//ui/onboarding_second_page.dart';
import '../../features/onboarding/domain//ui/onboarding_third_page.dart';
import '../../features/pet/domain/ui/pet_profile_screen.dart';
import 'home_shell.dart';

GoRouter createRouter(BuildContext context) {
  final authViewModel = context.read<AuthViewModel>();

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: authViewModel,
    routes: [
      GoRoute(
        path: '/onboarding1',
        builder: (context, state) => const OnboardingFirstPage(),
      ),
      GoRoute(
        path: '/onboarding2',
        builder: (context, state) => const OnboardingSecondPage(),
      ),
      GoRoute(
        path: '/onboarding3',
        builder: (context, state) => const OnboardingThirdPage(),
      ),
      GoRoute(
        path: '/onboarding4',
        builder: (context, state) => const OnboardingFourthPage(),
      ),

      GoRoute(
        path: '/login',
        builder: (context, state) => const SocialLoginPage(),
      ),

      GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),

      ShellRoute(
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomePage()),
          GoRoute(
            path: '/profile',
            builder: (_, __) => const PetProfileScreen(),
          ),
          GoRoute(path: '/faq', builder: (_, __) => const FAQPage()),
        ],
      ),
    ],
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final doneOnboarding = prefs.getBool('onboarding_status') ?? false;
      final isOnboardingRoute = state.matchedLocation.startsWith('/onboarding');
      if (isOnboardingRoute) {
        return null;
      }
      if (!doneOnboarding && !isOnboardingRoute) {
        return '/onboarding1';
      }

      final isLoggedIn = authViewModel.userId != null;
      final loggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !loggingIn) return '/login';
      if (isLoggedIn && loggingIn) return '/signup';
      return null;
    },
  );
}
