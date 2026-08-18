import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/constants/app_assets.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/authentication/domain/auth_role_enum.dart';
import 'package:orderly_ecom/src/features/authentication/screens/cubit/auth_cubit.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/clippers.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';

class NewSignInScreen extends StatelessWidget {
  const NewSignInScreen({
    super.key,
    required this.userRole,
    required this.isGuest,
  });
  final String userRole;
  final bool isGuest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderlyAppBar(
        leadingWidget: const Center(),
        title: AppLocalizations.of(context)!.create_account,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(
                  AppAssets.appLogo,
                ),
                height: 180.0,
              ),
              Text(
                () {
                  if (userRole == AuthRole.consumer.name) {
                    return '${AppLocalizations.of(context)!.choice_screen} ${AppLocalizations.of(context)!.customer}';
                  } else if (userRole == AuthRole.producer.name) {
                    return '${AppLocalizations.of(context)!.choice_screen} ${AppLocalizations.of(context)!.manager}';
                  }
                  return '${AppLocalizations.of(context)!.choice_screen} ${AppLocalizations.of(context)!.delivery}';
                }(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 15.0, left: 20.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 260,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .color!
                              .withOpacity(0.15),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: InkWell(
                        onTap: () {
                          context.pushReplacementNamed(
                            AppRoute.verifyPhone.toName,
                            params: {
                              'role': userRole,
                            },
                            extra: {
                              'isGuest': isGuest,
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 2.0),
                            const Icon(
                              kIsWeb ? Icons.phone : Iconsax.mobile,
                            ),
                            const SizedBox(
                              width: 14.0,
                            ),
                            Text(
                              AppLocalizations.of(context)!.login_phone,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              gapH12,
              CustomPaint(
                size: const Size(double.infinity, 4),
                painter: DashedLinePainter(),
              ),
              gapH12,

              /// [GUEST]
              Visibility(
                visible: userRole == AuthRole.consumer.name,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocConsumer<AuthCubit, AuthState>(
                      listenWhen: (_, newState) {
                        return newState is AuthLoggedInState ||
                            newState is AuthFailedState;
                      },
                      listener: (context, state) {
                        if (state is AuthLoggedInState) {
                          context.pushNamed(AppRoute.home.toName);
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
                      buildWhen: (_, newState) {
                        return (newState is AuthLoadingState &&
                                newState.isGuest) ||
                            newState is AuthLoggedInState ||
                            newState is AuthFailedState;
                      },
                      builder: (context, state) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: state is AuthLoadingState ? 50 : 260,
                          height: state is AuthLoadingState ? 50 : 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.15),
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50.0)),
                          ),
                          child: state is AuthLoadingState
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.primaryColor,
                                  ),
                                )
                              : InkWell(
                                  onTap: () async {
                                    await context
                                        .read<AuthCubit>()
                                        .loginWithGuest(
                                          userType: userRole,
                                        );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 2.0),
                                      const Icon(
                                        kIsWeb ? Icons.person : Iconsax.user,
                                      ),
                                      const SizedBox(
                                        width: 14.0,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .continue_guest,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ],
                                  ),
                                ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              gapH24,
              gapH24,
              gapH24,
              Text(
                'Are you a Store Manager or Delivery Agent?',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextButton(
                onPressed: () {
                  context.pushNamed(AppRoute.choiceScreen.name);
                },
                child: const Text(
                  'Login here',
                ),
              ),
              const SizedBox(height: 20.0),
              const Spacer(),
              Visibility(
                visible: userRole == AuthRole.consumer.name,
                replacement: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: AppLocalizations.of(context)!.terms_pro,
                    style: const TextStyle(
                      color: AppColor.textColor,
                    ),
                    children: [
                      TextSpan(
                        text: 'help@order-up.in',
                        style: const TextStyle(
                          color: AppColor.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            await url_launcher.launchUrl(
                                Uri.parse('mailto://help@order-up.in'));
                          },
                      ),
                    ],
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.terms,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.terms_of_use,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Understand our ',
                    style: Theme.of(context).textTheme.bodySmall!,
                  ),
                  InkWell(
                    onTap: () async {
                      if (!kIsWeb) {
                        context.go(AppRoute.privacyPolicy.toPath);
                      } else {
                        final url = await callPrivacyApi();
                        url_launcher.launchUrl(Uri.parse(url));
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.privacy_policy,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: AppColor.accentColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  gapH12,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> callPrivacyApi() async {
    try {
      final response =
          await inject.get<NetworkAdapter>().get(Endpoints.privacyPolicy);
      if (response.statusCode == 200) {
        if (response.data['statusCode'] == 200) {
          return response.data['data']['url'];
        } else {
          return '';
        }
      } else {
        return '';
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }
}
