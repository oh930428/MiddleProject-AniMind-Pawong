class HomePost {
  final int id;
  final String postType;
  final String title;
  final String content;
  final String? species;
  final String? breeds;
  final String gender;
  final String birth;
  final String weight;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String? userName;

  HomePost({
    required this.id,
    required this.postType,
    required this.title,
    required this.content,
    this.species,
    this.breeds,
    required this.gender,
    required this.birth,
    required this.weight,
    this.imageUrl,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.userName,
  });

  factory HomePost.fromJson(Map<String, dynamic> json) {
    final breedsData = json['breeds'];
    final speciesData = breedsData?['species'];

    return HomePost(
      id: json['id'],
      postType: json['post_type'],
      title: json['title'],
      content: json['content'],
      species: speciesData?['species_name'] as String?,
      breeds: breedsData?['breeds_name'] as String?,
      gender: json['gender'],
      birth: json['birth'],
      weight: json['weight'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      userName: json['users']?['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_type': postType,
      'title': title,
      'content': content,
      'species': species,
      'breeds': breeds,
      'gender': gender,
      'birth': birth,
      'weight': weight,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'user_name': userName,
    };
  }
}
