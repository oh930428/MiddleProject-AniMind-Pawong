import 'package:flutter/material.dart';

import '../../data/repositories/comments_repository.dart';
import '../entities/comments.dart';

class CommentsViewModel extends ChangeNotifier {
  final CommentsRepository _commentsRepository;
  final int postId;

  List<Comments> _comments = [];
  List<Comments> get comments => _comments;

  bool isLoading = false;
  bool isSending = false;

  CommentsViewModel(this._commentsRepository, this.postId) {
    loadInitialComments(postId);
  }

  void clear() {
    _comments = [];
    notifyListeners();
  }

  // 전체 답변 불러오기
  Future<void> loadInitialComments(int postId) async {
    isLoading = true;
    notifyListeners();

    try {
      _comments = await _commentsRepository.getAllComments(postId);
    } catch (e) {
      _comments = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 답변 추가하기
  Future<void> addComment(String content) async {
    if (content.trim().isEmpty) return;

    isSending = true;
    notifyListeners();

    try {
      await _commentsRepository.addComments(postId, content);
    } finally {
      isSending = false;
      notifyListeners();
    }
  }
}
