import 'package:flutter/material.dart';

class PetProfilePage extends StatelessWidget {
  const PetProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("반려동물 프로필")),
      body: SafeArea(child: Center(child: Text("반려동물 프로필"))),
    );
  }
}
