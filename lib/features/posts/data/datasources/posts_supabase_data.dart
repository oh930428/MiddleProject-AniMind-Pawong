import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../home/domain/entities/home_posts.dart';
import '../../domain/entities/post_filter_species.dart';

class PostsSupabaseDataSource {
  late final Dio _dio;
  final String _baseUrl = "${dotenv.env["SUPABASE_BASE_URL"]}/rest/v1/";

  PostsSupabaseDataSource() {
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

  // 종 타입 - API 호출 및 응답
  Future<List<PostFilterSpecies>> getSpeciesWithDio() async {
    final response = await _dio.get(
      "$_baseUrl/species",
      queryParameters: {"select": "*", "order": "id.desc"},
    );

    return (response.data as List)
        .map((json) => PostFilterSpecies.fromJson(json))
        .toList();
  }

  // 전체 게시글 - API 호출 및 응답
  Future<List<HomePost>> getAllPostsWithDio() async {
    final response = await _dio.get(
      "$_baseUrl/posts",
      queryParameters: {"select": "*, users(name)", "order": "id.desc"},
    );

    return (response.data as List)
        .map((json) => HomePost.fromJson(json))
        .toList();
  }

  // 게시글 추가 - API 호출 및 응답
  Future<void> addPostsWithDio({
    required String userId,
    required String postType,
    required String title,
    required String content,
    required String species,
    required String breeds,
    required String gender,
    required String birth,
    required String weight,
    required String? imageUrl,
  }) async {
    final response = await _dio.post(
      "$_baseUrl/posts",
      options: Options(headers: {'Prefer': 'return=representation'}),
      data: {
        "user_id": userId,
        "post_type": postType,
        "title": title,
        "content": content,
        "species": species,
        "breeds": breeds,
        "gender": gender,
        "birth": birth,
        "weight": weight,
        "image_url": imageUrl,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("게시글 추가 실패: ${response.statusMessage}");
    }
  }

  // 게시글 수정 - API 호출 및 응답
  Future<void> updatePostsWithDio({
    required String postId,
    required String postType,
    required String title,
    required String content,
    required String species,
    required String breeds,
    required String gender,
    required String birth,
    required String weight,
    required String? imageUrl,
  }) async {
    final response = await _dio.patch(
      "$_baseUrl/posts?id=eq.$postId",
      options: Options(headers: {'Prefer': 'return=representation'}),
      data: {
        "post_type": postType,
        "title": title,
        "content": content,
        "species": species,
        "breeds": breeds,
        "gender": gender,
        "birth": birth,
        "weight": weight,
        "image_url": imageUrl,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("게시글 추가 실패: ${response.statusMessage}");
    }
  }

  // 게시글 삭제 - API 호출 및 응답
  Future<void> deletedPostsWithDio(String postId) async {
    await _dio.delete("$_baseUrl/posts?id=eq.$postId");
  }
}
