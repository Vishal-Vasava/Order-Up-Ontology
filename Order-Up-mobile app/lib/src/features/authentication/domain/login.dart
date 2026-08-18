class Login {
  Login({
    required this.userType,
    required this.firebaseId,
    required this.fcmId,
    required this.deviceId,
    required this.isGoogle,
    required this.isApple,
    required this.isGuest,
    this.mobile = '',
  });
  final String userType;
  final String firebaseId;
  final String fcmId;
  final String deviceId;
  final bool isGoogle;
  final bool isApple;
  final bool isGuest;
  final String mobile;
  Map<String, dynamic> toJson() {
    return {
      'fb_id': firebaseId,
      'fcm_id': fcmId,
      'device_id': deviceId,
      if (mobile.isNotEmpty) 'mobile': mobile,
    };
  }
}
