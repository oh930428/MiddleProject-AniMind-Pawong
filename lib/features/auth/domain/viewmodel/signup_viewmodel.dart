import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class SignUpViewModel extends ChangeNotifier {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  bool isPrivacyAgreed = false;
  bool showPrivacyError = false;
  bool isLoading = false;

  // 개인정보 동의 토글
  void togglePrivacyAgreement(bool value) {
    isPrivacyAgreed = value;

    if (value == true) {
      showPrivacyError = false; // 체크되면 에러 숨김
    }

    notifyListeners();
  }

  // 제출 버튼 눌렀을 때
  void validatePrivacy() {
    if (!isPrivacyAgreed) {
      showPrivacyError = true;
      notifyListeners();
    }
  }

  Future<void> signUp({
    required String id,
    required String name,
    required String email,
    required String phone,
  }) async {
    if (!isPrivacyAgreed) {
      debugPrint("개인정보 수집 동의 필요");
      return;
    }

    isLoading = true;
    notifyListeners();

    await supabase.from('users').insert({
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'is_privacy_agreed': isPrivacyAgreed,
    });

    await Future.delayed(const Duration(seconds: 1));

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
