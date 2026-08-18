import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly_ecom/src/features/cart/domain/cart.dart';
import 'package:orderly_ecom/src/features/cart/screens/cubit/cart_cubit.dart';
import 'package:orderly_ecom/src/features/cart/screens/widgets/cart_card.dart';
import 'package:orderly_ecom/src/features/location/data/location_local_repository.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/widgets/app_dialog.dart';
import 'package:orderly_ecom/src/widgets/confirmation_dialog.dart';
import 'package:orderly_ecom/src/widgets/default_error_screen.dart';
import 'package:orderly_ecom/src/widgets/shimmer.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';

class CartList extends StatelessWidget {
  const CartList({super.key, required this.items});
  final List<CartItem> items;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listenWhen: (_, newState) {
        return newState is CartAddFailedState ||
            newState is CartUpdateFailedState ||
            newState is CartDeleteFailedState ||
            newState is CartDeleteSuccessState;
      },
      listener: (context, state) {
        // FAILED STATES
        if (state is CartAddFailedState) {
          showSnackBar(
            context: context,
            title: 'Adding item failed',
            message: state.message,
            snackbarType: SnackbarType.error,
          );
        }
        if (state is CartDeleteFailedState) {
          showSnackBar(
            context: context,
            title: 'Deleting item failed',
            message: state.message,
            snackbarType: SnackbarType.error,
          );
        }
        if (state is CartUpdateFailedState) {
          showSnackBar(
            context: context,
            title: 'Updating item failed',
            message: state.message,
            snackbarType: SnackbarType.error,
          );
        }
        // SUCCESS STATE
        if (state is CartDeleteSuccessState) {
          showSnackBar(
            context: context,
            title: 'Success',
            message: 'Item has been deleted',
            snackbarType: SnackbarType.success,
          );
        }
      },
      buildWhen: (_, newState) {
        return newState is CartLoadedState ||
            newState is CartFailedState ||
            newState is CartLoadingState;
      },
      builder: (context, state) {
        if (state is CartFailedState) {
          return DefaultErrorScreen(
            message: state.message,
          );
        }
        if (state is CartLoadingState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ...List.generate(
                  4,
                  (index) => const AppShimmer(
                    height: 150.0,
                  ),
                ),
              ],
            ),
          );
        }
        if (state is CartLoadedState) {
          if (state.cartList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.no_data,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32.0),
                  CupertinoButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Continue Shopping'.hardcoded,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: AppColor.whiteColor,
                          ),
                    ),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              final latitude = inject.get<LocationLocalRepository>().latitude;
              final longitude = inject.get<LocationLocalRepository>().longitude;
              await context.read<CartCubit>().getCartList(
                    latitude: latitude,
                    longitude: longitude,
                  );
            },
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int i) {
                return CartCard(
                  fromCheckout: false,
                  modelData: items[i],
                  onDelete: () {
                    AppDialog.viewDialog(
                      context: context,
                      content: ConfirmationDialog(
                        title: 'Are you sure?'.hardcoded,
                        message: 'You want to delete this item from cart.',
                        onConfirm: () async {
                          HapticFeedback.mediumImpact();
                          context.pop();
                          await context.read<CartCubit>().deleteCart(
                                productId: items[i].product.id,
                              );
                        },
                        height: MediaQuery.of(context).size.width * 0.4,
                        width: MediaQuery.of(context).size.width * 0.8,
                      ),
                    );
                  },
                );
                // return Container(
                //   margin: const EdgeInsets.only(
                //       bottom: 20, left: 10, right: 10, top: 10),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     border: Border.all(
                //       color: AppColor.accentColor.withOpacity(0.4),
                //     ),
                //   ),
                //   child: ExpansionTile(
                //     initiallyExpanded: true,
                //     title: Row(
                //       children: [
                //         // RichText(
                //         //   text: TextSpan(
                //         //     text: 'Schedule : ',
                //         //     style: Theme.of(context).textTheme.titleMedium,
                //         //     children: const [
                //         // TextSpan(
                //         //   text: state.cartList[i].producer.schedule.days,
                //         //   style: Theme.of(context).textTheme.titleSmall,
                //         // )
                //         //     ],
                //         //   ),
                //         // ),
                //         TextButton(
                //           onPressed: () {
                //             AppDialog.showBottomSheet(
                //               context: context,
                //               child: const CartAddDeliveryTime(),
                //             );
                //           },
                //           child: const Text(
                //             'Select Time Slot',
                //           ),
                //         ),
                //       ],
                //     ),
                //     children: List.generate(
                //       state.cartList[i].items.length,
                //       (index) => CartCard(
                //         fromCheckout: false,
                //         modelData: state.cartList[i].items[index],
                //         onDelete: () {
                //           AppDialog.viewDialog(
                //             context: context,
                //             content: ConfirmationDialog(
                //               title: 'Are you sure?'.hardcoded,
                //               message:
                //                   'You want to delete this item from cart.',
                //               onConfirm: () async {
                //                 HapticFeedback.mediumImpact();
                //                 context.pop();
                //                 await context.read<CartCubit>().deleteCart(
                //                       productId: state
                //                           .cartList[i].items[index].product.id,
                //                     );
                //               },
                //               height: MediaQuery.of(context).size.width * 0.4,
                //               width: MediaQuery.of(context).size.width * 0.8,
                //             ),
                //           );
                //         },
                //       ),
                //     ),
                //   ),
                // );
                // // return CartCard(
                // //   fromCheckout: false,
                // //   modelData: state.cartList[index],
                // //   onDelete: () {
                // //     AppDialog.viewDialog(
                // //       context: context,
                // //       content: ConfirmationDialog(
                // //         title: 'Are you sure?'.hardcoded,
                // //         message: 'You want to delete this item from cart.',
                // //         onConfirm: () async {
                // //           HapticFeedback.mediumImpact();
                // //           context.pop();
                // //           // await context.read<CartCubit>().deleteCart(
                // //           //       productId: state.cartList[index].product!.id!,
                // //           //     );
                // //         },
                // //         height: MediaQuery.of(context).size.width * 0.4,
                // //         width: MediaQuery.of(context).size.width * 0.8,
                // //       ),
                // //     );
                // //   },
                // // );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
