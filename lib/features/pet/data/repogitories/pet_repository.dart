import 'dart:io';

import 'package:intl/intl.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/entities/medical_records.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/entities/pet.dart';

import '../datasources/pet_supabase_data.dart';

class PetRepository {
  final PetSupabaseDataSource _dataSource = PetSupabaseDataSource();

  Future<List<Pet>> getAllPets() async {
    final pets = await _dataSource.getPets();
    final petsWithInfo = <Pet>[];

    for (final pet in pets) {
      petsWithInfo.add(
        pet.copyWith(
          infoGridData: [
            {'label': '종', 'value': pet.species_name},
            {'label': '품종', 'value': pet.breeds_name},
            {'label': '나이', 'value': '${pet.age} 살'},
            {'label': '성별', 'value': pet.gender},
            {
              'label': '생일',
              'value': pet.birthDate != null
                  ? DateFormat('yyyy-MM-dd').format(pet.birthDate!)
                  : '미상',
            },
            {'label': '체중', 'value': '${pet.weight ?? '미상'} kg'},
          ],
        ),
      );
    }

    return petsWithInfo;
  }

  Future<Pet> addPet(Pet pet, File? imageFile) async {
    final newPet = await _dataSource.addPet(pet, imageFile);
    return newPet.copyWith(
      infoGridData: [
        {'label': '종', 'value': newPet.species_name},
        {'label': '품종', 'value': newPet.breeds_name},
        {'label': '나이', 'value': '${newPet.age} 살'},
        {'label': '성별', 'value': newPet.gender},
        {
          'label': '생일',
          'value': newPet.birthDate != null
              ? DateFormat('yyyy-MM-dd').format(newPet.birthDate!)
              : '미상',
        },
        {'label': '체중', 'value': '${newPet.weight ?? '미상'} kg'},
      ],
    );
  }

  Future<Pet> updatePet(Pet pet, File? imageFile) async {
    final updatedPet = await _dataSource.updatePet(pet, imageFile);
    return updatedPet.copyWith(
      infoGridData: [
        {'label': '종', 'value': updatedPet.species_name},
        {'label': '품종', 'value': updatedPet.breeds_name},
        {'label': '나이', 'value': '${updatedPet.age} 살'},
        {'label': '성별', 'value': updatedPet.gender},
        {
          'label': '생일',
          'value': updatedPet.birthDate != null
              ? DateFormat('yyyy-MM-dd').format(updatedPet.birthDate!)
              : '미상',
        },
        {'label': '체중', 'value': '${updatedPet.weight ?? '미상'} kg'},
      ],
    );
  }

  Future<void> deletePet(String petId) {
    return _dataSource.deletePet(petId);
  }

  Future<List<MedicalRecords>> getMedicalRecords(String petId) {
    return _dataSource.getMedicalRecords(petId);
  }

  Future<void> addMedicalRecords(String petId, MedicalRecords record) {
    return _dataSource.addMedicalRecords(petId, record);
  }

  Future<void> updateMedicalRecords(String petId, MedicalRecords record) {
    return _dataSource.updateMedicalRecords(petId, record);
  }

  Future<void> deleteMedicalRecords(String petId, String recordId) {
    return _dataSource.deleteMedicalRecords(petId, recordId);
  }
}
