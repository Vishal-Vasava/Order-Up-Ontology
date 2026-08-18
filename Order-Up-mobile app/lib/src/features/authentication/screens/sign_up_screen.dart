import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly_ecom/src/config/config.dart';
import 'package:orderly_ecom/src/constants/app_assets.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/authentication/domain/register.dart';
import 'package:orderly_ecom/src/features/authentication/screens/cubit/auth_cubit.dart';
import 'package:orderly_ecom/src/features/location/data/location_local_repository.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/utils/validations.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
    required this.phoneNumber,
    required this.firebaseId,
    required this.userRole,
    required this.isGuest,
  });
  final String phoneNumber;
  final String firebaseId;
  final String userRole;
  final bool isGuest;

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late GlobalKey<FormState> formKey;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController mobileController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController zipcodeController;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    mobileController = TextEditingController();
    emailController = TextEditingController();
    addressController = TextEditingController();
    zipcodeController = TextEditingController();
    if (widget.phoneNumber.isNotEmpty) {
      mobileController.text = widget.phoneNumber;
    }
  }

  final ValueNotifier<bool> isZipValid = ValueNotifier<bool>(true);

  Future<void> _callAPIForPincode() async {
    final value = await context
        .read<AuthCubit>()
        .authRepository
        .fetchPincode(pinCode: zipcodeController.text);
    if (value != null) {
      {
        if (value.result != null && value.result!.isNotEmpty) {
          inject
              .get<LocationLocalRepository>()
              .setLatitude(value.result![0].latitude);
          inject
              .get<LocationLocalRepository>()
              .setLongitude(value.result![0].longitude);
          isZipValid.value = true;
        } else {
          isZipValid.value = false;
        }
      }
    } else {
      isZipValid.value = false;
    }
  }

  final List<String> genderList = const [
    'Male',
    'Female',
    'Others',
  ];

  // ValueNotifier<String> selectedGender = ValueNotifier('');

  @override
  void dispose() {
    super.dispose();
    formKey.currentState?.dispose();
    for (final controller in [
      firstNameController,
      lastNameController,
      mobileController,
      emailController,
      addressController,
      zipcodeController,
    ]) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderlyAppBar(
        title: AppLocalizations.of(context)!.sign_up,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AppAssets.backgroundImage,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: formKey,
          child: AutofillGroup(
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                const Divider(
                  thickness: 2.0,
                  indent: 35,
                  endIndent: 35,
                  color: AppColor.blueColor,
                ),
                gapH16,
                TextFormField(
                  controller: firstNameController,
                  validator: Validator.validateName,
                  textAlignVertical: TextAlignVertical.center,
                  autofillHints: const [AutofillHints.namePrefix],
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    counterText: '',
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.clear,
                      ),
                      onPressed: firstNameController.clear,
                    ),
                    labelText: AppLocalizations.of(context)!.first_name,
                    labelStyle: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                gapH16,
                TextFormField(
                  controller: lastNameController,
                  validator: Validator.validateName,
                  textAlignVertical: TextAlignVertical.center,
                  autofillHints: const [AutofillHints.nameSuffix],
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    counterText: '',
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.clear,
                      ),
                      onPressed: lastNameController.clear,
                    ),
                    labelText: AppLocalizations.of(context)!.last_name,
                    labelStyle: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                gapH16,
                TextFormField(
                  controller: emailController,
                  enabled: emailController.text.trim().isEmpty,
                  validator: Validator.validateEmail,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    counterText: '',
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.clear,
                      ),
                      onPressed: emailController.clear,
                    ),
                    labelText: AppLocalizations.of(context)!.input_email,
                    labelStyle: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                gapH16,
                TextFormField(
                  controller: mobileController,
                  enabled: mobileController.text.trim().isEmpty,
                  validator: Validator.validateMobile,
                  textAlignVertical: TextAlignVertical.center,
                  autofillHints: const [
                    AutofillHints.telephoneNumberCountryCode
                  ],
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    counterText: '',
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.clear,
                      ),
                      onPressed: mobileController.clear,
                    ),
                    labelText: AppLocalizations.of(context)!.mobile,
                    labelStyle: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                gapH16,
                TextFormField(
                  controller: addressController,
                  validator: Validator.validateRequired,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
                  maxLines: 3,
                  keyboardType: TextInputType.name,
                  autofillHints: const [AutofillHints.postalAddress],
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    counterText: '',
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.clear,
                      ),
                      onPressed: addressController.clear,
                    ),
                    labelText: AppLocalizations.of(context)!.address,
                    labelStyle: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                gapH16,
                ValueListenableBuilder(
                  valueListenable: isZipValid,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return TextFormField(
                      controller: zipcodeController,
                      validator: (zip) {
                        return null;

                        // if (!value) {
                        //   return 'Please enter Valid zip code';
                        // } else if (zip!.isEmpty ||
                        //     zip.length <= 5 ||
                        //     zip[0] == ' ') {
                        //   return 'Please enter Valid zip code';
                        // }
                        // return null;
                      },
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      autofillHints: const [AutofillHints.postalCode],
                      onChanged: (value) {
                        if (value.length > 5) {
                          _callAPIForPincode();
                        }
                      },
                      onEditingComplete: () {
                        _callAPIForPincode();
                      },
                      onFieldSubmitted: (value) {
                        if (value.length > 5) {
                          _callAPIForPincode();
                        }
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(6),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        counterText: '',
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.clear,
                          ),
                          onPressed: zipcodeController.clear,
                        ),
                        labelText: AppLocalizations.of(context)!.zipcode,
                        labelStyle: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
                // gapH16,
                // ValueListenableBuilder(
                //   valueListenable: selectedGender,
                //   builder: (BuildContext context, String value, Widget? child) {
                //     return DropdownButtonHideUnderline(
                //       child: DropdownButtonFormField(
                //         value: value.isEmpty ? null : value,
                //         items: genderList
                //             .map(
                //               (e) => DropdownMenuItem(
                //                 value: e,
                //                 child: Text(e),
                //               ),
                //             )
                //             .toList(),
                //         autovalidateMode: AutovalidateMode.onUserInteraction,
                //         validator: Validator.validateRequired,
                //         decoration: InputDecoration(
                //           label: Text(
                //             AppLocalizations.of(context)!.gender,
                //           ),
                //         ),
                //         onChanged: (String? value) {
                //           selectedGender.value = value!;
                //         },
                //       ),
                //     );
                //   },
                // ),
                const SizedBox(height: 40.0),
                BlocConsumer<AuthCubit, AuthState>(
                  listenWhen: (_, newState) {
                    return newState is AuthRegisterFailedState ||
                        newState is AuthLoggedInState;
                  },
                  listener: (context, state) {
                    if (state is AuthRegisterFailedState) {
                      showSnackBar(
                        context: context,
                        title: 'Oops',
                        message: state.message,
                        snackbarType: SnackbarType.error,
                      );
                    }
                    if (state is AuthLoggedInState) {
                      context.goNamed(AppRoute.home.toName);
                    }
                    // if (state.fromInnerPage) {
                    //   log('FROM REG INNER PAGE');
                    //   return;
                    // } else {

                    // Navigator.popUntil(context, (route) => route.isFirst);
                    // if (state.user.userType == '2') {
                    //   Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (c) => const DeliveryUserScreen(),
                    //     ),
                    //   );
                    // } else {
                    //   Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => MainNavigation(
                    //         fcmFlagNavigate: '',
                    //         flagOrder: '',
                    //         userType: state.user.userType,
                    //       ),
                    //     ),
                    //   );
                    // }
                    // }
                    // }
                  },
                  buildWhen: (_, newState) {
                    return newState is AuthRegisterLoadingState ||
                        newState is AuthRegisterFailedState ||
                        newState is AuthRegisterSuccessState ||
                        newState is AuthFailedState;
                  },
                  builder: (context, state) {
                    return CupertinoButton(
                      color: AppColor.primaryColor,
                      onPressed: state is AuthRegisterLoadingState
                          ? null
                          : () async {
                              if (state is AuthRegisterLoadingState) {
                                return;
                              }
                              if (formKey.currentState!.validate()) {
                                // log(inject.get<HiveService>().guestAccessToken,
                                //     name: 'GUEST TOKEN REGIS');
                                final deviceId = await context
                                    .read<AuthCubit>()
                                    .authRepository
                                    .getDeviceToken();
                                String? fcmId = '';
                                if (context.mounted) {
                                  fcmId = await context
                                      .read<AuthCubit>()
                                      .authRepository
                                      .getFcmToken();
                                }
                                if (context.mounted) {}

                                final register = Register(
                                  firstName: firstNameController.text.trim(),
                                  lastName: lastNameController.text.trim(),
                                  mobile: mobileController.text.trim(),
                                  email: emailController.text.trim(),
                                  address: addressController.text.trim(),
                                  zipcode: zipcodeController.text.trim(),
                                  firebaseId: widget.firebaseId,
                                  version: Config.appVersion,
                                  signupType: 'phone',
                                  fcmId: fcmId ?? '',
                                  deviceId: deviceId ?? '',
                                  deviceName: '',
                                  latitude: inject
                                      .get<LocationLocalRepository>()
                                      .latitude,
                                  longitude: inject
                                      .get<LocationLocalRepository>()
                                      .longitude,
                                );
                                if (context.mounted) {
                                  await context.read<AuthCubit>().register(
                                        register: register,
                                      );
                                }
                              }
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.sign_up,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: AppColor.whiteColor,
                                ),
                          ),
                          const SizedBox(width: 8),
                          if (state is AuthLoadingState)
                            const Center(
                              child: SizedBox(
                                height: 25.0,
                                width: 25.0,
                                child: CircularProgressIndicator(
                                  color: AppColor.accentColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
