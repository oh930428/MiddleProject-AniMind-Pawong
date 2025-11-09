import 'package:flutter/material.dart';

import '../widget/notification_item.dart';

// 알림 화면 위젯
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          '알림',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: const [
          NotificationItem(
            sender: '박영희',
            action: '답변을 남겼습니다',
            content: '강아지가 밥을 안 먹어요\n저희 강아지도 비슷한 증상이 있었는데 병원 가보니 소화불량이었어요.',
            time: '1일 전',
            isNew: true,
            avatarUrl: 'https://i.pravatar.cc/150?img=1',
          ),
          NotificationItem(
            sender: '이민수',
            action: '댓글을 남겼습니다',
            content: '우리 고양이 귀여운 모습\n정말 귀엽네요!',
            time: '2일 전',
            isNew: false,
            avatarUrl: 'https://i.pravatar.cc/150?img=2',
          ),
          NotificationItem(
            sender: '김철수',
            action: '게시글을 좋아합니다',
            content: '산책하기 좋은 날씨네요!',
            time: '3일 전',
            isNew: false,
            avatarUrl: 'https://i.pravatar.cc/150?img=3',
          ),
        ],
      ),
    );
  }
}
