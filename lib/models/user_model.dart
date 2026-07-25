class BankDetails {
  final String bankName;
  final String accountHolderName;
  final String accountNumber;
  final String ifscCode;

  BankDetails({
    required this.bankName,
    required this.accountHolderName,
    required this.accountNumber,
    required this.ifscCode,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) {
    return BankDetails(
      bankName: json['bank_name'] ?? '',
      accountHolderName: json['account_holder_name'] ?? '',
      accountNumber: json['account_number'] ?? '',
      ifscCode: json['ifsc_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank_name': bankName,
      'account_holder_name': accountHolderName,
      'account_number': accountNumber,
      'ifsc_code': ifscCode,
    };
  }
}

class UserModel {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String? profilePhoto;
  final String referralCode;
  final BankDetails? bankDetails;
  final String? upiId;
  final bool isPhoneVerified;
  final bool isEmailVerified;
  final bool isActive;
  final bool profileCompleted;
  final String role;
  final int totalBottlesRecycled;
  final DateTime createdAt;
  final DateTime? lastLogin;

  // Added getters to preserve existing UI compatibility
  String get name => fullName;
  String get phone => phoneNumber;

  UserModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.email,
    this.profilePhoto,
    required this.referralCode,
    this.bankDetails,
    this.upiId,
    required this.isPhoneVerified,
    required this.isEmailVerified,
    required this.isActive,
    required this.profileCompleted,
    required this.role,
    required this.totalBottlesRecycled,
    required this.createdAt,
    this.lastLogin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'] ?? 'User',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'],
      profilePhoto: json['profile_photo'],
      referralCode: json['referral_code'] ?? '',
      bankDetails: json['bank_details'] != null ? BankDetails.fromJson(json['bank_details']) : null,
      upiId: json['upi_id'],
      isPhoneVerified: json['is_phone_verified'] ?? false,
      isEmailVerified: json['is_email_verified'] ?? false,
      isActive: json['is_active'] ?? true,
      profileCompleted: json['profile_completed'] ?? false,
      role: json['role'] ?? 'CUSTOMER',
      totalBottlesRecycled: json['total_bottles_recycled'] ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      lastLogin: json['last_login'] != null ? DateTime.parse(json['last_login']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'email': email,
      'profile_photo': profilePhoto,
      'referral_code': referralCode,
      'bank_details': bankDetails?.toJson(),
      'upi_id': upiId,
      'is_phone_verified': isPhoneVerified,
      'is_email_verified': isEmailVerified,
      'is_active': isActive,
      'profile_completed': profileCompleted,
      'role': role,
      'total_bottles_recycled': totalBottlesRecycled,
      'created_at': createdAt.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
    };
  }
}
