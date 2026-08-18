import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/address/domain/postal_code.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/authentication/domain/auth_user.dart';
import 'package:orderly_ecom/src/features/location/data/location_local_repository.dart';
import 'package:orderly_ecom/src/features/profile/screens/cubit/profile_cubit.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/utils/validations.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:orderly_ecom/src/widgets/app_button.dart';
import 'package:orderly_ecom/src/widgets/app_dialog.dart';
import 'package:orderly_ecom/src/widgets/image_picker_sheet.dart';

class ProfileEditForm extends StatefulWidget {
  const ProfileEditForm({super.key});

  @override
  _ProfileEditFormState createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  final ValueNotifier<File?> profileNotifier = ValueNotifier<File?>(null);

  late AuthUser authUser;

  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController zipController;
  late final TextEditingController emailController;
  late final TextEditingController mobileController;
  late final TextEditingController addressController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    authUser = inject.get<AuthLocalRepository>().authUser;

    firstNameController = TextEditingController(text: authUser.firstName);
    lastNameController = TextEditingController(text: authUser.lastName);
    zipController = TextEditingController(text: authUser.zipCode);
    emailController = TextEditingController(text: authUser.email);
    mobileController = TextEditingController(text: authUser.phone);
    addressController = TextEditingController(text: authUser.addressLine);
  }

  final ValueNotifier<bool> isZipValid = ValueNotifier<bool>(true);
  List<PostalData> postResultList = <PostalData>[];
  Future<void> _callAPIForPincode() async {
    await Future.delayed(const Duration(milliseconds: 800));
    late PostalCode? postalCode;
    try {
      final url =
          Endpoints.worldPostalLocationApi(pinCode: zipController.text.trim());
      final response = await inject.get<NetworkAdapter>().get(url);
      postalCode = PostalCode.fromJson(response.data);
    } on DioException catch (e) {
      DioExceptions.fromDioError(e).toString();
    }
    if (postalCode != null) {
      {
        if (postalCode.result != null && postalCode.result!.isNotEmpty) {
          isZipValid.value = true;
          setState(() {
            postResultList = postalCode?.result ?? [];
            if (postResultList.isEmpty) {
              addressController.text = '';
            } else {
              addressController.text =
                  '${postResultList[0].postalCode}, ${postResultList[0].state},'
                  '${postResultList[0].country}, ${postResultList[0].postalLocation},${postResultList[0].province}';
            }
          });
        } else {
          isZipValid.value = false;
        }
      }
    } else {
      isZipValid.value = false;
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    zipController.dispose();
    emailController.dispose();
    mobileController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Widget _buildAvatar() {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (_, newState) {
        return newState is ProfileImagePickFailedState ||
            newState is ProfileImagePickLoadedState ||
            newState is ProfileImagePickLoadingState;
      },
      listener: (context, state) async {
        if (state is ProfileImagePickFailedState) {
          context.pop();
          showSnackBar(
            context: context,
            title: 'Please try again',
            message: state.message,
            snackbarType: SnackbarType.error,
          );
        }
        if (state is ProfileImagePickLoadedState) {
          if (state.pickedImage != null) {
            profileNotifier.value = File(state.pickedImage!.path);
          }
          await Future.delayed(const Duration(seconds: 2));
          // ignore: use_build_context_synchronously
          context.pop();
        }
      },
      buildWhen: (_, newState) {
        return newState is ProfileImagePickFailedState ||
            newState is ProfileImagePickLoadedState ||
            newState is ProfileImagePickLoadingState;
      },
      builder: (context, state) {
        return ValueListenableBuilder(
          valueListenable: profileNotifier,
          builder: (BuildContext context, File? value, Widget? child) {
            Widget child;
            if (value != null) {
              child = Image.file(
                value,
                fit: BoxFit.contain,
                width: 100.0,
                height: 100.0,
                cacheHeight: 70,
                cacheWidth: 70,
              );
            } else if (authUser.imageUrl?.isNotEmpty ?? false) {
              child = Image(
                image: CachedNetworkImageProvider(
                  authUser.imageUrl!,
                ),
                fit: BoxFit.contain,
              );
            } else {
              child = const ClipRect(
                child: Icon(
                  kIsWeb ? Icons.person : Iconsax.user,
                ),
              );
            }

            return Container(
              height: 120.0,
              width: 120.0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              child: child,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderlyAppBar(
        title: AppLocalizations.of(context)!.edit_profile,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(kBorderRadius),
          children: [
            Align(
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.bottomRight,
                clipBehavior: Clip.none,
                children: <Widget>[
                  _buildAvatar(),
                  InkWell(
                    onTap: () {
                      AppDialog.showBottomSheet(
                        context: context,
                        child: ImagePickerSheet(
                          onCameraClick: () async {
                            await context.read<ProfileCubit>().pickImage(
                                  imageSource: ImageSource.camera,
                                );
                          },
                          onGalleryClick: () async {
                            await context.read<ProfileCubit>().pickImage(
                                  imageSource: ImageSource.gallery,
                                );
                          },
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 18.0,
                      backgroundColor: AppColor.accentColor,
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // BlocConsumer<ProfileCubit, ProfileState>(
            //   listenWhen: (_, newState) {
            //     return newState is ProfileImgUploadSuccesstate ||
            //         newState is ProfileImgUploadLoadingState ||
            //         newState is ProfileImgUploadFailedState;
            //   },
            //   listener: (context, state) {
            //     if (state is ProfileImgUploadSuccesstate) {
            //       context.pop();
            //       inject.get<AuthLocalRepository>().setUserModel(
            //           user: authUser.copyWith(
            //               profilePicture: state.user.imageUrl!));
            //       showSnackBar(
            //         context: context,
            //         title: 'Profile',
            //         message: 'Updated Profile Image',
            //         snackbarType: SnackbarType.success,
            //       );
            //     }
            //     if (state is ProfileImgUploadFailedState) {
            //       showSnackBar(
            //         context: context,
            //         title: 'Failed',
            //         message: state.message,
            //         snackbarType: SnackbarType.error,
            //       );
            //     }
            //   },
            //   buildWhen: (_, newState) {
            //     return newState is ProfileImgUploadSuccesstate ||
            //         newState is ProfileImgUploadLoadingState ||
            //         newState is ProfileImgUploadFailedState;
            //   },
            //   builder: (context, state) {
            //     return Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Container(
            //           margin: const EdgeInsets.only(top: 10.0),
            //           child: CupertinoButton(
            //             color: AppColor.primaryColor,
            //             onPressed: state is ProfileImgUploadLoadingState
            //                 ? null
            //                 : () async {
            //                     if (profileNotifier.value == null) {
            //                       return;
            //                     }
            //                     await context.read<ProfileCubit>().uploadImage(
            //                           image: profileNotifier.value!,
            //                         );
            //                   },
            //             child: state is ProfileImgUploadLoadingState
            //                 ? const SizedBox(
            //                     height: 30.0,
            //                     width: 30.0,
            //                     child: Center(
            //                       child: CircularProgressIndicator(),
            //                     ),
            //                   )
            //                 : Text(
            //                     'Upload Photo',
            //                     style: Theme.of(context)
            //                         .textTheme
            //                         .labelLarge!
            //                         .copyWith(
            //                           color: Colors.white,
            //                           fontWeight: FontWeight.w600,
            //                         ),
            //                   ),
            //           ),
            //         ),
            //       ],
            //     );
            //   },
            // ),
            gapH20,
            Text(
              AppLocalizations.of(context)!.first_name,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: AppColor.blackColor60,
                  ),
            ),
            gapH8,
            TextFormField(
              controller: firstNameController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              validator: Validator.validateName,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.first_name,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
            gapH20,
            Text(
              AppLocalizations.of(context)!.last_name,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: AppColor.blackColor60,
                  ),
            ),
            gapH8,
            TextFormField(
              controller: lastNameController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              validator: Validator.validateName,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.last_name,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
            gapH20,
            Text(
              AppLocalizations.of(context)!.zipcode,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: AppColor.blackColor60,
                  ),
            ),
            gapH8,
            ValueListenableBuilder(
              valueListenable: isZipValid,
              builder: (BuildContext context, bool value, Widget? child) {
                return TextFormField(
                  controller: zipController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.zipcode,
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(kBorderRadius - 4),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(kBorderRadius - 4),
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (zip) {
                    if (!value) {
                      return 'Please enter Valid zip code';
                    } else if (zip!.isEmpty ||
                        zip.length <= 5 ||
                        zip[0] == ' ') {
                      return 'Please enter Valid zip code';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.length >= 4) {
                      _callAPIForPincode();
                    }
                  },
                  onEditingComplete: () {
                    if (postResultList.isEmpty) {
                      if (zipController.text.length >= 4) {
                        _callAPIForPincode();
                      }
                    }
                  },
                  onFieldSubmitted: (value) {
                    if (postResultList.isEmpty) {
                      if (value.length >= 4) {
                        _callAPIForPincode();
                      }
                    }
                  },
                );
              },
            ),
            gapH20,
            Text(
              AppLocalizations.of(context)!.address,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: AppColor.blackColor60,
                  ),
            ),
            gapH8,
            TextFormField(
              controller: addressController,
              textInputAction: TextInputAction.next,
              validator: Validator.validateRequired,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.address,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
            gapH20,
            Text(
              AppLocalizations.of(context)!.email,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: AppColor.blackColor60,
                  ),
            ),
            gapH8,
            TextFormField(
              controller: emailController,
              textInputAction: TextInputAction.next,
              validator: Validator.validateEmail,
              enabled: false,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.email,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
            gapH20,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocConsumer<ProfileCubit, ProfileState>(
                  listenWhen: (_, newState) {
                    return newState is ProfileUpdateFailedState ||
                        newState is ProfileUpdateSuccessState;
                  },
                  listener: (context, state) {
                    if (state is ProfileUpdateSuccessState) {
                      inject.get<AuthLocalRepository>().setUserModel(
                            user: authUser.copyWith(
                              firstName: firstNameController.text.trim(),
                              lastName: lastNameController.text.trim(),
                              emailId: emailController.text.trim(),
                              address: addressController.text.trim(),
                              zipCode: zipController.text.trim(),
                              mobile: mobileController.text.trim(),
                              profilePicture: state.profileImage,
                            ),
                          );
                      context.pop();
                      showSnackBar(
                        context: context,
                        title: 'Profile',
                        message: 'Updated Successfully',
                        snackbarType: SnackbarType.success,
                      );
                    }
                    if (state is ProfileUpdateFailedState) {
                      showSnackBar(
                        context: context,
                        title: 'Try again',
                        message: state.message,
                        snackbarType: SnackbarType.error,
                      );
                    }
                  },
                  buildWhen: (_, newState) {
                    return newState is ProfileUpdateFailedState ||
                        newState is ProfileUpdateLoadingState ||
                        newState is ProfileUpdateSuccessState;
                  },
                  builder: (context, state) {
                    return AppButton(
                      isLoading: state is ProfileUpdateLoadingState,
                      buttonText: 'Save Details',
                      onPressed: () async {
                        if (formKey.currentState?.validate() ?? false) {
                          await context.read<ProfileCubit>().editProfile(
                                firstName: firstNameController.text.trim(),
                                lastName: lastNameController.text.trim(),
                                emailId: emailController.text.trim(),
                                address: addressController.text.trim(),
                                zipCode: zipController.text.trim(),
                                mobile: mobileController.text.trim(),
                                image: profileNotifier.value,
                                latitude: postResultList.isNotEmpty
                                    ? postResultList[0].latitude
                                    : inject
                                        .get<LocationLocalRepository>()
                                        .latitude,
                                longitude: postResultList.isNotEmpty
                                    ? postResultList[0].longitude
                                    : inject
                                        .get<LocationLocalRepository>()
                                        .longitude,
                              );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
            gapH20,
          ],
        ),
      ),
    );
  }
}
