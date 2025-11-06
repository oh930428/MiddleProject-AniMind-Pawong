import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/domain/viewmodel/auth_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("홈 입니다")),
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: context.read<AuthViewModel>().logOut,
            child: Text("로그아웃"),
          ),
        ),
      ),
    );
  }
}
