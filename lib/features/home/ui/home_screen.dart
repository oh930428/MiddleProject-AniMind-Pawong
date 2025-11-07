import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../auth/domain/viewmodel/auth_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("홈 입니다")),
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              await context.read<AuthViewModel>().logOut();
              context.go("/socialLogin");
            },
            child: Text("로그아웃"),
          ),
        ),
      ),
    );
  }
}
