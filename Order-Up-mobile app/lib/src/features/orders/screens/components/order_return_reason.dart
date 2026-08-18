import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/orders/domain/order.dart';
import 'package:orderly_ecom/src/features/orders/screens/cubit/order_cubit.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';

class OrderReturnDropDown extends StatefulWidget {
  const OrderReturnDropDown({
    super.key,
    required this.orderItemData,
    required this.productData,
    required this.orderId,
    required this.returnPolicyData,
  });

  final OrderItem orderItemData;
  final ProductItems productData;
  final String orderId;
  final ReturnPolicyItems returnPolicyData;

  @override
  State<OrderReturnDropDown> createState() => _OrderReturnDropDownState();
}

class _OrderReturnDropDownState extends State<OrderReturnDropDown> {
  final ValueNotifier<String> estimateNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    context.read<OrderCubit>().getReturnProductReasonById(
          id: widget.orderItemData.producer ?? '',
          type: widget.returnPolicyData.code == 'RETURN' ? 'RT' : 'RP',
        );
  }

  // OrderReturnReplaceLoadedState

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderReturnReplaceLoadedState) {
          context.pop();
          showSnackBar(
            context: context,
            title: 'Successful',
            message: widget.returnPolicyData.code == 'RETURN'
                ? 'Order Return Request'
                : 'Order Replace Request',
            snackbarType: SnackbarType.success,
          );
        }
      },
      buildWhen: (_, newState) {
        return newState is OrderReturnReasonLoadingState ||
            newState is OrderReturnReasonLoadedState ||
            newState is OrderReturnReasonFailedState;
      },
      builder: (context, state) {
        if (state is OrderReturnReasonLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is OrderReturnReasonLoadedState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.returnPolicyData.code == 'RETURN'
                    ? 'Return Reason'
                    : 'Replace Reason',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: AppColor.blackColor60,
                    ),
              ),
              gapH8,
              DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.only(right: 10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: AppColor.scaleGreyColor,
                    ), //custom color
                    child: ValueListenableBuilder(
                      valueListenable: estimateNotifier,
                      builder:
                          (BuildContext context, String value, Widget? child) {
                        return ButtonTheme(
                          buttonColor: Colors.white,
                          alignedDropdown: true,
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            itemHeight: 50,
                            menuMaxHeight: 300.0,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            // validator: (value) {
                            //   if (value == null) {
                            //     return 'Please select one estimate';
                            //   }
                            //   if (value.isEmpty) {
                            //     return 'Please select one estimate';
                            //   }
                            //   return null;
                            // },
                            icon: const Icon(
                              kIsWeb
                                  ? Icons.arrow_circle_down
                                  : Iconsax.arrow_circle_down,
                              size: 20.0,
                              color: AppColor.blackColor,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              fillColor: Colors.grey.shade200,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: '   Please Select Reason'.hardcoded,
                            ),
                            value: value.isEmpty ? null : value,
                            onChanged: (data) {
                              estimateNotifier.value = data!;
                              log(estimateNotifier.value,
                                  name: 'CHANGED VALUE>>>>>>>>>>>>');
                            },
                            items: state.productReasonList.data
                                .map<DropdownMenuItem>(
                              (value) {
                                return DropdownMenuItem(
                                  value: value.title,
                                  child: Text(
                                    value.title,
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              gapH32,
              ElevatedButton(
                onPressed: () {
                  context.read<OrderCubit>().returnReplaceOrder(
                        status: widget.returnPolicyData.code == 'RETURN'
                            ? 'returned'
                            : 'replaced',
                        reason: estimateNotifier.value,
                        order: widget.orderId,
                        orderItem: widget.orderItemData.id ?? '',
                      );
                },
                child: Text(
                  'Submit',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
