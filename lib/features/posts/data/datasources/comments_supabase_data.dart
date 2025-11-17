import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/comments.dart';

class CommentsSupabaseDataSource {
  late final Dio _dio;
  final String _baseUrl = "${dotenv.env["SUPABASE_BASE_URL"]}/rest/v1";

  CommentsSupabaseDataSource() {
    final String apiKey = dotenv.env["SUPABASE_API_KEY"] ?? "";
    final String authorization = dotenv.env["SUPABASE_API_KEY"] ?? "";

    _dio = Dio(
      BaseOptions(
        headers: {
          "apikey": apiKey,
          "Authorization": "Bearer $authorization",
          "Content-Type": "application/json",
        },
      ),
    );
  }

  String? get _userId => Supabase.instance.client.auth.currentSession?.user.id;

  // 전체 게시글 답변 - API 호출 및 응답
  Future<List<Comments>> getAllCommentsWithDio(int postId) async {
    final response = await _dio.get(
      "$_baseUrl/comments",
      queryParameters: {
        "select": "*, users(name)",
        "post_id": "eq.$postId",
        "order": "created_at.asc",
      },
    );

    return (response.data as List)
        .map((json) => Comments.fromJson(json))
        .toList();
  }

  // 답변 추가 - API 호출 및 응답
  Future<void> addCommentWithDio(int postId, String content) async {
    print("userId: $_userId");
    await _dio.post(
      "$_baseUrl/comments",
      data: {"post_id": postId, "content": content, "user_id": _userId},
    );
  }
}
