class NotificationItem {
  final int id;
  final String toUserId;
  final String toUserName;
  final String fromUserId;
  final String fromUserName;
  final int postId;
  final int commentId;
  final bool isRead;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.toUserId,
    required this.toUserName,
    required this.fromUserId,
    required this.fromUserName,
    required this.postId,
    required this.commentId,
    required this.isRead,
    required this.createdAt,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      toUserId: toUserId,
      toUserName: toUserName,
      fromUserId: fromUserId,
      fromUserName: fromUserName,
      postId: postId,
      commentId: commentId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      toUserId: json['to_user_id'],
      toUserName: json['to_user']?['name'] ?? '',
      fromUserId: json['from_user_id'],
      fromUserName: json['from_user']?['name'] ?? '',
      postId: json['post_id'],
      commentId: json['comment_id'],
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
