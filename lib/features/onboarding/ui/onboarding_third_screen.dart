import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingThirdScreen extends StatelessWidget {
  const OnboardingThirdScreen({super.key});

  Future<void> _saveOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_status', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC7F3EE),
      appBar: AppBar(
        backgroundColor: Color(0xFFC7F3EE),
        title: Text(
          "반려동물의 병원 기록 홍보",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/onboarding3.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            //button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: () async {
                  await _saveOnboardingStatus();
                  context.go("/onboarding4");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: const Text(
                    '다음',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
