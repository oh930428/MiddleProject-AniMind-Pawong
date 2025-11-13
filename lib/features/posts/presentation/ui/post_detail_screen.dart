import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:middleproject_animind_pawong/core/theme/app_colors.dart';
import 'package:middleproject_animind_pawong/features/posts/data/repositories/posts_repository.dart';
import 'package:middleproject_animind_pawong/features/posts/domain/viewmodel/posts_viewmodel.dart';
import 'package:middleproject_animind_pawong/features/posts/presentation/widgets/delete_records.dart';
import 'package:provider/provider.dart';

import '../../../home/domain/entities/home_posts.dart';

class PostDetailScreen extends StatelessWidget {
  final HomePost postItem;

  const PostDetailScreen({super.key, required this.postItem});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostsViewModel(context.read<PostsRepository>()),
      child: _PostDetailScreen(postItem: postItem),
    );
  }
}

class _PostDetailScreen extends StatelessWidget {
  const _PostDetailScreen({super.key, required this.postItem});

  final HomePost postItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Animind - ${postItem.postType == "post" ? "게시글" : postItem.postType}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'edit') {
                context.push("/posts/add", extra: postItem);
              }
              if (value == 'delete') {
                deleteDialog(context, postItem.id.toString());
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('수정')),
              const PopupMenuItem(value: 'delete', child: Text('삭제')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          "${postItem.userName} · ${postItem.createdAt.year}-${postItem.createdAt.month.toString().padLeft(2, '0')}-${postItem.createdAt.day.toString().padLeft(2, '0')}",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      spacing: 8,
                      children: [
                        // 게시글 타입
                        Chip(
                          label: Text(
                            postItem.postType,
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
                        // 종 및 품종
                        Text(
                          "${postItem.species} · ${postItem.breeds}",
                          style: const TextStyle(color: Colors.black54),
                        ),
                        // 나이, 몸무게, 성별
                        Text(
                          "3살 · ${postItem.weight}kg · ${postItem.gender}",
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // 게시글 제목
                    Text(
                      postItem.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // 게시글 내용
                    Text(
                      postItem.content,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 10),
                    // 이미지
                    SizedBox(
                      height: 300,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          postItem.imageUrl ?? "",
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.black.withOpacity(0.2), height: 2),
              // 댓글 갯수
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Icon(Icons.chat_bubble_outline), Text('댓글 1개')],
                ),
              ),
              Divider(color: Colors.black.withOpacity(0.2), height: 2),
              // 댓글
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                    "${postItem.createdAt.year}-${postItem.createdAt.month.toString().padLeft(2, '0')}-${postItem.createdAt.day.toString().padLeft(2, '0')}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "첫번째 댓글입니다.",
                                style: const TextStyle(
                                  fontSize: 12,
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
              // 댓글 추가
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
