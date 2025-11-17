import 'package:flutter/material.dart';
import 'package:middleproject_animind_pawong/core/extensions/datetime_extensions.dart';

import '../../../home/domain/entities/home_posts.dart';

class PostHeader extends StatelessWidget {
  final HomePost postItem;
  const PostHeader({super.key, required this.postItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              // 게시물 타입
              Chip(
                label: Text(
                  postItem.postType,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                side: BorderSide.none,
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                backgroundColor: Color(0xFFC8F2E3),
              ),

              // 종, 품종 타입
              Chip(
                label: Text(
                  "${postItem.species} · ${postItem.breeds}",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                side: BorderSide.none,
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                backgroundColor: Color(0xFFBEE3FF),
              ),

              // 나이, 몸무게, 성별
              Chip(
                label: Text(
                  "3살 · ${postItem.weight}kg · ${postItem.gender}",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                side: BorderSide.none,
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                backgroundColor: Color(0xFFBEE3FF),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 아바파, 이름, 생성일
          Row(
            spacing: 8,
            children: [
              const CircleAvatar(radius: 16, child: Icon(Icons.person)),
              Text(
                "${postItem.userName} · ${postItem.createdAt.getTimeAgo()}",
                style: const TextStyle(
                  color: Colors.black38,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
