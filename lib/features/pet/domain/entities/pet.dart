// 반려동물 프로필을 위한 메인 모델
import 'hospital_records.dart';

class Pet {
  // DB 스키마 (image_0cecb8.png) 반영 필드
  final String id; // (DB: id) 고유 식별자
  final String name; // (DB: pet_name)
  final String? breedId; // (DB: breeds_id) 품종 ID (int8 -> String)
  final String? birthDate; // (DB: pet_birth)
  final String imageUrl; // (DB: pet_image_url)
  final double? weight; // (DB: pet_weight)
  final String gender; // (DB: pet_gender)
  final bool isNeutered; // (DB: neutered) 중성화 여부

  final String type; // UI 드롭다운을 위해 추가 (예: '강아지', '고양이')
  final String breed; // 실제 품종 이름 (UI 표시용)
  final List<String> tags; // 태그 리스트
  final Map<String, String> infoGridData; // 정보 그리드 (UI 표시용)
  final List<HospitalRecord> records; // 병원 기록

  // DB 스키마의 created_at, update_at, user_id는 모델에서는 제외 (Repository/Service에서 관리)

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    this.breedId,
    required this.imageUrl,
    required this.tags,
    required this.infoGridData,
    required this.records,
    this.birthDate,
    this.weight,
    required this.gender,
    required this.isNeutered,
  });

  Pet copyWith({
    String? id,
    String? name,
    String? type,
    String? breed,
    String? breedId,
    String? imageUrl,
    List<String>? tags,
    Map<String, String>? infoGridData,
    List<HospitalRecord>? records,
    DateTime? birthDate,
    double? weight,
    String? gender,
    bool? isNeutered,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      breed: breed ?? this.breed,
      breedId: breedId ?? this.breedId,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      infoGridData: infoGridData ?? this.infoGridData,
      records: records ?? this.records,
      birthDate: this.birthDate,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      isNeutered: isNeutered ?? this.isNeutered,
    );
  }
}
