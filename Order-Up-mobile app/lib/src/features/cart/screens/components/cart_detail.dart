import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:orderly_ecom/src/constants/app_assets.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/authentication/domain/auth_role_enum.dart';
import 'package:orderly_ecom/src/features/cart/screens/cubit/cart_cubit.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/widgets/app_button.dart';

class CartDetail extends StatelessWidget {
  const CartDetail({
    super.key,
    required this.fromCheckout,
    required this.onPressed,
    this.isRazorPay = true,
  });
  final bool fromCheckout;
  final bool isRazorPay;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (_, newState) {
        return newState is CartLoadedState || newState is CartFailedState;
      },
      builder: (context, state) {
        if (state is CartFailedState) {
          return const SizedBox.shrink();
        }
        if (state is CartLoadedState) {
          if (state.cartList.isNotEmpty) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              margin: fromCheckout
                  ? const EdgeInsets.symmetric(horizontal: 12.0)
                  : const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: AppColor.primaryColor.withOpacity(0.2),
                boxShadow: fromCheckout
                    ? null
                    : const [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 25.0,
                          spreadRadius: 50.0,
                          color: AppColor.blackColor5,
                        ),
                      ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.sub_total,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.textColor,
                                  ),
                        ),
                        Text(
                          '${context.read<CartCubit>().currency.getCurrencyPerLocale} ${context.read<CartCubit>().subTotal.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.textColor,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  //Conveyance fee
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.con_fee,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.textColor,
                                  ),
                        ),
                        Text(
                          '${context.read<CartCubit>().currency.getCurrencyPerLocale} ${context.read<CartCubit>().conveyanceFee}',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.textColor,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible:
                        context.read<CartCubit>().deliverySlot == 'morning',
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.urgent_amount,
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.textColor,
                                    ),
                          ),
                          Text(
                            '${context.read<CartCubit>().currency.getCurrencyPerLocale} ${context.read<CartCubit>().chargeAmount}',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.textColor,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.total,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.textColor,
                                  ),
                        ),
                        Text(
                          '${context.read<CartCubit>().currency.getCurrencyPerLocale} ${context.read<CartCubit>().cartTotal.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.textColor,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  //delivery time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: !fromCheckout,
                        replacement: Container(
                          height: isRazorPay ? 25.0 : 30.0,
                          width: 100.0,
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                                color: AppColor.primaryColor, width: 1.5),
                            boxShadow: const [
                              BoxShadow(
                                spreadRadius: 1.0,
                                blurRadius: 20.0,
                                color: AppColor.kShadowColor,
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage(
                                  isRazorPay
                                      ? AppAssets.razorpayLogo
                                      : AppAssets.stripeLogo,
                                ),
                              ),
                            ],
                          ),
                        ),
                        child: inject
                                .get<AuthLocalRepository>()
                                .guestAccessToken
                                .isNotEmpty
                            ? const Center()
                            : SizedBox(
                                height: 40.0,
                                width: 200.0,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    side: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 1),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                  ),
                                  onPressed: onPressed,
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .select_delivery_option,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      Text(
                        () {
                          if (context.read<CartCubit>().deliverySlot ==
                              'morning') {
                            return DateFormat('yyyy-MM-dd')
                                .format(DateTime.now());
                          }
                          return context.read<CartCubit>().deliveryDate ?? '';
                        }(),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              color: AppColor.textColor,
                            ),
                      ),
                    ],
                  ),
                  ValueListenableBuilder(
                    valueListenable:
                        inject.get<AuthLocalRepository>().authBox.listenable(),
                    builder: (BuildContext context, Box<dynamic> value,
                        Widget? child) {
                      if (inject
                          .get<AuthLocalRepository>()
                          .guestAccessToken
                          .isNotEmpty) {
                        return Text(
                          'Since you are in Guest mode, we require you to login before placing order.',
                          style: Theme.of(context).textTheme.bodySmall,
                        );
                      }
                      return Container();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: AppButton(
                      isLoading: false,
                      onPressed: () {
                        if (inject
                            .get<AuthLocalRepository>()
                            .guestAccessToken
                            .isNotEmpty) {
                          context.pushNamed(
                            AppRoute.signIn.toName,
                            params: {
                              'role': AuthRole.consumer.name,
                            },
                            extra: {
                              'isGuest': true,
                            },
                          );
                          showSnackBar(
                            context: context,
                            title: 'Please login to proceed',
                            message: 'Login to continue',
                            snackbarType: SnackbarType.warning,
                          );
                        } else {
                          if (fromCheckout) {
                            return onPressed?.call();
                          }
                          if (context.read<CartCubit>().deliverySlot.isEmpty) {
                            showSnackBar(
                              context: context,
                              title: AppLocalizations.of(context)!
                                  .select_delivery_option,
                              message: 'Try again!.',
                              snackbarType: SnackbarType.error,
                            );
                            return;
                          }
                          if (context.read<CartCubit>().deliverySlot ==
                              'evening') {
                            if (context.read<CartCubit>().deliveryDate ==
                                null) {
                              showSnackBar(
                                context: context,
                                title: AppLocalizations.of(context)!
                                    .choose_delivery_time,
                                message: 'Try again!.',
                                snackbarType: SnackbarType.error,
                              );
                              return;
                            }
                          }
                          context.pushNamed(
                            AppRoute.destinationAddress.toName,
                          );
                        }
                      },
                      buttonText: fromCheckout
                          ? AppLocalizations.of(context)!.proceed_pay
                          : inject
                                  .get<AuthLocalRepository>()
                                  .guestAccessToken
                                  .isEmpty
                              ? AppLocalizations.of(context)!.place_order
                              : 'Login to Place Order',
                    ),
                  )
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}
