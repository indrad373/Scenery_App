class UserModel {
  final String id;
  final String email;
  final String name;
  final String? image;
  final String level;
  final String status;
  final String createdDate;

  UserModel(
      {required this.id,
      required this.email,
      required this.name,
      required this.image,
      required this.level,
      required this.status,
      required this.createdDate});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        email: json['email'],
        name: json['name'],
        image: json['image'],
        level: json['level'],
        status: json['status'],
        createdDate: json['createdDate']);
  }
}
