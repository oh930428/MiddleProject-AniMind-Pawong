import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../home/domain/entities/home_posts.dart';
import '../../data/repositories/posts_repository.dart';
import '../../domain/viewmodel/posts_viewmodel.dart';
import '../widgets/delete_records.dart';
import '../widgets/post_comment_input.dart';
import '../widgets/post_commets_section.dart';
import '../widgets/post_content.dart';
import '../widgets/post_header.dart';

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
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 게시글 - header
              PostHeader(postItem: postItem),

              const SizedBox(height: 10),

              // 게시글 - content
              PostContent(postItem: postItem),

              const SizedBox(height: 10),

              Divider(color: Colors.black.withOpacity(0.2), height: 2),

              // 게시글 - comments section
              PostCommetsSection(postId: postItem.id),
            ],
          ),
        ),
      ),
      bottomSheet: PostCommentInput(postId: postItem.id),
    );
  }
}
