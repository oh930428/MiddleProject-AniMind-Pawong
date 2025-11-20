class AppUser {
  final String id;
  final String email;
  final String name;
  final String phone;
  final bool isPrivacyAgreed;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.isPrivacyAgreed,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      isPrivacyAgreed: json["is_privacy_agreed"] ?? "",
    );
  }
}
