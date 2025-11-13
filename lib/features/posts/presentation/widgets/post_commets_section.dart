import 'package:flutter/material.dart';
import 'package:middleproject_animind_pawong/core/extensions/datetime_extensions.dart';

import '../../../home/domain/entities/home_posts.dart';

class PostCommetsSection extends StatelessWidget {
  final HomePost postItem;
  const PostCommetsSection({super.key, required this.postItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 6,
            children: [
              const CircleAvatar(
                radius: 14,
                child: Icon(Icons.person, size: 18),
              ),
              Text(
                "${postItem.userName} · ${postItem.createdAt.getTimeAgo()}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            "첫번째 댓글입니다.첫번째 댓글입니다.",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
