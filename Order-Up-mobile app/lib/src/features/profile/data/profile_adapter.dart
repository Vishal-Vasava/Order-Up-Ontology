import 'dart:io';

import 'package:image_picker/image_picker.dart';

abstract class ProfileAdapter {
  Future<XFile?> pickImage({required ImageSource imageSource});

  // Future<AuthUser?> uploadImage({required File image});

  Future<String> editProfile({
    required String firstName,
    required String lastName,
    required String emailId,
    required String zipCode,
    required String address,
    required String mobile,
    required String latitude,
    required String longitude,
    required File? image,
  });

  Future<List<String>> fetchRemoveReasons();
}
