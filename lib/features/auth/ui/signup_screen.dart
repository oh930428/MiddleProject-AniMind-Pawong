import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:middleproject_animind_pawong/features/auth/domain/viewmodel/auth_viewmodel.dart';
import 'package:middleproject_animind_pawong/features/auth/domain/viewmodel/signup_viewmodel.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child: _SignupPage(),
    );
  }
}

class _SignupPage extends StatelessWidget {
  const _SignupPage();

  @override
  Widget build(BuildContext context) {
    final authVM = context.read<AuthViewModel>();

    return Consumer<SignUpViewModel>(
      builder: (context, vm, _) {
        final nameController = vm.nameController;
        final phoneController = vm.phoneController;
        final emailController = TextEditingController(
          text: authVM.userEmail ?? "",
        );

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                context.go("/socialLogin");
              },
            ),
            centerTitle: true,
            title: Text("회원가입", style: TextStyle(fontSize: 18.0)),
          ),
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
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

                    const SizedBox(height: 16),

                    // 타이틀
                    Text(
                      "반려동물과 함께하는 일상",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF263938),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 설명
                    Text(
                      "정보를 입력하고 서비스를 시작해보세요.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7C79),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 이름 필드
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "이름",
                        hintText: "이름을 입력하세요",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 이메일 필드
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "이메일",
                        hintText: "이메일을 입력하세요",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 핸드폰 필드
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "핸드폰번호",
                        hintText: "01012345678",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ✅ 개인정보 동의 체크박스
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF7F8F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: vm.isPrivacyAgreed,
                            onChanged: (value) =>
                                vm.togglePrivacyAgreement(value ?? false),
                          ),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  "개인정보 수집 및 이용에 동의합니다.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF263938),
                                  ),
                                ),
                                Text(
                                  "서비스 이용을 위해 이름, 이메일, 핸드폰 번호를\n수집합니다",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF6B7C79),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 유저 회원가입
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4BA487),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: vm.isLoading
                          ? null
                          : () async {
                              await vm.signUp(
                                id: authVM.userId ?? "",
                                name: nameController.text,
                                email: authVM.userEmail ?? "",
                                phone: phoneController.text,
                              );

                              if (context.mounted) {
                                context.go('/home');
                              }
                            },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: SizedBox(
                          width: double.maxFinite,
                          child: Text(
                            "회원가입 하기",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
