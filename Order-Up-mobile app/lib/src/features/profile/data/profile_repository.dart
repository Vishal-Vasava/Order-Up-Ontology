import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/authentication/domain/auth_role_enum.dart';
import 'package:orderly_ecom/src/features/profile/data/profile_adapter.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';
import 'package:orderly_ecom/src/utils/exceptions.dart';

class ProfileRepository extends ProfileAdapter {
  ProfileRepository({required this.networkAdapter});

  final NetworkAdapter networkAdapter;

  @override
  Future<XFile?> pickImage({required ImageSource imageSource}) async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      final data = await imagePicker.pickImage(
        source: imageSource,
        imageQuality: 80,
        maxHeight: 200,
        maxWidth: 200,
      );
      return data;
    } on PlatformException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> editProfile({
    required String firstName,
    required String lastName,
    required String emailId,
    required String zipCode,
    required String address,
    required String mobile,
    required String latitude,
    required String longitude,
    File? image,
  }) async {
    try {
      String url = '';
      final authUser = inject.get<AuthLocalRepository>().authUser;
      if (authUser.userType! == AuthRole.agent.name) {
        url = Endpoints.agentProfileUpdate;
      } else if (authUser.userType! == AuthRole.producer.name) {
        url = Endpoints.storeProfileUpdate;
      } else {
        url = Endpoints.customerProfileUpdate;
      }
      final Map<String, dynamic> data = {
        'first_name': firstName,
        'last_name': lastName,
        'email_id': emailId,
        'zip_code': zipCode,
        'latitude': latitude,
        'longitude': latitude,
        'address': address,
      };

      if (image != null) {
        String fileName = image.path.split('/').last;
        final file = await MultipartFile.fromFile(
          image.path,
          filename: fileName,
          contentType: MediaType(
            'image',
            'JPEG',
          ),
        );
        data['image'] = file;
      }
      FormData formData = FormData.fromMap(data);
      final response = await networkAdapter.post(
        url,
        data: formData,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return response.data['data']['image_url'];
        } else {
          throw const AppException(message: 'Please try again');
        }
      } else {
        return '';
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  // @override
  // Future<AuthUser?> uploadImage({required File image}) async {
  //   try {

  //     FormData formData = FormData.fromMap(data);
  //     final response = await networkAdapter.post(
  //       url,
  //       data: formData,
  //     );
  //     if (response.statusCode! >= 200 && response.statusCode! <= 299) {
  //       if (response.data['msg'] == 'Success') {
  //         return AuthUser.fromJson(response.data['user']);
  //       } else {
  //         throw AppException(message: response.data['msg']);
  //       }
  //     } else {
  //       return null;
  //     }
  //   } on DioException catch (e) {
  //     throw DioExceptions.fromDioError(e).toString();
  //   }
  // }

  @override
  Future<List<String>> fetchRemoveReasons() async {
    try {
      const String url = Endpoints.removeAccountReasons;
      final response = await networkAdapter.get(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 200) {
        List<String> reasonList = [];
        if (response.data['statusCode'] == 200) {
          List<String> reasons =
              (response.data['data'] as List).map((e) => e.toString()).toList();
          reasonList = reasons;
          reasonList.add('Other');
          return reasonList;
        } else {
          reasonList.add('Other');
          return reasonList;
        }
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }
}
