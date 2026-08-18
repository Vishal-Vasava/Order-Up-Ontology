import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/domain/manager_order_detail.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/screens/cubit/manager_order_cubit.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:orderly_ecom/src/widgets/image_builder.dart';

class OrderProductCard extends StatelessWidget {
  const OrderProductCard({
    super.key,
    required this.modelData,
    required this.orderStatus,
    required this.managerOrderDetail,
  });
  final OrderItem modelData;
  final ManagerOrderDetail managerOrderDetail;
  final String orderStatus;
  @override
  Widget build(BuildContext context) {
    final bool isCheckbox = !(orderStatus == 'delivered' ||
        orderStatus == 'returned' ||
        orderStatus == 'cancelled' ||
        orderStatus == 'rejected' ||
        orderStatus == 'shipped' ||
        orderStatus == 'returned');

    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      margin: const EdgeInsets.symmetric(vertical: kBorderRadius),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: AppColor.scaleGreyColor,
            spreadRadius: 4.5,
            blurRadius: 4.5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          ImageBuilder(
            imageUrl: modelData.productImageUrl ?? '',
            height: 100.0,
            width: 90.0,
            fitType: BoxFit.contain,
          ),
          gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Name : ',
                    style: Theme.of(context).textTheme.titleSmall,
                    children: [
                      TextSpan(
                        text: modelData.productName ?? '',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: AppColor.primaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
                gapH4,
                RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: 'Desc : ',
                    style: Theme.of(context).textTheme.titleSmall,
                    children: [
                      TextSpan(
                        text: 'Desc',
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: AppColor.primaryColor,
                                ),
                      ),
                    ],
                  ),
                ),
                gapH4,
                RichText(
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: 'Price : ',
                    style: Theme.of(context).textTheme.titleSmall,
                    children: [
                      TextSpan(
                        text:
                            '${managerOrderDetail.currency?.locale?.getCurrencyPerLocale} ${modelData.price}',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: AppColor.primaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
                gapH4,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: 'Quantity : ',
                        style: Theme.of(context).textTheme.titleSmall,
                        children: [
                          TextSpan(
                            text: modelData.qty?.toString() ?? '',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: AppColor.primaryColor,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    if (isCheckbox)
                      Checkbox(
                        value: modelData.isChecked,
                        visualDensity: VisualDensity.compact,
                        onChanged: (value) {
                          context
                              .read<ManagerOrderCubit>()
                              .updateOrderListCheck(
                                value: value!,
                                productId: modelData.id!,
                              );
                        },
                      ),
                  ],
                ),
                gapH4,
                if (orderStatus == 'cancelled' || orderStatus == 'rejected')
                  RichText(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: 'Order Type : ',
                      style: Theme.of(context).textTheme.titleSmall,
                      children: [
                        TextSpan(
                          text: orderStatus,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: AppColor.primaryColor,
                                  ),
                        ),
                      ],
                    ),
                  ),
                if (orderStatus == 'cancelled' || orderStatus == 'rejected')
                  gapH4,
                if (orderStatus == 'cancelled' || orderStatus == 'rejected')
                  RichText(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: 'Cancel Reason : ',
                      style: Theme.of(context).textTheme.titleSmall,
                      children: [
                        TextSpan(
                          text: modelData.cancelReason ?? '',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: AppColor.primaryColor,
                                  ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
