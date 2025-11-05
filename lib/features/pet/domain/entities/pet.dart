// lib/models/pet.dart
class Pet {
  final String id;
  final String name;
  final String species; // 예: 강아지, 고양이
  final String breed; // 품종: 말티즈
  final double weight; // 몸무게: 4.5kg
  final int ageYears; // 나이: 3살
  final String birthDate; // 생일: 2021.05.15
  final String imageUrl; // 프로필 이미지 URL (더미)

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.weight,
    required this.ageYears,
    required this.birthDate,
    required this.imageUrl,
  });

  // 편의를 위한 맵핑 정보 추출 (정보 그리드용)
  Map<String, String> get infoGridData => {
    '품종': breed,
    '나이': '$ageYears살',
    '몸무게': '$weight kg',
    '생일': birthDate,
  };
}

class HospitalRecord {
  final String title;
  final String date;
  final String? nextVisitDate;

  HospitalRecord({
    required this.title,
    required this.date,
    this.nextVisitDate,
  });
}