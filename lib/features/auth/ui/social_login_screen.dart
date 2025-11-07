import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../domain/viewmodel/auth_viewmodel.dart';

class SocialLoginScreen extends StatelessWidget {
  const SocialLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE9FBF5),
      body: Center(
        child: Consumer<AuthViewModel>(
          builder: (context, vm, _) {
            if (vm.userId != null) {
              Future.microtask(() => context.go('/home'));
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 로고
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

                const SizedBox(height: 40),

                const Text(
                  "반려동물 생활의 시작",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                const Text(
                  "간편하게 로그인하고 서비스를 이용하세요",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7C79),
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: GoogleLoginButton(isLoading: vm.isLoading),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class GoogleLoginButton extends StatelessWidget {
  final bool isLoading;

  const GoogleLoginButton({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator(
            color: Color(0xFFE7EBED),
            backgroundColor: Color(0xFF4BA487),
            strokeWidth: 6,
          )
        : ElevatedButton(
            onPressed: isLoading
                ? null
                : context.read<AuthViewModel>().loginWithGoogle,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://www.google.com/favicon.ico',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Google로 로그인하기',
                    style: TextStyle(
                      color: Color(0xFF263938),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
