import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/screens/cubit/manager_order_cubit.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OrderCustomerInfo extends StatelessWidget {
  const OrderCustomerInfo({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManagerOrderCubit, ManagerOrderState>(
      buildWhen: (_, newState) {
        return newState is ManagerOrderDetailLoadedState;
      },
      builder: (context, state) {
        if (state is ManagerOrderDetailLoadedState) {
          return ExpansionTile(
            childrenPadding: EdgeInsets.zero,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 1.5,
                  width: 40.0,
                  color: AppColor.greyDarkColor,
                ),
                gapW12,
                Center(
                  child: Text(
                    'Customer Detail'.hardcoded,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                gapW12,
                Container(
                  height: 1.5,
                  width: 40.0,
                  color: AppColor.greyDarkColor,
                ),
              ],
            ),
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        kIsWeb ? Icons.person : Iconsax.user,
                        color: AppColor.accentColor,
                        size: 20.0,
                      ),
                      Container(
                        height: 20,
                        width: 1.5,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        color: Colors.red,
                      ),
                      Text(
                        'Name : ',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        state.orderDetail!.customer?.firstName ?? '',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  gapH16,
                  Row(
                    children: [
                      const Icon(
                        kIsWeb ? Icons.phone : Iconsax.mobile,
                        color: AppColor.successColor,
                        size: 20.0,
                      ),
                      Container(
                        height: 20,
                        width: 1.5,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        color: Colors.red,
                      ),
                      Text(
                        'Contact : ',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        state.orderDetail!.customer?.phone ?? '',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  gapH16,
                  Row(
                    children: [
                      const Icon(
                        kIsWeb ? Icons.location_pin : PhosphorIcons.mapPinLine,
                        color: AppColor.primaryColor,
                        size: 20.0,
                      ),
                      Container(
                        height: 20,
                        width: 1.5,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        color: Colors.red,
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'Address : ',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                            children: [
                              TextSpan(
                                text: state.orderDetail?.destAddress?.address ??
                                    '',
                                style: Theme.of(context).textTheme.titleMedium,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  gapH16,
                ],
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
