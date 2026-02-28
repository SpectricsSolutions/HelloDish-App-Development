class LoginResponse {
  final String status;
  final String message;
  final String? otpId;

  LoginResponse({
    required this.status,
    required this.message,
    this.otpId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      otpId: json['data']?['otpId'],
    );
  }

  bool get isSuccess => status == 'success';
}

class VerifyOtpResponse {
  final String status;
  final String message;
  final String? token;

  VerifyOtpResponse({
    required this.status,
    required this.message,
    this.token,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      token: json['data']?['token'],
    );
  }

  bool get isSuccess => status == 'success';
}
