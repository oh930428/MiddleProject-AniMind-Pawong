import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../domain/entities/home_medical_records.dart';
import '../../domain/entities/home_pet.dart';
import '../../domain/entities/home_posts.dart';

class HomeSupabaseDataSource {
  late final Dio _dio;
  final String _baseUrl = "${dotenv.env["SUPABASE_BASE_URL"]}/rest/v1";

  HomeSupabaseDataSource() {
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

  // fetch Pets
  Future<List<HomePet>> getPetWithDio({required String userId}) async {
    final response = await _dio.get(
      "$_baseUrl/pets",
      queryParameters: {
        "user_id": "eq.$userId",
        "select": "*,breeds(id,breeds_name,species(species_name))",
        "order": "id.asc",
      },
    );

    return (response.data as List)
        .map((json) => HomePet.fromJson(json))
        .toList();
  }

  // fetch Medical Records
  Future<List<HomeMedicalRecords>> getMedicalRecordsWithDio({
    required String userId,
  }) async {
    final response = await _dio.get(
      "$_baseUrl/medical_records",
      queryParameters: {
        "user_id": "eq.$userId",
        "select":
            "id, pets(pet_name), visit_reason, visited_at, next_visit_at, hospital_name",
        "order": "id.desc",
      },
    );

    return (response.data as List)
        .map((json) => HomeMedicalRecords.fromJson(json))
        .toList();
  }

  // fetch posts
  Future<List<HomePost>> getPostsWithDio({required String userId}) async {
    final response = await _dio.get(
      "$_baseUrl/posts",
      queryParameters: {
        "user_id": "eq.$userId",
        "select": "*, users(name), breeds(breeds_name, species(species_name))",
        "order": "id.desc",
      },
    );

    return (response.data as List)
        .map((json) => HomePost.fromJson(json))
        .toList();
  }
}
