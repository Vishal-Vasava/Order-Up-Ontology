import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly_ecom/src/constants/app_assets.dart';
import 'package:orderly_ecom/src/features/authentication/domain/auth_role_enum.dart';
import 'package:orderly_ecom/src/features/authentication/screens/cubit/auth_cubit.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:orderly_ecom/src/widgets/app_button.dart';

class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen(
      {super.key, required this.userRole, required this.isGuest});
  final String userRole;
  final bool isGuest;

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final TextEditingController _mobilecontroller = TextEditingController();
  String countrycode = '';

  @override
  void dispose() {
    _mobilecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderlyAppBar(
        title: AppLocalizations.of(context)!.sign_in,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AppAssets.backgroundImage,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              image: AssetImage(
                AppAssets.appLogo,
              ),
              height: 200.0,
            ),
            Text(
              () {
                if (widget.userRole == AuthRole.consumer.name) {
                  return '${AppLocalizations.of(context)!.choice_screen} ${AppLocalizations.of(context)!.customer}';
                } else if (widget.userRole == AuthRole.producer.name) {
                  return '${AppLocalizations.of(context)!.choice_screen} ${AppLocalizations.of(context)!.manager}';
                }
                return '${AppLocalizations.of(context)!.choice_screen} ${AppLocalizations.of(context)!.delivery}';
              }(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12.0),
            Text(
              AppLocalizations.of(context)!.input_mobile,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            CountryListPick(
              appBar: OrderlyAppBar(
                title: 'Select Country',
              ),
              pickerBuilder: (context, CountryCode? countryCode) {
                countrycode = countryCode!.dialCode.toString();
                return Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 25.0),
                      padding: const EdgeInsets.all(8.0),
                      height: 45.0,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor.withOpacity(0.2),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          countryCode.dialCode ?? '',
                          style: const TextStyle(
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 45.0,
                        margin: const EdgeInsets.only(right: 25.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: TextFormField(
                            controller: _mobilecontroller,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Phone Number',
                              labelText: 'Phone Number',
                            ),
                            onChanged: (value) {
                              if (value.length == 10) {
                                FocusManager.instance.primaryFocus!.unfocus();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              initialSelection: '+1',
              onChanged: (CountryCode? code) {},
            ),
            const Spacer(flex: 3),
            BlocConsumer<AuthCubit, AuthState>(
              listenWhen: (_, newState) {
                return newState is AuthCodeSentState ||
                    newState is AuthFailedState;
              },
              listener: (context, state) {
                if (state is AuthCodeSentState) {
                  context.pushReplacementNamed(
                    AppRoute.otpScreen.toName,
                    params: {
                      'role': widget.userRole,
                    },
                    extra: {
                      'isGuest': widget.isGuest,
                    },
                    queryParams: {
                      'countryCode': countrycode,
                      'phoneNumber': _mobilecontroller.text.trim(),
                    },
                  );
                  showSnackBar(
                    context: context,
                    title: 'An OTP has been sent.',
                    message: 'On $countrycode${_mobilecontroller.text}',
                    snackbarType: SnackbarType.success,
                  );
                }
                if (state is AuthFailedState) {
                  showSnackBar(
                    context: context,
                    title: 'Oops',
                    message: state.error,
                    snackbarType: SnackbarType.error,
                  );
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: AppButton(
                    onPressed: () async {
                      if (state is AuthLoadingState) {
                        return;
                      }
                      if (_mobilecontroller.text.isEmpty) {
                        showSnackBar(
                          context: context,
                          title: 'Oops',
                          message: 'Please enter mobile number',
                          snackbarType: SnackbarType.error,
                        );
                      } else if (_mobilecontroller.text.length != 10) {
                        showSnackBar(
                          context: context,
                          title: 'Oops',
                          message: 'Please enter valid mobile number',
                          snackbarType: SnackbarType.error,
                        );
                      } else {
                        String phoneNumber =
                            '$countrycode${_mobilecontroller.text}';
                        await context.read<AuthCubit>().sendOTP(
                              phoneNumber: phoneNumber,
                              userType: widget.userRole,
                              guestToken: '',
                            );
                      }
                    },
                    isLoading: state is AuthLoadingState,
                    buttonText: AppLocalizations.of(context)!.verify_number,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
