import 'package:flutter/material.dart';
import 'package:middleproject_animind_pawong/core/theme/app_colors.dart';

import '../../../home/domain/entities/post_item.dart';

class PostDetailScreen extends StatelessWidget {
  final PostItem postItem;

  const PostDetailScreen({super.key, required this.postItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Animind - ${postItem.post_type == "post" ? "게시글" : postItem.post_type}',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: textScaler.scale(24.0),
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert), // ⋮ 세로 점 3개
            onSelected: (value) {
              if (value == 'edit') {
                print('수정 클릭됨');
                // 수정 로직 추가
              } else if (value == 'delete') {
                print('삭제 클릭됨');
                // 삭제 로직 추가
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('수정')),
              const PopupMenuItem(value: 'delete', child: Text('삭제')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Divider(color: Colors.black.withOpacity(0.2), height: 2),

              Padding(
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
                          "${postItem.species} · ${postItem.breeds} · 3살 · ${postItem.weight}kg",
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // 게시글 제목
                    const Text(
                      "고양이가 밥을 안 먹어요",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // 게시글 내용
                    const Text(
                      "첫번째 게시글입니다 !! 첫번째 게시글입니다 !! 첫번째 게시글입니다 !! 첫번째 게시글입니다 !! 첫번째 게시글입니다 !! 첫번째 게시글입니다 !! 첫번째 게시글입니다 !! 첫번째 게시글입니다 !! 첫번째 게시글입니다 !!",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
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

              Divider(color: Colors.black.withOpacity(0.2), height: 2),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  spacing: 10,
                  children: [Icon(Icons.chat_bubble_outline), Text('답변 3')],
                ),
              ),

              Divider(color: Colors.black.withOpacity(0.2), height: 2),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("답변 3개"),
                    Row(
                      spacing: 10,
                      children: [
                        const CircleAvatar(child: Icon(Icons.person)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                spacing: 10,
                                children: [
                                  Text(
                                    "박영희",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    postItem.created_at,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                postItem.content,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Divider(color: Colors.black.withOpacity(0.2), height: 2),

              Container(
                padding: EdgeInsets.all(12.0),
                color: Colors.white,
                child: Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "댓글을 입력하세요...",
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text("등록"),
                    ),
                  ],
                ),
              ),

              Divider(color: Colors.black.withOpacity(0.2), height: 2),
            ],
          ),
        ),
      ),
    );
  }
}
