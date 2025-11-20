import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../home/domain/entities/home_posts.dart';
import '../../data/repositories/comments_repository.dart';
import '../../data/repositories/posts_repository.dart';
import '../../domain/viewmodel/comments_viewmodel.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PostsViewModel(context.read<PostsRepository>()),
        ),
        ChangeNotifierProvider(
          create: (_) => CommentsViewModel(
            context.read<CommentsRepository>(),
            postItem.id,
          ),
        ),
      ],
      child: _PostDetailScreen(postItem: postItem),
    );
  }
}

class _PostDetailScreen extends StatefulWidget {
  final HomePost postItem;
  const _PostDetailScreen({super.key, required this.postItem});

  @override
  State<_PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<_PostDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<PostsViewModel>().getPostById(widget.postItem.id);
      await context.read<CommentsViewModel>().loadInitialComments(
        widget.postItem.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.postItem.postType == "post" ? "게시글" : widget.postItem.postType,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: textScaler.scale(20.0),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'edit') {
                context.push("/posts/add", extra: widget.postItem);
              }
              if (value == 'delete') {
                deleteDialog(context, widget.postItem.id.toString());
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
        child: Consumer<PostsViewModel>(
          builder: (context, viewModel, child) {
            return RefreshIndicator(
              onRefresh: () async {
                await viewModel.getPostById(widget.postItem.id);
                await context.read<CommentsViewModel>().loadInitialComments(
                  widget.postItem.id,
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 80),
                child: Column(
                  children: [
                    PostHeader(postItem: widget.postItem),
                    const SizedBox(height: 10),
                    PostContent(postItem: widget.postItem),
                    const SizedBox(height: 10),
                    Divider(color: Colors.black.withOpacity(0.2), height: 2),
                    PostCommetsSection(postId: widget.postItem.id),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomSheet: PostCommentInput(postId: widget.postItem.id),
    );
  }
}
