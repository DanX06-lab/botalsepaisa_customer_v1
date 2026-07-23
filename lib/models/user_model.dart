class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String referralCode;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.referralCode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      referralCode: json['referralCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'referralCode': referralCode,
    };
  }
}
