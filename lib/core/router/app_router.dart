import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'home_shell.dart';

// ViewModel
import '../../features/auth/domain/viewmodel/auth_viewmodel.dart';

// UI
import '../../features/splash/ui/splash_screen.dart';

// UI - onboarding
import '../../features/onboarding/ui/onboarding_first_screen.dart';
import '../../features/onboarding/ui/onboarding_fourth_screen.dart';
import '../../features/onboarding/ui/onboarding_second_screen.dart';
import '../../features/onboarding/ui/onboarding_third_screen.dart';

// UI - social login
import '../../features/auth/ui/social_login_screen.dart';

// UI - signup
import '../../features/auth/ui/signup_screen.dart';

// UI - home
import '../../features/home/presentation/ui/home_screen.dart';

// UI - posts
import '../../features/posts/presentation/ui/posts_screen.dart';
import '../../features/posts/presentation/ui/post_detail_screen.dart';
import '../../features/posts/presentation/ui/post_add_screen.dart';

// UI - pet
import '../../features/pet/ui/pet_profile_screen.dart';
import '../../features/pet/ui/pet_edit_screen.dart';
import '../../features/pet/ui/setting_screen.dart';
import '../../features/pet/ui/medical_records_screen.dart';
import '../../features/pet/ui/medical_records_edit_screen.dart';

// UI - faq
import '../../features/faq/ui/faq_screen.dart';

// UI - notification
import '../../features/notification/presentation/ui/notification_screen.dart';

// entities
import '../../features/home/domain/entities/home_posts.dart';
import '../../features/pet/domain/entities/medical_records.dart';
import '../../features/pet/domain/entities/pet.dart';

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
      GoRoute(path: '/signup', builder: (_, _) => const SignupScreen()),

      ShellRoute(
        builder: (_, _, child) => HomeShell(child: child),
        routes: [
          // 홈
          GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),

          // 게시글
          GoRoute(
            path: '/posts',
            builder: (_, _) => const PostsScreen(),
            routes: [
              // 게시글 추가, 수정 화면
              GoRoute(
                path: "add",
                builder: (_, state) {
                  final postItem = state.extra as HomePost?;
                  return PostAddScreen(postItem: postItem);
                },
              ),

              // 게시글 상세
              GoRoute(
                path: ":post_id",
                builder: (_, state) {
                  final postItem = state.extra as HomePost;
                  return PostDetailScreen(postItem: postItem);
                },
              ),
            ],
          ),

          // FAQ
          GoRoute(path: '/faq', builder: (_, __) => const FaqScreen()),

          // 알림 화면
          GoRoute(
            path: '/notification',
            builder: (_, __) => const NotificationScreen(),
          ),

          // pet 프로필 화면
          GoRoute(
            path: '/profile',
            builder: (_, __) => const PetProfileScreen(),
            routes: [
              // pet 병원 기록 화면
              GoRoute(
                path: '/hospital_record',
                builder: (_, state) {
                  final pet = state.extra as Pet;
                  return MedicalRecordsScreen(pet: pet);
                },
                routes: [
                  // pet 병원 기록 수정, 추가 화면
                  GoRoute(
                    path: 'edit',
                    builder: (_, state) {
                      final record = state.extra as MedicalRecords?;
                      return MedicalRecordsEditScreen(record: record);
                    },
                  ),
                ],
              ),

              // pet 프로필 수정, 추가 화면
              GoRoute(
                path: '/pet_edit',
                builder: (_, state) {
                  final pet = state.extra as Pet?;
                  return PetEditScreen(pet: pet);
                },
              ),

              // 설정 화면
              GoRoute(
                path: '/settings',
                builder: (_, _) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
