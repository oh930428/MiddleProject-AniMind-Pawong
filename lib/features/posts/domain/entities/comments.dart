class Comments {
  final int id;
  final int postId;
  final String userId;
  final String userName;
  final String content;
  final DateTime createdAt;

  Comments({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.userName,
    required this.createdAt,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      id: json['id'],
      postId: json['post_id'],
      userId: json['user_id'],
      userName: json['users']?['name'] ?? '알 수 없음',
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'post_id': postId, 'user_id': userId, 'content': content};
  }
}
