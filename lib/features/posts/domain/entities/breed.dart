class Breed {
  final int id;
  final String name;
  final int speciesId;

  Breed({required this.id, required this.name, required this.speciesId});

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      id: json['id'],
      name: json['breeds_name'],
      speciesId: json['species_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'breeds_name': name, 'species_id': speciesId};
  }
}
