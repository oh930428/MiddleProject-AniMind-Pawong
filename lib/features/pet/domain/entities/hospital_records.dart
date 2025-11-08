class HospitalRecord {
  // DB: id (Primary Key)
  final String id;

  // DB: title (제목)
  final String title;

  // DB: visited_at (방문일, timestampz)
  final String visitedAt;

  // DB: visitReason (방문 이유: 진료 사유/제목)
  final String visitReason;

  // DB: hospital_name
  final String hospitalName;

  // DB: next_visit_at (다음 방문 예정일, timestampz, nullable)
  final String? nextVisitAt;

  // DB: memo (메모, text, nullable)
  final String? memo;

  HospitalRecord({
    required this.id,
    required this.title,
    required this.visitReason,
    required this.visitedAt,
    required this.hospitalName,
    this.nextVisitAt,
    this.memo,
  });

  HospitalRecord copyWith({
    String? id,
    String? title,
    String? visitReason,
    String? visitedAt,
    String? hospitalName,
    String? nextVisitAt,
    String? memo,
  }) {
    return HospitalRecord(
      id: this.id,
      title: this.title,
      visitReason: this.visitReason,
      visitedAt: this.visitedAt,
      hospitalName: this.hospitalName,
      nextVisitAt: this.nextVisitAt,
      memo: this.memo,
    );
  }
}
