import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

import '../../domain/entities/medical_records.dart';
import '../../domain/entities/pet.dart';

class PetSupabaseDataSource {
  late final Dio _dio;
  final String _baseUrl = "${dotenv.env["SUPABASE_BASE_URL"]}/rest/v1";
  final SupabaseClient _client = Supabase.instance.client;

  PetSupabaseDataSource() {
    final String apiKey = dotenv.env["SUPABASE_API_KEY"] ?? "";
    final String authorization = dotenv.env["SUPABASE_API_KEY"] ?? "";

    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        headers: {
          "apikey": apiKey,
          "Authorization": "Bearer $authorization",
          "Content-Type": "application/json",
        },
      ),
    );
  }

  dynamic _handleResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data;
    } else {
      throw Exception(
        'REST API Error: ${response.statusCode} - ${response.data}',
      );
    }
  }

  // --- 펫(Pet) 관련 기능 ---

  Future<List<Pet>> getPets() async {
    final userId = _client.auth.currentSession?.user.id;
    if (userId == null) return [];

    try {
      final response = await _dio.get(
        '/pets',
        queryParameters: {
          'user_id': 'eq.$userId',
          'select': '*,breeds!inner(*,species!inner(*))',
        },
      );
      final data = _handleResponse(response);
      if (data is List) {
        return data.map((e) => Pet.fromJson(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('Dio error in getPets: ${e.message}');
      return [];
    }
  }

  Future<String> _uploadImage(File imageFile, String petId) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final path = 'pet_images/$petId/$fileName';

    final storageUrl =
        '${dotenv.env["SUPABASE_BASE_URL"]}/storage/v1/object/pet_image/$path';

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path, filename: fileName),
    });

    try {
      final response = await _dio.post(
        storageUrl,
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );
      _handleResponse(response);

      return '${dotenv.env["SUPABASE_BASE_URL"]}/storage/v1/object/public/pet_image/$path';
    } on DioException catch (e) {
      print('Dio upload error: ${e.message}');
      throw Exception('Image upload failed: ${e.response?.data}');
    }
  }

  Future<Pet> addPet(Pet pet, File? imageFile) async {
    final userId = _client.auth.currentSession?.user.id;
    if (userId == null)
      throw Exception('User not authenticated. Cannot add pet.');

    final petData = pet.toJson();
    petData['user_id'] = userId;

    try {
      // 1. Pet 데이터 삽입
      final insertResponse = await _dio.post(
        '/pets',
        data: petData,
        queryParameters: {
          'select': '*,breeds!inner(*,species!inner(*))',
          'limit': 1,
        },
        options: Options(headers: {'Prefer': 'return=representation'}),
      );
      final insertedDataList = _handleResponse(insertResponse);
      if (insertedDataList.isEmpty) {
        throw Exception('Failed to insert pet.');
      }

      var insertedData = insertedDataList.first;
      final petId = insertedData['id'].toString();

      // 2. 이미지 업로드 및 URL 업데이트
      if (imageFile != null) {
        final imageUrl = await _uploadImage(imageFile, petId);
        final updateResponse = await _dio.patch(
          '/pets',
          data: {'pet_image_url': imageUrl},
          queryParameters: {
            'id': 'eq.$petId',
            'select': '*,breeds!inner(*,species!inner(*))',
            'limit': 1,
          },
        );
        final updatedDataList = _handleResponse(updateResponse);
        if (updatedDataList.isNotEmpty) {
          insertedData = updatedDataList.first;
        }
      }
      return Pet.fromJson(insertedData);
    } on DioException catch (e) {
      print('Dio error in addPet: ${e.message}');
      throw Exception('Failed to add pet: ${e.response?.data}');
    }
  }

  Future<Pet> updatePet(Pet pet, File? imageFile) async {
    final userId = _client.auth.currentSession?.user.id;
    if (userId == null)
      throw Exception('User not authenticated. Cannot update pet.');
    if (pet.id == null) throw Exception('Pet ID is required for update.');

    final petData = pet.toJson();

    if (imageFile != null) {
      final imageUrl = await _uploadImage(imageFile, pet.id!);
      petData['pet_image_url'] = imageUrl;
    }

    try {
      final response = await _dio.patch(
        '/pets',
        data: petData,
        queryParameters: {
          'id': 'eq.${pet.id!}',
          'select': '*,breeds!inner(*,species!inner(*))',
          'limit': 1,
        },
        options: Options(headers: {'Prefer': 'return=representation'}),
      );
      final dataList = _handleResponse(response);
      if (dataList.isNotEmpty) {
        return Pet.fromJson(dataList.first);
      }
      throw Exception('Pet not found or update failed.');
    } on DioException catch (e) {
      print('Dio error in updatePet: ${e.message}');
      throw Exception('Failed to update pet: ${e.response?.data}');
    }
  }

  Future<void> deletePet(String petId) async {
    final userId = _client.auth.currentSession?.user.id;
    if (userId == null)
      throw Exception('User not authenticated. Cannot delete pet.');

    try {
      await _dio.delete(
        '/pets',
        queryParameters: {'id': 'eq.$petId', 'user_id': 'eq.$userId'},
      );
    } on DioException catch (e) {
      print('Dio error in deletePet: ${e.message}');
      throw Exception('Failed to delete pet: ${e.response?.data}');
    }
  }

  // --- 진료 기록 (Medical Records) 관련 기능 ---

  Future<List<MedicalRecords>> getMedicalRecords(String petId) async {
    try {
      final response = await _dio.get(
        '/medical_records',
        queryParameters: {'pet_id': 'eq.$petId', 'select': '*'},
      );
      final data = _handleResponse(response);
      if (data is List) {
        return data.map((e) => MedicalRecords.fromJson(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('Dio error in getMedicalRecords: ${e.message}');
      return [];
    }
  }

  Future<void> addMedicalRecords(String petId, MedicalRecords record) async {
    final userId = _client.auth.currentSession?.user.id;
    if (userId == null)
      throw Exception('User not authenticated. Cannot add medical record.');

    final recordData = record.toJson();
    recordData['pet_id'] = petId;
    recordData['user_id'] = userId;

    try {
      await _dio.post('/medical_records', data: recordData);
    } on DioException catch (e) {
      print('Dio error in addMedicalRecords: ${e.message}');
      throw Exception('Failed to add medical record: ${e.response?.data}');
    }
  }

  Future<void> updateMedicalRecords(String petId, MedicalRecords record) async {
    final userId = _client.auth.currentSession?.user.id;
    if (userId == null)
      throw Exception('User not authenticated. Cannot update medical record.');
    if (record.id == null)
      throw Exception('Record ID cannot be null for an update.');

    try {
      await _dio.patch(
        '/medical_records',
        data: record.toJson(),
        queryParameters: {'id': 'eq.${record.id!}', 'user_id': 'eq.$userId'},
      );
    } on DioException catch (e) {
      print('Dio error in updateMedicalRecords: ${e.message}');
      throw Exception('Failed to update medical record: ${e.response?.data}');
    }
  }

  Future<void> deleteMedicalRecords(String petId, String recordId) async {
    try {
      await _dio.delete(
        '/medical_records',
        queryParameters: {'id': 'eq.$recordId'},
      );
    } on DioException catch (e) {
      print('Dio error in deleteMedicalRecords: ${e.message}');
      throw Exception('Failed to delete medical record: ${e.response?.data}');
    }
  }

  // --- 품종/종 (Breed/Species) 조회 기능 ---

  Future<Map<String, dynamic>> getBreed(int? breedId) async {
    if (breedId == null) return {};
    try {
      final response = await _dio.get(
        '/breeds',
        queryParameters: {'id': 'eq.$breedId', 'select': 'name,species_id'},
      );
      final data = _handleResponse(response);
      return data is List && data.isNotEmpty ? data.first : {};
    } on DioException catch (e) {
      print('Dio error in getBreed: ${e.message}');
      return {};
    }
  }

  Future<Map<String, dynamic>> getSpecies(int? speciesId) async {
    if (speciesId == null) return {};
    try {
      final response = await _dio.get(
        '/species',
        queryParameters: {'id': 'eq.$speciesId', 'select': 'name'},
      );
      final data = _handleResponse(response);
      return data is List && data.isNotEmpty ? data.first : {};
    } on DioException catch (e) {
      print('Dio error in getSpecies: ${e.message}');
      return {};
    }
  }
}
