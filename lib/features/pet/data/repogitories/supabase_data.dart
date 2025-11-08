import 'package:middleproject_animind_pawong/features/pet/domain/entities/medical_records.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/entities/pet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PetSupabaseDataSource {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Pet>> getPets() async {
    final response = await _client
        .from('pets')
        .select('*, breeds(*, species(*))');

    if (response.isEmpty) {
      return [];
    }

    return response.map((e) => Pet.fromJson(e)).toList();
  }

  Future<void> addPet(Pet pet) async {
    await _client.from('pets').insert(pet.toJson());
  }

  Future<void> updatePet(Pet pet) async {
    await _client.from('pets').update(pet.toJson()).eq('id', pet.id);
  }

  Future<void> deletePet(String petId) async {
    await _client.from('pets').delete().eq('id', petId);
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
    await _client
        .from('medical_records')
        .insert(record.toJson()..['pet_id'] = petId);
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
