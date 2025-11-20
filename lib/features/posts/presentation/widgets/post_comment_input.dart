import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/viewmodel/comments_viewmodel.dart';

class PostCommentInput extends StatelessWidget {
  final int postId;
  const PostCommentInput({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return _PostCommentInput(postId: postId);
  }
}

class _PostCommentInput extends StatefulWidget {
  final int postId;
  const _PostCommentInput({super.key, required this.postId});

  @override
  State<_PostCommentInput> createState() => _PostCommentInputState();
}

class _PostCommentInputState extends State<_PostCommentInput> {
  final TextEditingController _commentInputcontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentInputcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CommentsViewModel>();

    return Container(
      padding: EdgeInsets.all(12.0),
      color: Colors.white,
      child: Row(
        spacing: 10,
        children: [
          Expanded(
            child: TextField(
              controller: _commentInputcontroller,
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

          IconButton(
            onPressed: viewModel.isSending
                ? null
                : () async {
                    FocusScope.of(context).unfocus();

                    final content = _commentInputcontroller.text.trim();
                    if (content.isEmpty) return;

                    await viewModel.addComment(content);

                    _commentInputcontroller.clear();
                  },
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.all(12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            icon: viewModel.isSending
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: const CircularProgressIndicator(
                      color: Color(0xFFE7EBED),
                      backgroundColor: Color(0xFF4BA487),
                      strokeWidth: 6,
                    ),
                  )
                : const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
