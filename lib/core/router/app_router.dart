import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// ui
import '../../features/auth/domain/ui/social_login_page.dart';
// viewmodel
import '../../features/auth/domain/viewmodel/auth_view_model.dart';
import '../../features/home/domain/ui/home_page.dart';
import '../../features/pet/domain/ui/pet_profile_page.dart';
import 'home_shell.dart';

GoRouter createRouter(BuildContext context) {
  final authViewModel = context.read<AuthViewModel>();

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: authViewModel,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const SocialLoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomePage()),
          GoRoute(
            path: '/profile',
            builder: (_, __) => const PetProfileScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = authViewModel.userId != null;
      final loggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !loggingIn) return '/login';
      if (isLoggedIn && loggingIn) return '/home';
      return null;
    },
  );
}
