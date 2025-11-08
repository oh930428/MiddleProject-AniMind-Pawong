// 병원 기록 정보를 담는 클래스
class MedicalRecords {
  final String id;
  final DateTime? visitedat;
  final String visitReason;
  final DateTime? nextVisitat;
  final String memo;

  MedicalRecords({
    required this.id,
    required this.visitedat,
    required this.visitReason,
    this.nextVisitat,
    required this.memo,
  });

  factory MedicalRecords.fromJson(Map<String, dynamic> json) {
    print('Parsing HospitalRecord from JSON: $json');
    return MedicalRecords(
      id: json['id']?.toString() ?? '',
      visitedat: json['visited_at'] != null
          ? DateTime.tryParse(json['visited_at'].toString())
          : null,
      visitReason: json['visit_reason']?.toString() ?? 'N/A',
      nextVisitat: json['next_visit_at'] != null
          ? DateTime.tryParse(json['next_visit_at'].toString())
          : null,
      memo: json['memo']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'visited_at': visitedat?.toIso8601String(),
      'visit_reason': visitReason,
      'next_visit_at': nextVisitat?.toIso8601String(),
      'memo': memo,
    };
  }
}
