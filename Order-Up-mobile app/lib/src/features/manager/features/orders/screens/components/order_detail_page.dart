import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/screens/components/order_cancel_sheet.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/screens/components/order_customer_info.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/screens/components/order_product_list.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/screens/components/order_status_dropdown.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/screens/cubit/manager_order_cubit.dart';
import 'package:orderly_ecom/src/utils/clippers.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:orderly_ecom/src/widgets/app_button.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/widgets/app_dialog.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({
    super.key,
    required this.orderId,
    required this.orderNumber,
    required this.orderStatus,
  });
  final String orderId;
  final String orderNumber;
  final String orderStatus;

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final ValueNotifier<String> statusNotifier = ValueNotifier<String>('');
  List<String> cancelReason = [];
  @override
  void initState() {
    super.initState();
    log(widget.orderStatus, name: 'ORDER STATUS>>>>>>>>>>>');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (context.mounted) {
        await context.read<ManagerOrderCubit>().getOrderDetail(
              orderId: widget.orderId,
              status: widget.orderStatus,
            );
        if (context.mounted) {
          cancelReason =
              await context.read<ManagerOrderCubit>().getCancelReason();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderlyAppBar(
        title: 'Order Details',
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: 'Order Id : ',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                children: [
                  TextSpan(
                    text: widget.orderNumber,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),
            gapH8,
            CustomPaint(
              painter: DashedLinePainter(dashSpace: 3),
              size: const Size(double.infinity, 4),
            ),
            const OrderCustomerInfo(),
            CustomPaint(
              painter: DashedLinePainter(dashSpace: 3),
              size: const Size(double.infinity, 4),
            ),
            Expanded(
              child: OrderProductList(orderStatus: widget.orderStatus),
            ),
            gapH8,
            CustomPaint(
              painter: DashedLinePainter(dashSpace: 3),
              size: const Size(double.infinity, 4),
            ),
            gapH8,

            /// BOTTOM UI
            Visibility(
              visible: widget.orderStatus != 'delivered' &&
                  widget.orderStatus != 'cancelled' &&
                  widget.orderStatus != 'rejected' &&
                  widget.orderStatus != 'returned' &&
                  widget.orderStatus != 'shipped' &&
                  widget.orderStatus != 'return_pickup' &&
                  widget.orderStatus != 'replace_pickup' &&
                  widget.orderStatus != 'return_confirmed' &&
                  widget.orderStatus != 'replace_confirmed' &&
                  widget.orderStatus != 'replaced',
              child: OrderStatusDropdown(
                orderStatus: widget.orderStatus,
                onChanged: (value) {
                  statusNotifier.value = value;
                },
              ),
            ),
            gapH12,
            Visibility(
              visible: widget.orderStatus != 'delivered' &&
                  widget.orderStatus != 'cancelled' &&
                  widget.orderStatus != 'rejected' &&
                  widget.orderStatus != 'returned' &&
                  widget.orderStatus != 'shipped' &&
                  widget.orderStatus != 'return_confirmed' &&
                  widget.orderStatus != 'replace_confirmed',
              child: BlocConsumer<ManagerOrderCubit, ManagerOrderState>(
                listenWhen: (_, newState) {
                  return newState is ManagerOrderStatusFailedState ||
                      newState is ManagerOrderStatusSuccessState;
                },
                listener: (context, state) {
                  if (state is ManagerOrderStatusFailedState) {
                    showSnackBar(
                      context: context,
                      title: 'Please try again',
                      message: state.message,
                      snackbarType: SnackbarType.error,
                    );
                  }
                  if (state is ManagerOrderStatusSuccessState) {
                    context.pop();
                    showSnackBar(
                      context: context,
                      title: 'Success',
                      message: 'Order has been updated.',
                      snackbarType: SnackbarType.success,
                    );
                  }
                },
                buildWhen: (_, newState) {
                  return newState is ManagerOrderStatusLoadingState ||
                      newState is ManagerOrderStatusFailedState ||
                      newState is ManagerOrderStatusSuccessState;
                },
                builder: (context, state) {
                  return AppButton(
                    isLoading: state is ManagerOrderStatusLoadingState,
                    buttonText: widget.orderStatus == 'return_pickup'
                        ? 'Mark As Returned Confirmed'
                        : widget.orderStatus == 'replace_pickup'
                            ? 'Mark As Replaced Confirmed'
                            : widget.orderStatus == 'replaced'
                                ? 'Mark As Replaced Pickup'
                                : AppLocalizations.of(context)!.submit,
                    onPressed: () async {
                      final checkedList = context
                          .read<ManagerOrderCubit>()
                          .managerOrderDetail
                          ?.orderItems!
                          .where((element) => element.isChecked);
                      List<String> orderDetailId = [];
                      for (final item in checkedList!.toList()) {
                        orderDetailId.add(item.id!);
                      }
                      String orderStatus = statusNotifier.value;

                      if (orderDetailId.isEmpty) {
                        showSnackBar(
                          context: context,
                          title: 'Please Select',
                          message: 'Select atleast one order',
                          positionTop: true,
                          snackbarType: SnackbarType.error,
                        );
                        return;
                      }

                      if (orderStatus == 'cancelled') {
                        AppDialog.showBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          child: OrderCancelSheet(
                            orderDetailIds: orderDetailId,
                            orderStatus: orderStatus,
                            reasonList: cancelReason,
                          ),
                        );
                      } else {
                        await context
                            .read<ManagerOrderCubit>()
                            .updateOrderStatus(
                              orderDetailId: orderDetailId,
                              orderStatus: widget.orderStatus == 'return_pickup'
                                  ? 'return_confirmed'
                                  : widget.orderStatus == 'replace_pickup'
                                      ? 'replace_confirmed'
                                      : widget.orderStatus == 'replaced'
                                          ? 'replace_pickup'
                                          : orderStatus,
                            );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
