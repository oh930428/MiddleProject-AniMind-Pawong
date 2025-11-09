import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeShell extends StatelessWidget {
  final Widget child;

  const HomeShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateIndex(context);

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
              context.go('/profile');
              break;
            case 2:
              context.go('/faq');
              break;
            case 3:
              context.go('/notification');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: '프로필'),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark),
            label: 'FAQ',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: '알림'),
        ],
      ),
    );
  }

  int _calculateIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/profile')) return 1;
    if (location.startsWith('/faq')) return 2;
    if (location.startsWith('/notification')) return 3;

    return 0;
  }
}
