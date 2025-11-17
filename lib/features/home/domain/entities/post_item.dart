class PostItem {
  final String id;
  final String user_id;
  final String post_type;
  final String title;
  final String content;
  final String species;
  final String breeds;
  final String gender;
  final String birth;
  final String weight;
  final String image_url;
  final String created_at;
  final String? updated_at;
  final String? deteled_at;

  PostItem({
    required this.id,
    required this.user_id,
    required this.post_type,
    required this.title,
    required this.content,
    required this.species,
    required this.breeds,
    required this.gender,
    required this.birth,
    required this.weight,
    required this.image_url,
    required this.created_at,
    this.updated_at,
    this.deteled_at,
  });
}
