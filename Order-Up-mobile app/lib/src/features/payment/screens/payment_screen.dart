// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly_ecom/src/features/address/screens/cubit/address_cubit.dart';
import 'package:orderly_ecom/src/features/address/screens/widgets/address_card.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/cart/screens/components/cart_detail.dart';
import 'package:orderly_ecom/src/features/cart/screens/cubit/cart_cubit.dart';
import 'package:orderly_ecom/src/features/navigation_bar/screens/cubit/navigation_cubit.dart';
import 'package:orderly_ecom/src/features/payment/data/payment.dart';
import 'package:orderly_ecom/src/features/payment/screens/cubit/payment_cubit.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/services/crashlytics/crash_service.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/features/cart/domain/cart_place_order.dart';
import 'package:razorpay_web/razorpay_web.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String addressDestinationId = '';

  bool isRazorPay = true;

  @override
  void initState() {
    super.initState();
    Payment().initState();
    log(context.read<CartCubit>().destinationId.toString());
    Payment.razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    Payment.razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    Payment.razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    countryChecker();
  }

  void countryChecker() {
    final addressCubit = context.read<AddressCubit>();
    final cartCubit = context.read<CartCubit>();
    final country = addressCubit.addressList
        .firstWhere((e) => e.id! == cartCubit.destinationId)
        .country!
        .toLowerCase();

    isRazorPay = country == 'india' || country == 'in';
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      final cubit = context.read<CartCubit>();
      final paymentId = response.paymentId.toString();
      final placeOrder = CartPlaceOrder(
        deliveryDate: cubit.deliveryDate!,
        deliveryType: cubit.deliverySlot == 'morning'
            ? 'urgent'
            : cubit.deliverySlot == 'evening'
                ? 'planned'
                : 'default',
        deliverySlot: cubit.deliverySlot,
        destAddressId: cubit.destinationId.toString(),
        discount: '0',
        paymentTransactionId: paymentId,
        paymentMode: 'RazorPay',
      );
      await context.read<CartCubit>().placeOrder(placeOrder: placeOrder);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (context.mounted) {
      showSnackBar(
        context: context,
        title: response.message ?? '',
        message: 'Payment has been cancelled',
        snackbarType: SnackbarType.error,
      );
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (context.mounted) {
      showSnackBar(
        context: context,
        title: response.walletName ?? '',
        message: 'EXTERNAL_WALLET: ${response.walletName!}',
        snackbarType: SnackbarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderlyAppBar(
        title: AppLocalizations.of(context)!.payment,
      ),
      bottomNavigationBar: BlocConsumer<CartCubit, CartState>(
        listenWhen: (oldState, newState) {
          return newState is CartPlaceOrderFailedState ||
              newState is CartPlaceOrderSuccessState;
        },
        listener: (c, state) {
          if (state is CartPlaceOrderFailedState) {
            showSnackBar(
              context: context,
              title: 'Please try again',
              message: state.message,
              snackbarType: SnackbarType.error,
            );
          }
          if (state is CartPlaceOrderSuccessState) {
            context.read<NavigationCubit>().changeIndex(index: 0);
            while (context.canPop()) {
              context.pop();
            }
            showSnackBar(
              context: context,
              title: AppLocalizations.of(context)!.order_success,
              message: 'Thank you',
              snackbarType: SnackbarType.success,
            );
          }
        },
        buildWhen: (_, newState) {
          return newState is CartLoadedState ||
              newState is CartFailedState ||
              newState is CartLoadingState;
        },
        builder: (c, i) {
          return BlocConsumer<PaymentCubit, PaymentState>(
            listenWhen: (_, newState) {
              return newState is PaymentFailedState ||
                  newState is PaymentLoadingState ||
                  newState is PaymentSuccessState;
            },
            listener: (_, state) {
              if (state is PaymentFailedState) {
                showSnackBar(
                  context: context,
                  title: 'Please try again',
                  message: state.message,
                  snackbarType: SnackbarType.error,
                );
              }
              if (state is PaymentSuccessState) {
                context.read<NavigationCubit>().changeIndex(index: 0);
                while (context.canPop()) {
                  context.pop();
                }
                showSnackBar(
                  context: context,
                  title: AppLocalizations.of(context)!.order_success,
                  message: 'Thank you',
                  snackbarType: SnackbarType.success,
                );
              }
            },
            buildWhen: (_, newState) {
              return newState is PaymentFailedState ||
                  newState is PaymentLoadingState ||
                  newState is PaymentSuccessState;
            },
            builder: (context, state) {
              return SlideInRight(
                child: CartDetail(
                  fromCheckout: true,
                  isRazorPay: isRazorPay,
                  onPressed: (state is PaymentLoadingState)
                      ? null
                      : () async {
                          try {
                            final cartCubit = context.read<CartCubit>();
                            final paymentCubit = context.read<PaymentCubit>();
                            // for COD
                            // const paymentId = 'COD';
                            // final placeOrder = CartPlaceOrder(
                            //   deliveryDate: cubit.deliveryDate!,
                            //   deliveryType: cubit.deliverySlot == 'morning'
                            //       ? 'urgent'
                            //       : cubit.deliverySlot == 'evening'
                            //           ? 'planned'
                            //           : 'default',
                            //   deliverySlot: cubit.deliverySlot,
                            //   destAddressId: cubit.destinationId.toString(),
                            //   discount: '0',
                            //   paymentTransactionId: paymentId,
                            //   paymentMode: 'COD',
                            // );
                            // await context
                            //     .read<CartCubit>()
                            //     .placeOrder(placeOrder: placeOrder);

                            if (isRazorPay) {
                              await Payment.openCheckout(
                                cartTotal: cartCubit.cartTotal,
                                userMobileNumber: inject
                                        .get<AuthLocalRepository>()
                                        .userBox
                                        .values
                                        .elementAt(0)
                                        .phone ??
                                    '',
                                userEmailId: inject
                                        .get<AuthLocalRepository>()
                                        .userBox
                                        .values
                                        .elementAt(0)
                                        .email ??
                                    '',
                              );
                            } else {
                              await paymentCubit.openStripeCheckout(
                                context: context,
                                successUrl: 'https://dev.order-up.in/thankYou',
                                cancelUrl: 'https://dev.order-up.in/cancel',
                                deliveryType:
                                    cartCubit.deliverySlot == 'morning'
                                        ? 'urgent'
                                        : cartCubit.deliverySlot == 'evening'
                                            ? 'planned'
                                            : 'default',
                                deliveryDate: cartCubit.deliveryDate!,
                                deliverySlot: cartCubit.deliverySlot,
                                destinationAddressId:
                                    cartCubit.destinationId.toString(),
                              );
                            }

                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (_) => const CheckoutScreenExample(),
                            //   ),
                            // );
                          } catch (e) {
                            showSnackBar(
                              context: context,
                              title: 'Payment Failed',
                              message: e.toString(),
                              snackbarType: SnackbarType.error,
                            );
                            inject.get<CrashService>().logError(
                                  exception: e,
                                  errorMessage: 'Payment failed',
                                );
                          }
                        },
                ),
              );
            },
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<CartCubit, CartState>(
              buildWhen: (_, newState) {
                return newState is CartLoadedState ||
                    newState is CartFailedState ||
                    newState is CartLoadingState;
              },
              builder: (context, state) {
                // if (state is CartLoadedState) {
                //   return Expanded(
                //     child: ListView.builder(
                //       itemCount: state.cartList.length,
                //       shrinkWrap: true,
                //       primary: false,
                //       itemBuilder: (c, i) {
                //         return CartCard(
                //           fromCheckout: true,
                //           onDelete: () async {
                //             await context.read<CartCubit>().deleteCart(
                //                   productId: state.cartList[i].product!.id!,
                //                 );
                //           },
                //           modelData: state.cartList[i],
                //         );
                //       },
                //     ),
                //   );
                // }
                return const SizedBox.shrink();
              },
            ),
            BlocBuilder<AddressCubit, AddressState>(
              buildWhen: (_, newState) {
                return newState is AddressLoadedState;
              },
              builder: (context, state) {
                if (state is AddressLoadedState) {
                  final addressData = state.addressList
                      .firstWhere((e) => e.id! == state.destinationAddressId!);
                  addressDestinationId = state.destinationAddressId!;
                  return ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: EdgeInsets.zero,
                    title: Text(
                      '${AppLocalizations.of(context)!.ship_here} :',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    children: [
                      AddressCard(
                        showButton: false,
                        modelData: addressData,
                        selectedAddressId: state.destinationAddressId!,
                        onTap: () {
                          context.read<AddressCubit>().selectAddress(
                              destinationAddressId: addressData.id!);
                        },
                        onDelete: () {},
                        onEdit: () {
                          context.pushNamed(AppRoute.editAddress.toName,
                              params: {'addressId': addressData.id!});
                        },
                      )
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
