class PostItem {
  final String id;
  final String post_type;
  final String title;
  final String content;
  final String species;
  final String breeds;
  final String gender;
  final String birth;
  final String weight;
  final String image_url;
  final String? created_at;
  final String? updated_at;
  final String? deleted_at;

  PostItem({
    required this.id,
    required this.post_type,
    required this.title,
    required this.content,
    required this.species,
    required this.breeds,
    required this.gender,
    required this.birth,
    required this.weight,
    required this.image_url,
    this.created_at,
    this.updated_at,
    this.deleted_at,
  });

  /// ✅ JSON → PostItem 변환
  factory PostItem.fromJson(Map<String, dynamic> json) {
    return PostItem(
      id: json["id"]?.toString() ?? "",
      post_type: json["post_type"] ?? "",
      title: json["title"] ?? "",
      content: json["content"] ?? "",
      species: json["species"] ?? "",
      breeds: json["breeds"] ?? "",
      gender: json["gender"] ?? "",
      birth: json["birth"] ?? "",
      weight: json["weight"]?.toString() ?? "",
      image_url: json["image_url"] ?? "",
      created_at: json["created_at"] ?? "",
      updated_at: json["updated_at"],
      deleted_at: json["deleted_at"],
    );
  }

  /// ✅ PostItem → JSON 변환 (업로드용)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "post_type": post_type,
      "title": title,
      "content": content,
      "species": species,
      "breeds": breeds,
      "gender": gender,
      "birth": birth,
      "weight": weight,
      "image_url": image_url,
      "created_at": created_at,
      "updated_at": updated_at,
      "deleted_at": deleted_at,
    };
  }
}
