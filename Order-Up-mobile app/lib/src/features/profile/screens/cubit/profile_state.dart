part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitialState extends ProfileState {}

/// Image Picker State

class ProfileImagePickLoadingState extends ProfileState {}

class ProfileImagePickLoadedState extends ProfileState {
  const ProfileImagePickLoadedState({required this.pickedImage});

  final XFile? pickedImage;
}

class ProfileImagePickFailedState extends ProfileState {
  const ProfileImagePickFailedState({required this.message});

  final String message;
}

/// Profile Image Upload State
class ProfileImgUploadLoadingState extends ProfileState {}

class ProfileImgUploadSuccesstate extends ProfileState {
  const ProfileImgUploadSuccesstate({required this.user});

  final AuthUser user;
}

class ProfileImgUploadFailedState extends ProfileState {
  const ProfileImgUploadFailedState({required this.message});

  final String message;
}

/// Edit Profile State
class ProfileUpdateLoadingState extends ProfileState {}

class ProfileUpdateSuccessState extends ProfileState {
  const ProfileUpdateSuccessState({required this.profileImage});

  final String profileImage;
}

class ProfileUpdateFailedState extends ProfileState {
  const ProfileUpdateFailedState({required this.message});

  final String message;
}

/// DELETE REASON STATE
class ProfileReasonListLoadingState extends ProfileState {}

class ProfileReasonListLoadedState extends ProfileState {
  const ProfileReasonListLoadedState({required this.reasons});

  final List<String> reasons;
}

class ProfileReasonListFailedState extends ProfileState {
  const ProfileReasonListFailedState({required this.message});

  final String message;
}
