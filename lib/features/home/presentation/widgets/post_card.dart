import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/home_posts.dart';

class PostCard extends StatelessWidget {
  final HomePost recentPost;

  const PostCard({super.key, required this.recentPost});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push("/posts/${recentPost.id}", extra: recentPost),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 게시글 타입 및 종, 품종
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            recentPost.postType,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          side: BorderSide.none,
                          padding: EdgeInsets.zero,
                          backgroundColor: const Color(0xFFC8F2E3),
                          visualDensity: VisualDensity(
                            horizontal: 0,
                            vertical: -4,
                          ),
                        ),

                        const SizedBox(width: 6),

                        Chip(
                          label: Text(
                            "${recentPost.species} · ${recentPost.breeds}",
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          side: BorderSide.none,
                          padding: EdgeInsets.zero,
                          backgroundColor: Color(0xFFBEE3FF),
                          visualDensity: VisualDensity(
                            horizontal: 0,
                            vertical: -4,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // 유저 아바타, 이름, 게시 일자
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 10,
                          child: Icon(Icons.person, size: 14),
                        ),

                        const SizedBox(width: 4),

                        Expanded(
                          child: Text(
                            "${recentPost.userName} · ${recentPost.createdAt.getTimeAgo()}",
                            style: const TextStyle(
                              color: Colors.black38,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // 게시물 제목
                    Text(
                      recentPost.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // 게시글 내용
                    Expanded(
                      child: Text(
                        recentPost.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 이미지
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: recentPost.imageUrl == null
                      ? const Icon(Icons.pets, size: 80, color: Colors.grey)
                      : Image.network(
                          recentPost.imageUrl!,
                          width: double.maxFinite,
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
