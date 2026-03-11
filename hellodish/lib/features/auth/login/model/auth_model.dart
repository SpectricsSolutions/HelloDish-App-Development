class LoginResponse {
  final bool isSuccess;
  final String message;
  final String? otpId;

  LoginResponse({
    required this.isSuccess,
    required this.message,
    this.otpId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return LoginResponse(
      isSuccess: json['status'] == 'success',
      message: json['message'] ?? '',
      otpId: data?['otpId']?.toString(),
    );
  }
}

class UserData {
  final String id;
  final String fName;
  final String lName;
  final String phone;
  final String countryCode;
  final String? email;
  final String? image;

  UserData({
    required this.id,
    required this.fName,
    required this.lName,
    required this.phone,
    required this.countryCode,
    this.email,
    this.image,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id']?.toString() ?? '',
      fName: json['fName'] ?? '',
      lName: json['lName'] ?? '',
      phone: json['phone'] ?? '',
      countryCode: json['countryCode'] ?? '+91',
      email: json['email'],
      image: json['image'],
    );
  }
}

class VerifyOtpResponse {
  final bool isSuccess;
  final String message;
  final String? token;
  final UserData? user;

  VerifyOtpResponse({
    required this.isSuccess,
    required this.message,
    this.token,
    this.user,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return VerifyOtpResponse(
      isSuccess: json['status'] == 'success',
      message: json['message'] ?? '',
      token: data?['token'],
      user: data?['user'] != null
          ? UserData.fromJson(data!['user'] as Map<String, dynamic>)
          : null,
    );
  }
}