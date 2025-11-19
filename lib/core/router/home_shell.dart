import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/notification/domain/viewmodel/notification_viewmodel.dart';
import '../theme/app_colors.dart';

class HomeShell extends StatefulWidget {
  final Widget child;

  const HomeShell({super.key, required this.child});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationViewModel>().initNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateIndex(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Selector<NotificationViewModel, bool>(
        selector: (_, vm) => vm.hasUnread,
        builder: (context, hasUnread, child) {
          return BottomNavigationBar(
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
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey[300],
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
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
                    if (hasUnread)
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
          );
        },
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
