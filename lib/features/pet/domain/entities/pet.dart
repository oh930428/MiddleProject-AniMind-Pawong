// lib/models/pet.dart

// 반려동물 프로필을 위한 메인 모델
import 'package:middleproject_animind_pawong/features/pet/domain/entities/medical_records.dart';

class Pet {
  final String id; // (DB: id) 고유 식별자
  final String name; // (DB: pet_name)
  final int? breedId; // (DB: breeds_id) 품종 ID (int8 -> String)
  final DateTime? birthDate;
  final String age;
  final String species_name;
  final String imageUrl; // (DB: pet_image_url)
  final double? weight; // (DB: pet_weight)
  final String gender; // (DB: pet_gender)
  final bool isNeutered; // (DB: neutered) 중성화 여부
  // UI 드롭다운을 위해 추가 (예: '강아지', '고양이')
  final String breeds_name; // 실제 품종 이름 (UI 표시용)
  final List<String> tags; // 태그 리스트
  final List<Map<String, String>> infoGridData; // 정보 그리드 (UI 표시용)
  final List<MedicalRecords> records; // 병원 기록

  Pet({
    required this.id,
    required this.name,
    required this.species_name,
    required this.breeds_name,
    this.breedId,
    required this.imageUrl,
    required this.tags,
    required this.infoGridData,
    required this.records,
    this.birthDate,
    this.weight,
    required this.gender,
    required this.isNeutered,
    required this.age,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    final breedData = json['breeds'] as Map<String, dynamic>?;
    final speciesData = breedData?['species'] as Map<String, dynamic>?;

    return Pet(
      id: json['id']?.toString() ?? '',
      name: json['pet_name']?.toString() ?? '',
      age: json['age']?.toString() ?? '',
      species_name: speciesData?['species_name']?.toString() ?? '',
      breeds_name: breedData?['breeds_name']?.toString() ?? '',
      breedId: json['breeds_id'],
      imageUrl: json['pet_image_url']?.toString() ?? '',
      tags: [], // TODO: Implement tags
      infoGridData: [],
      records: [], // TODO: Implement records
      birthDate: json['pet_birth'] != null
          ? DateTime.parse(json['pet_birth'])
          : null,
      weight: double.tryParse(json['pet_weight']?.toString() ?? ''),
      gender: json['pet_gender']?.toString() ?? '',
      isNeutered: json['neutered'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pet_name': name,
      'breeds_id': breedId,
      'pet_birth': birthDate?.toIso8601String(),
      'pet_image_url': imageUrl,
      'pet_weight': weight,
      'pet_gender': gender,
      'neutered': isNeutered,
      'age': age,
    };
  }

  Pet copyWith({
    String? id,
    String? name,
    String? age,
    String? species_name,
    String? breeds_name,
    int? breedId,
    String? imageUrl,
    List<String>? tags,
    List<Map<String, String>>? infoGridData,
    List<MedicalRecords>? records,
    DateTime? birthDate,
    double? weight,
    String? gender,
    bool? isNeutered,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      species_name: species_name ?? this.species_name,
      age: age ?? this.age,
      breeds_name: breeds_name ?? this.breeds_name,
      breedId: breedId ?? this.breedId,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      infoGridData: infoGridData ?? this.infoGridData,
      records: records ?? this.records,
      birthDate: birthDate ?? this.birthDate,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      isNeutered: isNeutered ?? this.isNeutered,
    );
  }
}
