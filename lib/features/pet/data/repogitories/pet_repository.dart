import 'package:intl/intl.dart';
import 'package:middleproject_animind_pawong/features/pet/data/repogitories/supabase_data.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/entities/medical_records.dart';
import 'package:middleproject_animind_pawong/features/pet/domain/entities/pet.dart';

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

  Future<void> addPet(Pet pet) {
    return _dataSource.addPet(pet);
  }

  Future<void> updatePet(Pet pet) {
    return _dataSource.updatePet(pet);
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
