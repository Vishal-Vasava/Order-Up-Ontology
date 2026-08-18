class PostalCode {
  factory PostalCode.fromJson(Map<String, dynamic> json) => PostalCode(
        status: json['status'] as bool,
        result: (json['result'] as List<dynamic>?)
            ?.map((e) => Result.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  PostalCode({required this.status, required this.result});
  final bool status;
  final List<Result>? result;
}

class Result {
  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json['id'] as String,
        country: json['country'] as String,
        postalCode: json['postalCode'] as String,
        postalLocation: json['postalLocation'] as String,
        state: json['state'] as String,
        stateId: json['stateId'] as String,
        district: json['district'] as String,
        districtId: json['districtId'] as String,
        province: json['province'] as String,
        provinceId: json['provinceId'] as String,
        latitude: json['latitude'] as String,
        longitude: json['longitude'] as String,
      );

  Result({
    required this.id,
    required this.country,
    required this.postalCode,
    required this.postalLocation,
    required this.state,
    required this.stateId,
    required this.district,
    required this.districtId,
    required this.province,
    required this.provinceId,
    required this.latitude,
    required this.longitude,
  });
  final String id;
  final String country;
  final String postalCode;
  final String postalLocation;
  final String state;
  final String stateId;
  final String district;
  final String districtId;
  final String province;
  final String provinceId;
  final String latitude;
  final String longitude;
}
