import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../home/domain/entities/home_posts.dart';
import '../../domain/entities/breed.dart'; // Import Breed entity
import '../../domain/entities/post_filter_species.dart';

class PostsSupabaseDataSource {
  late final Dio _dio;
  final String _baseUrl = "${dotenv.env["SUPABASE_BASE_URL"]}/rest/v1";

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

  // 품종 - API 호출 및 응답 (by species_id)
  Future<List<Breed>> getBreedsBySpeciesIdWithDio(int speciesId) async {
    final response = await _dio.get(
      "$_baseUrl/breeds",
      queryParameters: {
        "select": "*",
        "species_id": "eq.$speciesId",
        "order": "id.desc",
      },
    );

    return (response.data as List).map((json) => Breed.fromJson(json)).toList();
  }

  // 전체 게시글 - API 호출 및 응답
  Future<List<HomePost>> getAllPostsWithDio() async {
    final response = await _dio.get(
      "$_baseUrl/posts",
      queryParameters: {
        "select": "*, users(name), breeds(breeds_name, species(species_name))",
        "order": "id.desc",
      },
    );

    return (response.data as List)
        .map((json) => HomePost.fromJson(json))
        .toList();
  }

  // 특정 게시글 - API 호출 및 응답
  Future<HomePost> getByIdPostWithDio(int postId) async {
    final response = await _dio.get(
      '$_baseUrl/posts',
      queryParameters: {"select": "*, users(name)", "id": "eq.$postId"},
    );

    return (response.data as List)
        .map((json) => HomePost.fromJson(json))
        .toList()
        .first;
  }

  // 게시글 이미지 업로드
  Future<String> uploadImage({
    required File pickedImage,
    required String userId,
  }) async {
    final bytes = await pickedImage.readAsBytes();
    final fileName = '${userId}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final response = await Supabase.instance.client.storage
        .from('pet_image')
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );

    if (response.error != null) {
      throw Exception('Image upload failed: ${response.error!.message}');
    }

    final String publicUrl = Supabase.instance.client.storage
        .from('pet_image')
        .getPublicUrl(fileName);

    return publicUrl;
  }

  // 게시글 - 추가 - API 호출 및 응답
  Future<void> addPostsWithDio({
    required String userId,
    required String postType,
    required String title,
    required String content,
    required String gender,
    required String birth,
    required String weight,
    required String? imageUrl,
    required int? breedsId,
  }) async {
    final postData = {
      "user_id": userId,
      "post_type": postType,
      "title": title,
      "content": content,
      "gender": gender,
      "birth": DateTime.parse(birth).toIso8601String(),
      "weight": weight.toString(),
      "image_url": imageUrl,
      "breeds_id": breedsId,
    };

    final response = await _dio.post(
      "$_baseUrl/posts",
      options: Options(headers: {'Prefer': 'return=representation'}),
      data: postData,
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
    required String gender,
    required String birth,
    required String weight,
    required String? imageUrl,
    required int? breedsId,
  }) async {
    final postData = {
      "post_type": postType,
      "title": title,
      "content": content,
      "gender": gender,
      "birth": DateTime.parse(birth).toIso8601String(),
      "weight": weight.toString(),
      "image_url": imageUrl,
      "breeds_id": breedsId,
    };

    final response = await _dio.patch(
      "$_baseUrl/posts?id=eq.$postId",
      options: Options(headers: {'Prefer': 'return=representation'}),
      data: postData,
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

extension on String {
  get error => null;
}
