import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/notification/domain/viewmodel/notification_viewmodel.dart';
import '../theme/app_colors.dart';

class HomeShell extends StatelessWidget {
  final Widget child;

  const HomeShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateIndex(context);
    final notificationViewModel = context.watch<NotificationViewModel>();

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/posts');
              break;
            case 2:
              context.go('/profile');
              break;
            case 3:
              context.go('/faq');
              break;
            case 4:
              context.go('/notification');
              break;
          }
        },
        selectedItemColor: AppColors.primary, // 선택된 탭 색
        unselectedItemColor: Colors.grey[300], // 선택되지 않은 탭 색
        backgroundColor: Colors.white, // 배경색
        type: BottomNavigationBarType.fixed, // 4개 이상일 때 안정적
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: '프로필'),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark),
            label: 'FAQ',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.notifications),
                if (notificationViewModel.hasUnread)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            label: '알림',
          ),
        ],
      ),
    );
  }

  int _calculateIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/posts')) return 1;
    if (location.startsWith('/profile')) return 2;
    if (location.startsWith('/faq')) return 3;
    if (location.startsWith('/notification')) return 4;

    return 0;
  }
}
