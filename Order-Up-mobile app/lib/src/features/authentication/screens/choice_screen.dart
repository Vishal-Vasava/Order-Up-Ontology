import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly_ecom/src/constants/app_assets.dart';
import 'package:orderly_ecom/src/features/authentication/domain/auth_role_enum.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';

class ChoiceScreen extends StatelessWidget {
  const ChoiceScreen({super.key});
  static ValueNotifier<String> checkIsCustomer = ValueNotifier<String>('');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AppAssets.backgroundImage,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                AppLocalizations.of(context)!.hi,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: AppColor.textColor,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                AppLocalizations.of(context)!.choice_screen,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ValueListenableBuilder(
                    valueListenable: checkIsCustomer,
                    builder: (context, String value, child) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              checkIsCustomer.value = AuthRole.consumer.name;
                            },
                            child: DottedBorder(
                              borderType: BorderType.Circle,
                              dashPattern: const [10, 20],
                              strokeWidth: 2,
                              color: value == AuthRole.consumer.name
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: Image(
                                  image: AssetImage(
                                    AppAssets.customerOrangeIcon,
                                  ),
                                  height: 90.0,
                                  width: 90.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.customer,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ValueListenableBuilder(
                    valueListenable: checkIsCustomer,
                    builder: (context, String value, child) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              checkIsCustomer.value = AuthRole.producer.name;
                            },
                            child: DottedBorder(
                              borderType: BorderType.Circle,
                              dashPattern: const [10, 20],
                              strokeWidth: 2,
                              color: value == AuthRole.producer.name
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: Image(
                                  image: AssetImage(
                                    AppAssets.managerOrangeIcon,
                                  ),
                                  height: 90.0,
                                  width: 90.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.manager,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ValueListenableBuilder(
                    valueListenable: checkIsCustomer,
                    builder: (context, String value, child) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              checkIsCustomer.value = AuthRole.agent.name;
                            },
                            child: DottedBorder(
                              borderType: BorderType.Circle,
                              dashPattern: const [10, 20],
                              strokeWidth: 2,
                              color: value == AuthRole.agent.name
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: Image(
                                  image: AssetImage(
                                    AppAssets.deliveryOrangeIcon,
                                  ),
                                  height: 90.0,
                                  width: 90.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.delivery,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CupertinoButton(
                minSize: 55.0,
                padding: EdgeInsets.zero,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  // context.read<AuthCubit>().login(
                  //       login: Login(
                  //         userType: AuthRole.consumer.name,
                  //         firebaseId: 'firebaseId',
                  //         fcmId: 'fcmId',
                  //         deviceId: 'deviceId',
                  //         isGoogle: false,
                  //         isApple: false,
                  //         isGuest: false,
                  //       ),
                  //     );
                  if (checkIsCustomer.value.isNotEmpty) {
                    HapticFeedback.lightImpact();
                    context.pushNamed(AppRoute.signIn.toName,
                        params: {'role': checkIsCustomer.value});
                  } else {
                    showSnackBar(
                      context: context,
                      title: 'Oops',
                      message: 'Please select one option'.hardcoded,
                      snackbarType: SnackbarType.error,
                    );
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.started,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
