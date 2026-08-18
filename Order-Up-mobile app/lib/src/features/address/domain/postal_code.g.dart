// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postal_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostalCode _$PostalCodeFromJson(Map<String, dynamic> json) => PostalCode(
      status: json['status'] as bool,
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => PostalData.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$PostalCodeToJson(PostalCode instance) =>
    <String, dynamic>{
      'status': instance.status,
      'result': instance.result,
      'message': instance.message,
    };

PostalData _$PostalDataFromJson(Map<String, dynamic> json) => PostalData(
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

Map<String, dynamic> _$PostalDataToJson(PostalData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'country': instance.country,
      'postalCode': instance.postalCode,
      'postalLocation': instance.postalLocation,
      'state': instance.state,
      'stateId': instance.stateId,
      'district': instance.district,
      'districtId': instance.districtId,
      'province': instance.province,
      'provinceId': instance.provinceId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
