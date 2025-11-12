class PostFilterSpecies {
  final int id;
  final String speciesName;
  final DateTime createdAt;

  PostFilterSpecies({
    required this.id,
    required this.speciesName,
    required this.createdAt,
  });

  factory PostFilterSpecies.fromJson(Map<String, dynamic> json) {
    return PostFilterSpecies(
      id: json['id'],
      speciesName: json['species_name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'speciesName': speciesName,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
