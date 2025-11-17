import '../../domain/entities/comments.dart';
import '../datasources/comments_supabase_data.dart';

class CommentsRepository {
  final CommentsSupabaseDataSource commentsSupabaseDataSource;

  CommentsRepository(this.commentsSupabaseDataSource);

  Future<List<Comments>> getAllComments(int postId) async {
    try {
      final comments = await commentsSupabaseDataSource.getAllCommentsWithDio(
        postId,
      );
      return comments;
    } catch (e) {
      print("🚨 CommentsRepository.getAllComments 에러: $e");
      rethrow;
    }
  }

  Future<void> addComments(int postId, String content) async {
    try {
      await commentsSupabaseDataSource.addCommentWithDio(postId, content);
    } catch (e) {
      print("🚨 CommentsRepository.addComments 에러: $e");
      rethrow;
    }
  }
}
