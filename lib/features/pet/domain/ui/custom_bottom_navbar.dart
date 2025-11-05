import 'package:flutter/material.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onItemSelected,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 1.0,
      height: AppLayout.minTouchTarget + 10, // 최소 터치 영역보다 약간 높게 설정
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: '홈',
        ),
        // 이미지: '탐색' 아이콘 (돋보기)
        const NavigationDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: '탐색',
        ),
        // 이미지: '작성' 아이콘 (더하기)
        const NavigationDestination(
          icon: Icon(Icons.add_circle_outline),
          selectedIcon: Icon(Icons.add_circle),
          label: '작성',
        ),
        NavigationDestination(
          // '프로필'이 선택된 상태
          icon: const Icon(Icons.person_outlined),
          selectedIcon: const Icon(Icons.person),
          label: '프로필',
        ),
      ],
    );
  }
}
