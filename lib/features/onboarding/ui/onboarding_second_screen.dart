import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingSecondScreen extends StatelessWidget {
  const OnboardingSecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffcdf7f0),
        title: Text(
          "게시글 및 Q&A 홍보",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey),
                child: Image.asset(
                  'assets/images/onboarding2.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            //button
            Container(
              color: Color(0xffcdf7f0),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/onboarding3');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '다음',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
