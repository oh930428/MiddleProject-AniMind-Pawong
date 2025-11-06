// --- 데이터 모델 ---

// 반려동물 정보를 담는 클래스
class Pet {
  final String id;
  final String name;
  final String imageUrl;
  final String age;
  final String species;
  final String breed;
  final double weight;
  final String birthday;
  final String gender;

  Pet({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.age,
    required this.species,
    required this.breed,
    required this.weight,
    required this.birthday,
    required this.gender,
  });

  // 반려동물 정보를 그리드 형태로 표시하기 위한 데이터
  List<Map<String, String>> get infoGridData => [
    {'label': '나이', 'value': age},
    {'label': '성별', 'value': gender},
    {'label': '생일', 'value': birthday},
    {'label': '체중', 'value': '$weight kg'},
  ];
}

// 병원 기록 정보를 담는 클래스
class HospitalRecord {
  final String id;
  final String visitDate;
  final String visitReason;
  final String? nextVisitDate;
  final String memo;

  HospitalRecord({
    required this.id,
    required this.visitDate,
    required this.visitReason,
    this.nextVisitDate,
    required this.memo,
  });
}

// --- 더미 데이터 및 데이터 관리 ---

// 반려동물 및 병원 기록 데이터를 관리하는 클래스 (싱글톤)
class PetRepository {
  static final PetRepository _instance = PetRepository._internal();

  factory PetRepository() {
    return _instance;
  }

  PetRepository._internal();

  // 더미 반려동물 데이터
  final List<Pet> _pets = [
    Pet(
      id: '1',
      name: '레오',
      imageUrl:
          'https://images.unsplash.com/photo-1543466835-00a7907e9de1?q=80&w=2874&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      age: '3살',
      species: '강아지',
      breed: '골든 리트리버',
      weight: 28.5,
      birthday: '2021-08-15',
      gender: '수컷',
    ),
    Pet(
      id: '2',
      name: '루나',
      imageUrl:
          'https://images.unsplash.com/photo-1574144611937-0df059b5ef3e?q=80&w=2869&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      age: '2살',
      species: '고양이',
      breed: '코리안 숏헤어',
      weight: 4.8,
      birthday: '2022-05-20',
      gender: '암컷',
    ),
    Pet(
      id: '3',
      name: '코코',
      imageUrl:
          'https://images.unsplash.com/photo-1552053831-71594a27632d?q=80&w=2862&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      age: '5살',
      species: '강아지',
      breed: '푸들',
      weight: 6.2,
      birthday: '2019-11-11',
      gender: '수컷',
    ),
  ];

  // 더미 병원 기록 데이터
  final Map<String, List<HospitalRecord>> _records = {
    '1': [
      HospitalRecord(
        id: 'rec1',
        visitDate: '2024-10-28',
        visitReason: '정기 검진',
        memo: '건강 양호, 체중 관리 필요',
        nextVisitDate: '2025-04-28',
      ),
      HospitalRecord(
        id: 'rec2',
        visitDate: '2024-08-15',
        visitReason: '예방 접종',
        memo: '종합 백신 4차 완료',
      ),
    ],
    '2': [
      HospitalRecord(
        id: 'rec3',
        visitDate: '2024-09-20',
        visitReason: '피부병 검사',
        memo: '알레르기성 피부염 진단',
      ),
    ],
    '3': [],
  };

  // 모든 반려동물 목록을 반환
  List<Pet> getAllPets() => _pets;

  // 특정 반려동물의 병원 기록 목록을 반환
  List<HospitalRecord> getHospitalRecords(String petId) =>
      _records[petId] ?? [];

  // 새로운 반려동물을 추가
  void addPet(Pet pet) {
    _pets.add(pet);
  }

  // 반려동물 정보를 수정
  void updatePet(Pet pet) {
    final index = _pets.indexWhere((p) => p.id == pet.id);
    if (index != -1) {
      _pets[index] = pet;
    }
  }

  // 반려동물 정보를 삭제
  void deletePet(String petId) {
    _pets.removeWhere((p) => p.id == petId);
  }

  // 새로운 병원 기록을 추가
  void addHospitalRecord(String petId, HospitalRecord record) {
    if (_records.containsKey(petId)) {
      _records[petId]!.add(record);
    } else {
      _records[petId] = [record];
    }
  }

  // 병원 기록을 수정
  void updateHospitalRecord(String petId, HospitalRecord record) {
    if (_records.containsKey(petId)) {
      final index = _records[petId]!.indexWhere((r) => r.id == record.id);
      if (index != -1) {
        _records[petId]![index] = record;
      }
    }
  }

  // 병원 기록을 삭제
  void deleteHospitalRecord(String petId, String recordId) {
    if (_records.containsKey(petId)) {
      _records[petId]!.removeWhere((r) => r.id == recordId);
    }
  }
}
