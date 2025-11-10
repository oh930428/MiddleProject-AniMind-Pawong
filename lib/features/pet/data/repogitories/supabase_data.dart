import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/medical_records.dart';
import '../../domain/entities/pet.dart';

class PetSupabaseDataSource {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Pet>> getPets() async {
    final userId = _client.auth.currentSession?.user.id;
    if (userId == null) {
      return [];
    }

    final response = await _client
        .from('pets')
        .select('*, breeds(*, species(*))')
        .eq('user_id', userId);

    if (response.isEmpty) {
      return [];
    }

    return response.map((e) => Pet.fromJson(e)).toList();
  }

  Future<String> _uploadImage(File imageFile, String petId) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final path = 'pet_images/$petId/$fileName';
    await _client.storage.from('pets').upload(path, imageFile);
    return _client.storage.from('pets').getPublicUrl(path);
  }

  Future<void> addPet(Pet pet, File? imageFile) async {
    final userId = _client.auth.currentSession?.user.id;
    if (userId == null) {
      throw Exception('User not authenticated. Cannot add pet.');
    }

    final petData = pet.toJson();
    petData['user_id'] = userId;

    final insertedData = await _client
        .from('pets')
        .insert(petData)
        .select('id')
        .single();
    final newPetId = insertedData['id'];

    if (imageFile != null) {
      final imageUrl = await _uploadImage(imageFile, newPetId);
      await _client
          .from('pets')
          .update({'pet_image_url': imageUrl})
          .eq('id', newPetId);
    }
  }

  Future<void> updatePet(Pet pet, File? imageFile) async {
    final userId = _client.auth.currentSession?.user.id;
    if (userId == null) {
      throw Exception('User not authenticated. Cannot update pet.');
    }

    final petData = pet.toJson();
    if (imageFile != null) {
      final imageUrl = await _uploadImage(imageFile, pet.id);
      petData['pet_image_url'] = imageUrl;
    }
    await _client
        .from('pets')
        .update(petData)
        .eq('id', pet.id)
        .eq('user_id', userId);
  }

  Future<void> deletePet(String petId) async {
    final userId = _client.auth.currentSession?.user.id;
    if (userId == null) {
      throw Exception('User not authenticated. Cannot delete pet.');
    }
    await _client.from('pets').delete().eq('id', petId).eq('user_id', userId);
  }

  Future<List<MedicalRecords>> getMedicalRecords(String petId) async {
    try {
      final response = await _client
          .from('medical_records')
          .select('*')
          .eq('pet_id', petId);

      print('Supabase medical_records response: $response');

      if (response.isEmpty) {
        print('No medical records found for petId: $petId');
        return [];
      }

      return response.map((e) => MedicalRecords.fromJson(e)).toList();
    } catch (e) {
      print('Error in getMedicalRecords: $e');
      return [];
    }
  }

  Future<void> addMedicalRecords(String petId, MedicalRecords record) async {
    final recordData = record.toJson();
    recordData['pet_id'] = petId;
    await _client.from('medical_records').insert(recordData);
  }

  Future<void> updateMedicalRecords(String petId, MedicalRecords record) async {
    await _client
        .from('medical_records')
        .update(record.toJson())
        .eq('id', record.id);
  }

  Future<void> deleteMedicalRecords(String petId, String recordId) async {
    await _client.from('medical_records').delete().eq('id', recordId);
  }

  Future<Map<String, dynamic>> getBreed(int? breedId) async {
    if (breedId == null) {
      return {};
    }
    try {
      final response = await _client
          .from('breeds')
          .select('name, species_id')
          .eq('id', breedId)
          .single();
      return response;
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> getSpecies(int? speciesId) async {
    if (speciesId == null) {
      return {};
    }
    try {
      final response = await _client
          .from('species')
          .select('name')
          .eq('id', speciesId)
          .single();
      return response;
    } catch (e) {
      return {};
    }
  }
}
