import 'package:flutter/material.dart';

import '../../../home/domain/entities/home_posts.dart';

class PostContent extends StatelessWidget {
  final HomePost postItem;
  const PostContent({super.key, required this.postItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 게시글 제목
          Text(
            postItem.title,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),

          const SizedBox(height: 4),

          // 게시글 내용
          Text(
            postItem.content,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          // 이미지
          postItem.imageUrl != null && postItem.imageUrl!.isNotEmpty
              ? SizedBox(
                  height: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      postItem.imageUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
