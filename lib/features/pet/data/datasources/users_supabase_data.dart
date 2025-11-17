import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserSupabaseData {
  late final Dio _dio;
  final String _baseUrl = "${dotenv.env["SUPABASE_BASE_URL"]}/rest/v1";

  UserSupabaseData() {
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

  Future<String?> fetchEmail({required String userId}) async {
    final response = await _dio.get(
      "$_baseUrl/users",
      queryParameters: {"id": "eq.$userId", "select": "email"},
    );

    if (response.statusCode == 200 &&
        response.data is List &&
        (response.data as List).isNotEmpty) {
      return (response.data as List).first['email'] as String?;
    }
    return null;
  }
}
