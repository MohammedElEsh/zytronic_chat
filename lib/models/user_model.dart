class UserModel {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isOnline;
  final String? status;
  final String? phoneNumber;

  UserModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.isOnline = false,
    this.status,
    this.phoneNumber,
  });
}