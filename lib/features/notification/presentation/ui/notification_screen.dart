import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:middleproject_animind_pawong/features/posts/domain/viewmodel/posts_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../domain/viewmodel/notification_viewmodel.dart';

import '../../../../core/theme/app_colors.dart';

// 알림 화면 위젯
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _NotificationScreen();
  }
}

class _NotificationScreen extends StatelessWidget {
  const _NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          //backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: Text(
              '알림',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            elevation: 0,
            //backgroundColor: Colors.white,
          ),
          body: RefreshIndicator(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: viewModel.notifications.length,
              itemBuilder: (context, index) {
                final notification = viewModel.notifications[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 8.0,
                  ),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: InkWell(
                    onTap: () async {
                      // 읽음 처리
                      if (!notification.isRead) {
                        await viewModel.updateIsRead(notification);
                      }

                      // 게시글 단일 조회
                      final post = await context
                          .read<PostsViewModel>()
                          .getPostById(notification.postId);

                      // 상세 화면 이동
                      context.go("/posts/${notification.postId}", extra: post);
                    },
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: notification.isRead
                            ? Colors.white
                            : Colors.blue.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(radius: 16, child: Icon(Icons.person)),

                          const SizedBox(width: 16.0),

                          Expanded(
                            child: Text(
                              "${notification.fromUserName}님이 새로운 답변을 남겼습니다.",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textPrimary,
                                //color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            onRefresh: () async {
              await viewModel.initNotifications();
            },
          ),
        );
      },
    );
  }
}
