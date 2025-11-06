import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/domain/viewmodel/auth_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // 스플래시 화면 표시 시간 (1.5초)
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final authViewModel = context.read<AuthViewModel>();
    final currentUserId = authViewModel.userId;

    final doneOnboarding = prefs.getBool('onboarding_status') ?? false;

    if (!mounted) return;

    // 온보딩 안했으면 온보딩 화면으로
    if (!doneOnboarding) {
      context.go('/onboarding1');
      return;
    }

    // 로그인된 사용자 없으면 로그인 화면으로
    if (currentUserId == null) {
      context.go("/socialLogin");
      return;
    }

    // 사용자 정보 확인
    final isUser = await authViewModel.fetchUserById(currentUserId);

    if (!mounted) return;

    if (isUser.isNotEmpty) {
      context.go("/home");
    } else {
      context.go("/signup");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE9FBF5),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Icon(Icons.pets, size: 48, color: Color(0xFF7CB342)),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "애니마인드",
                  style: TextStyle(
                    color: Color(0xFF263938),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const Text(
                  "Animind",
                  style: TextStyle(
                    color: Color(0xFF263938),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "반려동물과 함께하는 건강한 일상",
                  style: TextStyle(
                    color: Color(0xFF263938),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
              child: const Center(
                child: SizedBox(
                  child: CircularProgressIndicator(
                    color: Color(0xFF66CDAA), // 예시로 민트색
                    strokeWidth: 6,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
