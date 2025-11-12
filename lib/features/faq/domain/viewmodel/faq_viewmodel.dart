import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../entities/faq.dart';

class FaqViewModel {
  static const int initialLoadCount = 15;
  static const int additionalLoadCount = 10;
  static const int scrollLoadThreshold = 200; //px

  final Dio _dio;
  final String _baseUrl;
  final String _apiKey;

  FaqViewModel()
    : _baseUrl = dotenv.env['SUPABASE_BASE_URL'] ?? '',
      _apiKey = dotenv.env['SUPABASE_API_KEY'] ?? '',
      _dio = Dio() {
    _dio.options.headers = {
      'apikey': _apiKey,
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
    };
  }

  Future<List<FAQ>> fetchInitialFAQs({
    String? category,
    String? searchQuery,
  }) async {
    return _fetchFAQs(
      limit: initialLoadCount,
      offset: 0,
      category: category,
      searchQuery: searchQuery,
    );
  }

  Future<List<FAQ>> fetchAdditionalFAQs({
    required int offset,
    String? category,
    String? searchQuery,
  }) async {
    return _fetchFAQs(
      limit: additionalLoadCount,
      offset: offset,
      category: category,
      searchQuery: searchQuery,
    );
  }

  Future<List<FAQ>> _fetchFAQs({
    required int limit,
    required int offset,
    String? category,
    String? searchQuery,
  }) async {
    try {
      String url =
          '$_baseUrl/rest/v1/common_faq?order=id.asc&limit=$limit&offset=$offset';

      if (category != null && category != '전체') {
        url += '&category=eq.$category';
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        url +=
            '&or=(question.ilike.*$searchQuery*,answer.ilike.*$searchQuery*)';
      }

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => FAQ.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load FAQs: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
