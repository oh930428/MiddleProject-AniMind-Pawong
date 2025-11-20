import 'package:flutter/material.dart';
import 'package:middleproject_animind_pawong/core/extensions/datetime_extensions.dart';
import 'package:middleproject_animind_pawong/features/posts/domain/viewmodel/comments_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../home/domain/entities/home_posts.dart';
import '../../data/repositories/comments_repository.dart';

class PostCommetsSection extends StatelessWidget {
  final int postId;
  const PostCommetsSection({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return _PostCommentsSection(postId: postId);
  }
}

class _PostCommentsSection extends StatefulWidget {
  final int postId;
  const _PostCommentsSection({super.key, required this.postId});

  @override
  State<_PostCommentsSection> createState() => _PostCommentsSectionState();
}

class _PostCommentsSectionState extends State<_PostCommentsSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommentsViewModel>().loadInitialComments(widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentsViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.comment_rounded, color: Colors.black45),
                  const SizedBox(width: 10),
                  Text(
                    "답변 ${viewModel.comments.length}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),

            Divider(color: Colors.black.withOpacity(0.2), height: 2),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: viewModel.comments.length,
              itemBuilder: (context, index) {
                final comment = viewModel.comments[index];

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
                            "${comment.userName} · ${comment.createdAt.getTimeAgo()}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        comment.content,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
