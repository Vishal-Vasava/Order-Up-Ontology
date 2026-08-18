import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/delivery/screens/cubit/delivery_cubit.dart';
import 'package:orderly_ecom/src/features/delivery/screens/widgets/delivery_address_card.dart';
import 'package:orderly_ecom/src/features/delivery/screens/widgets/delivery_detail_card.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';

class DeliveryOrderDetailScreen extends StatelessWidget {
  const DeliveryOrderDetailScreen({
    super.key,
    required this.orderDetailId,
    required this.orderStatus,
  });
  final String orderDetailId;
  final String orderStatus;
  static final ValueNotifier<String> orderStatusValue =
      ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<List<String>> selectedOrderId =
        ValueNotifier<List<String>>([]);
    List<String> orderIdList = [];

    // List<OrderItem> orderItem = [];
    context.read<DeliveryCubit>().orderDetail(orderDetailId: orderDetailId);
    return BlocConsumer<DeliveryCubit, DeliveryState>(
      listenWhen: (_, newState) {
        return newState is DeliveryDetailFetchingState ||
            newState is DeliveryDetailFetchedState ||
            newState is DeliveryDetailFailedState;
      },
      listener: (context, state) {
        if (state is DeliveryDetailFetchedState) {
          orderStatusValue.value = '';
          // state.deliveryOrderDetail.currentStatus!.toOrderStatus;
        }
      },
      buildWhen: (_, newState) {
        return newState is DeliveryDetailFetchingState ||
            newState is DeliveryDetailFetchedState ||
            newState is DeliveryDetailFailedState;
      },
      builder: (context, state) {
        if (state is DeliveryDetailFetchingState) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (state is DeliveryDetailFailedState) {
          return Center(
            child: Text(
              state.message,
            ),
          );
        }

        if (state is DeliveryDetailFetchedState) {
          // for (int i = 0;
          //     i < state.deliveryOrderDetail.orderItems!.length;
          //     i++) {
          //   if (state.deliveryOrderDetail.orderItems![i].status ==
          //       'delivered') {
          //     orderItem.add(state.deliveryOrderDetail.orderItems![i]);
          //   }
          // }
          // orderItem = state.deliveryOrderDetail.orderItems!;
          return Scaffold(
            appBar: OrderlyAppBar(
              title: AppLocalizations.of(context)!.order_detail,
            ),
            body: ListView(
              padding: const EdgeInsets.all(kDefaultPadding),
              physics: const BouncingScrollPhysics(),
              children: [
                gapH12,
                if (state.deliveryOrderDetail.srcAddress != null)
                  DeliveryAddressCard(
                    modelData: state.deliveryOrderDetail.srcAddress!,
                    title: 'Source Address',
                  ),
                gapH12,
                InkWell(
                  onTap: () {
                    log(orderStatus, name: 'ORDER STATYS');
                  },
                  child: DeliveryAddressCard(
                    modelData: state.deliveryOrderDetail.destAddress!,
                    title: 'Destination Address',
                  ),
                ),
                gapH12,
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  padding: EdgeInsets.zero,
                  itemCount: state.deliveryOrderDetail.orderItems?.length ?? 0,
                  itemBuilder: (c, i) {
                    return DeliveryDetailCard(
                      modelData: state.deliveryOrderDetail.orderItems![i],
                      orderStatus: orderStatus,
                      onChanged: (bool? value) {
                        // if (state.deliveryOrderDetail.orderItems![i]
                        //         .currentStatus ==
                        //     3) {
                        //   return;
                        // }
                        log(orderStatus, name: 'ORDER STATYS');
                        context.read<DeliveryCubit>().updateOrderListCheck(
                              value: value!,
                              index: i,
                              status: state
                                  .deliveryOrderDetail.orderItems![i].isChecked,
                            );

                        if (value) {
                          state.deliveryOrderDetail.orderItems![i].isChecked ==
                              true;
                          orderIdList.add(
                              state.deliveryOrderDetail.orderItems![i].id!);
                        } else {
                          state.deliveryOrderDetail.orderItems![i].isChecked ==
                              false;
                          orderIdList.remove(
                              state.deliveryOrderDetail.orderItems![i].id);
                        }
                        selectedOrderId.value = [];
                        for (final element in orderIdList) {
                          selectedOrderId.value.add(element);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
            bottomNavigationBar: ValueListenableBuilder(
              valueListenable: orderStatusValue,
              builder: (BuildContext context, String value, Widget? child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: BlocConsumer<DeliveryCubit, DeliveryState>(
                        listenWhen: (_, newState) {
                          return newState is DeliveryUpdateFailedState ||
                              newState is DeliveryUpdateSuccessState ||
                              newState is DeliveryUpdateLoadingState;
                        },
                        buildWhen: (_, newState) {
                          return newState is DeliveryUpdateFailedState ||
                              newState is DeliveryUpdateSuccessState ||
                              newState is DeliveryUpdateLoadingState;
                        },
                        listener: (context, state) {
                          if (state is DeliveryUpdateFailedState) {
                            showSnackBar(
                              context: context,
                              title: 'Oops',
                              message: state.message,
                              snackbarType: SnackbarType.error,
                            );
                          }
                          if (state is DeliveryUpdateSuccessState) {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                            showSnackBar(
                              context: context,
                              title: 'Success',
                              message: 'Order updated Successfully',
                              snackbarType: SnackbarType.success,
                            );
                          }
                        },
                        builder: (context, state) {
                          return Visibility(
                            visible: orderStatus == 'delivered' ? false : true,
                            child: CupertinoButton(
                              onPressed: value
                                      .toLowerCase()
                                      .contains('delivered')
                                  ? null
                                  : () async {
                                      if (selectedOrderId.value.isEmpty) {
                                        showSnackBar(
                                          context: context,
                                          title: 'Warning',
                                          message:
                                              'Please select at lease one item',
                                          snackbarType: SnackbarType.warning,
                                        );
                                        return;
                                      }

                                      await context
                                          .read<DeliveryCubit>()
                                          .updateOrderStatus(
                                            orderDetailId:
                                                selectedOrderId.value,
                                            status: orderStatus == 'returned'
                                                ? 'return_pickup'
                                                : orderStatus == 'replaced'
                                                    ? 'replace_confirmed'
                                                    : 'delivered',
                                          );

                                      /// return_pickup
                                      /// replace_pickup
                                    },
                              color: AppColor.primaryColor,
                              child: Center(
                                child: Text(
                                  // AppLocalizations.of(context)!.mark_delivered,
                                  orderStatus == 'returned'
                                      ? 'Mark as Return Pickup'
                                      : orderStatus == 'replaced'
                                          ? 'Mark as Replace Confirmed'
                                          : 'Mark as Delivered',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
