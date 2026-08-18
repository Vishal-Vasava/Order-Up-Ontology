import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:orderly_ecom/src/constants/app_assets.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/navigation_bar/screens/cubit/navigation_cubit.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/widgets/app_button.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';

class ThankyouScreen extends StatelessWidget {
  const ThankyouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.backgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  if (kIsWeb)
                    Image(
                      height: 300.0,
                      image: AssetImage(
                        AppAssets.successPaymentImage,
                      ),
                    )
                  else
                    LottieBuilder.asset(
                      AppAssets.paymentSuccess,
                    ),
                  Text(
                    'Payment Success.',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: AppColor.successColor,
                        ),
                  ),
                  gapH12,
                  Text(
                    'You can now close this page and continue shopping.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColor.darkGreyColor,
                        ),
                  ),
                  gapH24,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50.0,
                        width: 150.0,
                        child: AppButton(
                          isLoading: false,
                          buttonText: 'Home',
                          onPressed: () {
                            context
                                .read<NavigationCubit>()
                                .changeIndex(index: 0);
                            while (context.canPop()) {
                              context.pop();
                            }
                            showSnackBar(
                              context: context,
                              title:
                                  AppLocalizations.of(context)!.order_success,
                              message: 'Thank you',
                              snackbarType: SnackbarType.success,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
