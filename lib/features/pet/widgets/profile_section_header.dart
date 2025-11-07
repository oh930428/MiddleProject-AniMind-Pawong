import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

// 프로필 섹션의 헤더를 표시하는 위젯
class ProfileSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onManagePressed;

  const ProfileSectionHeader({
    super.key,
    required this.title,
    required this.onManagePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppLayout.horizontalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextButton(onPressed: onManagePressed, child: const Text('관리하기')),
        ],
      ),
    );
  }
}
