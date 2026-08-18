import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly_ecom/src/constants/app_assets.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/authentication/screens/cubit/auth_cubit.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/widgets/app_button.dart';
import 'package:orderly_ecom/src/widgets/resend_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.userRole,
    required this.countryCode,
    required this.phoneNumber,
    required this.isGuest,
  });
  final String userRole;
  final String countryCode;
  final String phoneNumber;
  final bool isGuest;

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _firstDigit = '';
  String _secondDigit = '';
  String _thirdDigit = '';
  String _fourthDigit = '';
  String _fifthDigit = '';
  String _sixthDigit = '';

  String? _currentDigit;

  String otp = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderlyAppBar(
        title: AppLocalizations.of(context)!.otp_verify,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(
                  AppAssets.appLogo,
                ),
                height: 160.0,
                width: 160.0,
              ),
              Text(
                AppLocalizations.of(context)!.otp_verification,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              gapH12,
              Text(
                '${widget.countryCode} ${widget.phoneNumber}',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: AppColor.primaryColor,
                    ),
              ),
              gapH12,
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: getInputField,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ResendButton(
                      onPressed: () async {
                        await context.read<AuthCubit>().sendOTP(
                              phoneNumber:
                                  widget.countryCode + widget.phoneNumber,
                              userType: widget.userRole,
                              guestToken: '',
                            );
                      },
                    ),
                  ],
                ),
              ),
              gapH8,
              BlocConsumer<AuthCubit, AuthState>(
                listenWhen: (_, newState) {
                  return newState is AuthLoggedInState ||
                      newState is AuthFailedState;
                },
                listener: (context, state) {
                  if (state is AuthLoggedInState) {
                    // if (state.user.isRegistered == 'false') {
                    //   context.pushReplacementNamed(
                    //     AppRoute.signUp.toName,
                    //     params: {
                    //       'role': widget.userRole,
                    //     },
                    //     extra: {
                    //       'phoneNumber': widget.phoneNumber,
                    //     },
                    //   );
                    // } else {
                    context.goNamed(AppRoute.home.toName, extra: {
                      'isGuest': widget.isGuest,
                    });
                    // if (state.fromInnerPage) {
                    //   log('FROM INNNNER PAGE');
                    //   return;
                    // } else {
                    //   Navigator.popUntil(context, (route) => route.isFirst);
                    //   if (state.user.userType == '2') {
                    //     Navigator.pushReplacement(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (c) => const DeliveryUserScreen(),
                    //       ),
                    //     );
                    //   } else {
                    //     Navigator.pushReplacement(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => MainNavigation(
                    //           fcmFlagNavigate: '',
                    //           flagOrder: '',
                    //           userType: widget.otpVerify.flagRoleType!,
                    //         ),
                    //       ),
                    //     );
                    //   }
                    // }
                    // }
                  } else if (state is AuthFailedState) {
                    if (state.error == 'Customer Not Found') {
                      context.pushReplacementNamed(
                        AppRoute.signUp.toName,
                        params: {
                          'role': widget.userRole,
                        },
                        extra: {
                          'phoneNumber': widget.phoneNumber,
                          'firebaseId': context.read<AuthCubit>().firebaseId,
                          'isGuest': widget.isGuest,
                        },
                      );
                    } else {
                      showSnackBar(
                        context: context,
                        title: 'Oops',
                        message: state.error,
                        snackbarType: SnackbarType.error,
                      );
                    }
                  }
                },
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: AppButton(
                      onPressed: _sixthDigit.isEmpty
                          ? null
                          : () async {
                              if (_sixthDigit.isNotEmpty) {
                                // log(inject.get<HiveService>().guestAccessToken,
                                //     name: 'GUEST TOKEN OTP SCREEN');
                                await context.read<AuthCubit>().verifyOTP(
                                      userType: widget.userRole,
                                      otpNumber: otp,
                                      verificationId: '',
                                      guestToken: widget.isGuest ? 'guest' : '',
                                      phoneNumber: widget.countryCode +
                                          widget.phoneNumber,
                                    );
                              } else {
                                showSnackBar(
                                  context: context,
                                  title: 'Oops',
                                  message: 'Please enter OTP',
                                  snackbarType: SnackbarType.error,
                                );
                              }
                            },
                      buttonText: AppLocalizations.of(context)!.verify,
                      isLoading: state is AuthLoadingState,
                    ),
                  );
                },
              ),
              getOtpKeyboard,
            ],
          ),
        ),
      ),
    );
  }

  get getOtpKeyboard {
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _otpKeyboardInputButton(
                    label: '1',
                    onPressed: () {
                      _setCurrentDigit('1');
                    }),
                _otpKeyboardInputButton(
                    label: '2',
                    onPressed: () {
                      _setCurrentDigit('2');
                    }),
                _otpKeyboardInputButton(
                    label: '3',
                    onPressed: () {
                      _setCurrentDigit('3');
                    }),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _otpKeyboardInputButton(
                    label: '4',
                    onPressed: () {
                      _setCurrentDigit('4');
                    }),
                _otpKeyboardInputButton(
                    label: '5',
                    onPressed: () {
                      _setCurrentDigit('5');
                    }),
                _otpKeyboardInputButton(
                    label: '6',
                    onPressed: () {
                      _setCurrentDigit('6');
                    }),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _otpKeyboardInputButton(
                    label: '7',
                    onPressed: () {
                      _setCurrentDigit('7');
                    }),
                _otpKeyboardInputButton(
                    label: '8',
                    onPressed: () {
                      _setCurrentDigit('8');
                    }),
                _otpKeyboardInputButton(
                    label: '9',
                    onPressed: () {
                      _setCurrentDigit('9');
                    }),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _otpKeyboardInputButton(
                    label: '0',
                    onPressed: () {
                      _setCurrentDigit('0');
                    }),
                _otpKeyboardActionButton(
                    label: const Icon(
                      Icons.backspace,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_sixthDigit.isNotEmpty) {
                          _sixthDigit = '';
                        } else if (_fifthDigit.isNotEmpty) {
                          _fifthDigit = '';
                        } else if (_fourthDigit.isNotEmpty) {
                          _fourthDigit = '';
                        } else if (_thirdDigit.isNotEmpty) {
                          _thirdDigit = '';
                        } else if (_secondDigit.isNotEmpty) {
                          _secondDigit = '';
                        } else {
                          _firstDigit = '';
                        }
                      });
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Returns "Otp keyboard input Button"
  Widget _otpKeyboardInputButton({String? label, VoidCallback? onPressed}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(40.0),
        child: Container(
          height: 80.0,
          width: 80.0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              label!,
              style: const TextStyle(
                fontSize: 30.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Return "OTP" input field
  Row get getInputField {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _otpTextField(_firstDigit),
        _otpTextField(_secondDigit),
        _otpTextField(_thirdDigit),
        _otpTextField(_fourthDigit),
        _otpTextField(_fifthDigit),
        _otpTextField(_sixthDigit),
      ],
    );
  }

  // Returns "Otp custom text field"
  Widget _otpTextField(String digit) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.065,
        margin: const EdgeInsets.all(4.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: digit.isEmpty
                ? const Color(0xFFFFD8BC)
                : Theme.of(context).primaryColor, // red as border color
          ),
          color: digit.isEmpty
              ? AppColor.accentColor.withOpacity(0.2)
              : Colors.white,
        ),
        child: Text(
          digit,
          style: const TextStyle(
            fontSize: 18.0,
            color: AppColor.textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Returns "Otp keyboard action Button"
  _otpKeyboardActionButton({Widget? label, VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(40.0),
      child: Container(
        height: 80.0,
        width: 80.0,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
          child: label,
        ),
      ),
    );
  }

  // Current digit
  void _setCurrentDigit(String i) {
    setState(() {
      _currentDigit = i;
      if (_firstDigit.isEmpty) {
        _firstDigit = _currentDigit!;
      } else if (_secondDigit.isEmpty) {
        _secondDigit = _currentDigit!;
      } else if (_thirdDigit.isEmpty) {
        _thirdDigit = _currentDigit!;
      } else if (_fourthDigit.isEmpty) {
        _fourthDigit = _currentDigit!;
      } else if (_fifthDigit.isEmpty) {
        _fifthDigit = _currentDigit!;
      } else if (_sixthDigit.isEmpty) {
        _sixthDigit = _currentDigit!;

        otp = _firstDigit +
            _secondDigit +
            _thirdDigit +
            _fourthDigit +
            _fifthDigit +
            _sixthDigit;
      }
    });
  }
}
