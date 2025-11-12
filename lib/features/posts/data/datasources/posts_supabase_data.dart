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

  Future<List<PostFilterSpecies>> getSpeciesWithDio() async {
    final response = await _dio.get(
      "$_baseUrl/species",
      queryParameters: {"select": "*", "order": "id.desc"},
    );

    return (response.data as List)
        .map((json) => PostFilterSpecies.fromJson(json))
        .toList();
  }

  Future<List<HomePost>> getAllPostsWithDio() async {
    final response = await _dio.get(
      "$_baseUrl/posts",
      queryParameters: {"select": "*, users(name)", "order": "id.desc"},
    );

    return (response.data as List)
        .map((json) => HomePost.fromJson(json))
        .toList();
  }
}
