import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:middleproject_animind_pawong/features/home/domain/entities/post_item.dart';
import 'package:middleproject_animind_pawong/features/posts/presentation/ui/post_detail_screen.dart';
import 'package:provider/provider.dart';
import 'home_shell.dart';

// ViewModel
import '../../features/auth/domain/viewmodel/auth_viewmodel.dart';

// UI
import '../../features/splash/ui/splash_screen.dart';
import '../../features/onboarding/ui/onboarding_first_screen.dart';
import '../../features/onboarding/ui/onboarding_fourth_screen.dart';
import '../../features/onboarding/ui/onboarding_second_screen.dart';
import '../../features/onboarding/ui/onboarding_third_screen.dart';
import '../../features/auth/ui/social_login_screen.dart';
import '../../features/auth/ui/signup_screen.dart';
import '../../features/home/presentation/ui/home_screen.dart';
import '../../features/posts/presentation/ui/post_screen.dart';
import '../../features/faq/ui/faq_screen.dart';
import '../../features/pet/ui/pet_profile_screen.dart';
import '../../features/notification/ui/notification_screen.dart';

GoRouter createRouter(BuildContext context) {
  final authViewModel = context.read<AuthViewModel>();

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authViewModel,
    routes: [
      // 스플래시
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),

      // 온보딩
      GoRoute(
        path: '/onboarding1',
        builder: (_, __) => const OnboardingFirstScreen(),
      ),
      GoRoute(
        path: '/onboarding2',
        builder: (_, __) => const OnboardingSecondScreen(),
      ),
      GoRoute(
        path: '/onboarding3',
        builder: (_, __) => const OnboardingThirdScreen(),
      ),
      GoRoute(
        path: '/onboarding4',
        builder: (_, __) => const OnboardingFourthScreen(),
      ),

      // 소셜 로그인
      GoRoute(
        path: '/socialLogin',
        builder: (_, __) => const SocialLoginScreen(),
      ),

      // 회원가입
      GoRoute(path: '/signup', builder: (_, __) => const SignupScreen()),

      //홈 / 프로필 / FAQ
      ShellRoute(
        builder: (_, __, child) => HomeShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
          GoRoute(
            path: '/posts',
            builder: (_, __) => const PostScreen(),
            routes: [
              GoRoute(
                path: ":post_id",
                builder: (_, state) {
                  final postItem = state.extra as PostItem;
                  return PostDetailScreen(postItem: postItem);
                },
              ),
            ],
          ),
          GoRoute(path: '/faq', builder: (_, __) => const FaqScreen()),
          GoRoute(
            path: '/notification',
            builder: (_, __) => const NotificationScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, __) => const PetProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
