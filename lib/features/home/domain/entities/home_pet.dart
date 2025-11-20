class HomePet {
  final int id;
  final String petName;
  final int? breedsId;
  final String birthDate;
  final String? imageUrl;
  final String weight;
  final String petGender;
  final bool isNeutered;
  final int? age;
  final String breedsName;
  final String speciesName;

  HomePet({
    required this.id,
    required this.petName,
    this.breedsId,
    required this.birthDate,
    required this.imageUrl,
    required this.weight,
    required this.petGender,
    required this.isNeutered,
    this.age,
    required this.breedsName,
    required this.speciesName,
  });

  factory HomePet.fromJson(Map<String, dynamic> json) {
    final breedData = json['breeds'] as Map<String, dynamic>?;
    final speciesData = breedData?['species'] as Map<String, dynamic>?;

    return HomePet(
      id: json['id'] ?? 0,
      petName: json['pet_name']?.toString() ?? '',
      breedsId: json['breeds_id'] != null
          ? int.tryParse(json['breeds_id'].toString())
          : null,
      birthDate: json['pet_birth']?.toString() ?? '',
      imageUrl: json['pet_image_url']?.toString() ?? '',
      weight: json['pet_weight']?.toString() ?? '',
      petGender: json['pet_gender']?.toString() ?? '',
      isNeutered: json['neutered'] ?? false,
      age: json['age'] != null ? int.tryParse(json['age'].toString()) : null,
      breedsName: breedData?['breeds_name']?.toString() ?? '',
      speciesName: speciesData?['species_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pet_name': petName,
      'breeds_id': breedsId,
      'pet_birth': birthDate,
      'pet_image_url': imageUrl,
      'pet_weight': weight,
      'pet_gender': petGender,
      'neutered': isNeutered,
      'age': age,
      'breeds': {
        'breeds_name': breedsName,
        'species': {'species_name': speciesName},
      },
    };
  }
}
