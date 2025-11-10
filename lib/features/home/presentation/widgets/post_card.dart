import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/post_item.dart';

class PostCard extends StatelessWidget {
  final PostItem postItem;

  const PostCard({super.key, required this.postItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push("/posts/${postItem.id}", extra: postItem);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          border: Border.all(color: AppColors.border, width: 1),
          borderRadius: BorderRadius.circular(AppLayout.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 유저 아바타, 이름, 게시 일자
              Row(
                children: [
                  const CircleAvatar(child: Icon(Icons.person)),
                  const SizedBox(width: 8),
                  Text(
                    "${postItem.user_id} · ${postItem.created_at}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // 종 및 품종
              Row(
                children: [
                  Chip(
                    label: Text(
                      postItem.post_type,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${postItem.species} · ${postItem.breeds}",
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // 게시글 제목
              const Text(
                "고양이가 밥을 안 먹어요",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 6),

              // 게시글 내용
              const Text(
                "첫번째 게시글입니다 !! 첫번째 게시글입니다 !! 첫번째 게시글입니다 !! 첫번째 게시글입니다 !! 첫번째 게시글입니다 !! 첫번째 게시글입니다 !! 첫번째 게시글입니다 !! 첫번째 게시글입니다 !! 첫번째 게시글입니다 !!",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),

              const SizedBox(height: 10),

              // 이미지
              SizedBox(
                height: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    postItem.image_url,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
