import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../domain/viewmodel/auth_viewmodel.dart';
import '../domain/viewmodel/signup_viewmodel.dart';

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
      builder: (context, signupVM, _) {
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
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: SingleChildScrollView(
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

                  _SignupForm(authVM: authVM, signupVM: signupVM),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SignupForm extends StatefulWidget {
  final AuthViewModel authVM;
  final SignUpViewModel signupVM;

  const _SignupForm({super.key, required this.authVM, required this.signupVM});

  @override
  State<_SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<_SignupForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
      text: widget.authVM.userEmail ?? "",
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nameController = widget.signupVM.nameController;
    final phoneController = widget.signupVM.phoneController;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // 이름
          _buildTextField(
            controller: nameController,
            label: "이름",
            hint: "이름을 입력하세요",
            validator: (value) =>
                value == null || value.isEmpty ? "이름을 입력해주세요" : null,
          ),

          const SizedBox(height: 16),

          // 이메일
          _buildTextField(
            controller: _emailController,
            label: "이메일",
            hint: "이메일을 입력하세요",
            enabled: false,
          ),

          const SizedBox(height: 16),

          // 핸드폰 번호
          _buildTextField(
            controller: phoneController,
            label: "핸드폰번호",
            hint: "01012345678",
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) return "핸드폰번호를 입력해주세요";
              if (!RegExp(r'^\d{10,11}$').hasMatch(value)) {
                return "올바른 핸드폰번호를 입력해주세요";
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // 개인정보 수집 및 이용 동의
          _buildPrivacyCheckbox(),

          const SizedBox(height: 16),

          // 회원가입 하기 버튼
          _buildSignupButton(),
        ],
      ),
    );
  }

  // 이름, 이메일, 핸드폰 번호 텍스트 form 필드
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }

  //  개인정보 수집 및 동의
  Widget _buildPrivacyCheckbox() {
    return FormField<bool>(
      initialValue: widget.signupVM.isPrivacyAgreed,
      validator: (value) {
        if (value != true) return "개인정보 수집 동의가 필요합니다";
        return null;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: state.value ?? false,
                    onChanged: (value) {
                      state.didChange(value);
                      widget.signupVM.togglePrivacyAgreement(value ?? false);
                    },
                    checkColor: Colors.white, // 체크 표시 색상
                    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Color(0xFF4BA487);
                      }
                      return Colors.white;
                    }),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "개인정보 수집 및 이용에 동의합니다.",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 자동으로 validator 메시지 표시
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  state.errorText!,
                  style: TextStyle(color: Color(0xFFB3261E), fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }

  // 회원가입 하기 버튼
  Widget _buildSignupButton() {
    return Consumer<SignUpViewModel>(
      builder: (context, signupVM, _) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4BA487),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          onPressed: signupVM.isLoading
              ? null
              : () async {
                  if (!_formKey.currentState!.validate()) return;

                  if (!signupVM.isPrivacyAgreed) {
                    signupVM.validatePrivacy();
                    print(signupVM.showPrivacyError);
                    return;
                  }

                  await signupVM.signUp(
                    id: widget.authVM.userId ?? "",
                    name: signupVM.nameController.text,
                    email: widget.authVM.userEmail ?? "",
                    phone: signupVM.phoneController.text,
                  );

                  if (!mounted) return;
                  context.go('/home');
                },
          child: signupVM.isLoading
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 6.0,
                  ),
                  child: CircularProgressIndicator(
                    color: Color(0xFF66CDAA),
                    strokeWidth: 6,
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
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
        );
      },
    );
  }
}
