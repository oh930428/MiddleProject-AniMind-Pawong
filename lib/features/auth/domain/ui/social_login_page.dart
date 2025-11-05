import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/auth_view_model.dart';

class SocialLoginPage extends StatelessWidget {
  const SocialLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE9FBF5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로고
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Color(0xFFFFBCA7),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.pets,
                    size: 48,
                    color: Color(0xFF7CB342),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            Text(
              "반려동물 생활의 시작",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 10),

            Text(
              "간편하게 로그인하고 서비스를 이용하세요",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7C79),
              ),
            ),

            const SizedBox(height: 20),

            // 구글 로그인 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Selector<AuthViewModel, bool>(
                selector: (_, vm) => vm.isLoading,
                builder: (_, isLoading, _) {
                  return GoogleLoginButton(isLoading: isLoading);
                },
              ),
            ),
          ],
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
                : context.read<AuthViewModel>().signInWithGoogle,
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
