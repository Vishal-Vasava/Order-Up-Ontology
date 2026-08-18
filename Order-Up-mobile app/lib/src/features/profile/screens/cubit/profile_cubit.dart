import 'dart:developer';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orderly_ecom/src/features/authentication/domain/auth_user.dart';
import 'package:orderly_ecom/src/features/profile/data/profile_adapter.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> implements ProfileAdapter {
  ProfileCubit({required this.profileAdapter}) : super(ProfileInitialState());
  final ProfileAdapter profileAdapter;

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
      emit(ProfileUpdateLoadingState());
      final success = await profileAdapter.editProfile(
        firstName: firstName,
        lastName: lastName,
        emailId: emailId,
        zipCode: zipCode,
        address: address,
        mobile: mobile,
        image: image,
        latitude: latitude,
        longitude: longitude,
      );
      if (success.isNotEmpty) {
        emit(ProfileUpdateSuccessState(profileImage: success));
      } else {
        emit(const ProfileUpdateFailedState(message: 'Please try again'));
      }
    } catch (e) {
      emit(ProfileUpdateFailedState(message: e.toString()));
    }
    return '';
  }

  @override
  Future<XFile?> pickImage({required ImageSource imageSource}) async {
    try {
      emit(ProfileImagePickLoadingState());
      final data = await profileAdapter.pickImage(
        imageSource: imageSource,
      );
      emit(ProfileImagePickLoadedState(pickedImage: data));
    } catch (e) {
      log(e.toString());
      emit(ProfileImagePickFailedState(message: e.toString()));
    }
    return null;
  }

  // @override
  // Future<AuthUser?> uploadImage({required File image}) async {
  //   try {
  //     emit(ProfileImgUploadLoadingState());
  //     final data = await profileAdapter.uploadImage(image: image);
  //     if (data != null) {
  //       emit(ProfileImgUploadSuccesstate(user: data));
  //     } else {
  //       emit(const ProfileImgUploadFailedState(message: 'Please try again'));
  //     }
  //   } catch (e) {
  //     emit(ProfileImgUploadFailedState(message: e.toString()));
  //   }
  //   return null;
  // }

  @override
  Future<List<String>> fetchRemoveReasons() async {
    try {
      emit(ProfileReasonListLoadingState());
      final list = await profileAdapter.fetchRemoveReasons();
      emit(ProfileReasonListLoadedState(reasons: list));
    } catch (e) {
      log(e.toString());
      emit(ProfileReasonListFailedState(message: e.toString()));
    }
    return [];
  }
}
