class HospitalRecord {
  // DB: id (Primary Key)
  final String id;

  // DB: visit_reason (진료 사유/제목)
  final String title;

  // DB: visited_at (방문일, timestampz)
  final DateTime visitedAt;

  // DB: hospital_name
  final String hospitalName;

  // DB: next_visit_at (다음 방문 예정일, timestampz, nullable)
  final DateTime? nextVisitAt;

  // DB: memo (메모, text, nullable)
  final String? memo;

  HospitalRecord({
    required this.id,
    required this.title,
    required this.visitedAt,
    required this.hospitalName,
    this.nextVisitAt,
    this.memo,
  });

  HospitalRecord copyWith({
    String? id,
    String? title,
    DateTime? visitedAt,
    String? hospitalName,
    DateTime? nextVisitAt,
    String? memo,
  }) {
    return HospitalRecord(
      id: id ?? this.id,
      title: title ?? this.title,
      visitedAt: visitedAt ?? this.visitedAt,
      hospitalName: hospitalName ?? this.hospitalName,
      nextVisitAt: nextVisitAt ?? this.nextVisitAt,
      memo: memo ?? this.memo,
    );
  }
}
