class Register {
  Register({
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.email,
    required this.address,
    required this.zipcode,
    required this.firebaseId,
    required this.version,
    required this.signupType,
    required this.fcmId,
    required this.deviceId,
    required this.deviceName,
    required this.latitude,
    required this.longitude,
  });
  final String firstName;
  final String lastName;
  final String mobile;
  final String email;
  final String address;
  final String zipcode;
  final String firebaseId;
  final String version;
  final String signupType;
  final String fcmId;
  final String deviceId;
  final String deviceName;
  final String latitude;
  final String longitude;

  Map<String, dynamic> toJson() {
    return {
      'fb_id': firebaseId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'version': version,
      'signup_type': signupType,
      'device_id': deviceId,
      'fcm_id': fcmId,
      'phone': mobile,
      'device': deviceId,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'zip_code': zipcode,
    };
  }
}
