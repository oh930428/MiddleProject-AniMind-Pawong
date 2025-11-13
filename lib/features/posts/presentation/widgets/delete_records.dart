import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../domain/viewmodel/posts_viewmodel.dart';

Future<void> deleteDialog(BuildContext context, String postId) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('게시글 삭제'),
      content: const Text('정말 이 게시글을 삭제하시겠습니까?\n삭제된 기록은 복구할 수 없습니다'),
      actions: [
        OutlinedButton(
          onPressed: () => context.pop(),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade700, width: 2),
            foregroundColor: Colors.black,
          ),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () async {
            await context.read<PostsViewModel>().deletePosts(postId: postId);
            context.pop(); // 닫기
            context.go("/posts");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Colors.white,
          ),
          child: const Text('삭제'),
        ),
      ],
    ),
  );
}
