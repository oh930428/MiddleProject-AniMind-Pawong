class HomeMedicalRecords {
  final int id;
  final String visitReason;
  final DateTime visitedAt;
  final DateTime? nextVisitAt;
  final String? hospitalName;
  final String petName;

  HomeMedicalRecords({
    required this.id,
    required this.visitReason,
    required this.visitedAt,
    this.nextVisitAt,
    this.hospitalName,
    required this.petName,
  });

  factory HomeMedicalRecords.fromJson(Map<String, dynamic> json) {
    return HomeMedicalRecords(
      id: json['id'],
      visitReason: json['visit_reason'],
      visitedAt: DateTime.parse(json['visited_at']),
      nextVisitAt: json["next_visit_at"] != null
          ? DateTime.parse(json['next_visit_at'])
          : null,
      hospitalName: json['hospital_name'] ?? "",
      petName: json['pets']?['pet_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visit_reason': visitReason,
      'visited_at': visitedAt,
      'next_visit_at': nextVisitAt,
      'hospital_name': hospitalName,
      'pets': {'pet_name': petName},
    };
  }
}
