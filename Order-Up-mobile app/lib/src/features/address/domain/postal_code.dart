// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'postal_code.g.dart';

@JsonSerializable()
class PostalCode {
  factory PostalCode.fromJson(Map<String, dynamic> json) =>
      _$PostalCodeFromJson(json);

  PostalCode({
    required this.status,
    this.result,
    this.message,
  });
  @JsonKey(name: 'status')
  bool status;
  @JsonKey(name: 'result')
  // List<Result> result;
  List<PostalData>? result = <PostalData>[];
  @JsonKey(name: 'message')
  String? message;

  Map<String, dynamic> toJson() => _$PostalCodeToJson(this);
}

@JsonSerializable()
class PostalData {
  factory PostalData.fromJson(Map<String, dynamic> json) =>
      _$PostalDataFromJson(json);

  PostalData({
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
  @JsonKey(name: 'id')
  String id;
  @JsonKey(name: 'country')
  String country;
  @JsonKey(name: 'postalCode')
  String postalCode;
  @JsonKey(name: 'postalLocation')
  String postalLocation;
  @JsonKey(name: 'state')
  String state;
  @JsonKey(name: 'stateId')
  String stateId;
  @JsonKey(name: 'district')
  String district;
  @JsonKey(name: 'districtId')
  String districtId;
  @JsonKey(name: 'province')
  String province;
  @JsonKey(name: 'provinceId')
  String provinceId;
  @JsonKey(name: 'latitude')
  String latitude;
  @JsonKey(name: 'longitude')
  String longitude;

  Map<String, dynamic> toJson() => _$PostalDataToJson(this);
}
