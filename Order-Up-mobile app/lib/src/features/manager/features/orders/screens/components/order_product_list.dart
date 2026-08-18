import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/screens/cubit/manager_order_cubit.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/screens/widgets/order_product_card.dart';
import 'package:orderly_ecom/src/widgets/empty_placeholder_widget.dart';
import 'package:orderly_ecom/src/widgets/shimmer.dart';

class OrderProductList extends StatelessWidget {
  const OrderProductList({
    super.key,
    required this.orderStatus,
  });
  final String orderStatus;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManagerOrderCubit, ManagerOrderState>(
      buildWhen: (_, newState) {
        return newState is ManagerOrderDetailFailedState ||
            newState is ManagerOrderDetailLoadingState ||
            newState is ManagerOrderDetailLoadedState;
      },
      builder: (context, state) {
        if (state is ManagerOrderDetailFailedState) {
          return EmptyPlaceholderWidget(
            message: state.message,
          );
        }
        if (state is ManagerOrderDetailLoadingState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ...List.generate(
                  6,
                  (index) => const AppShimmer(
                    height: 150.0,
                  ),
                ),
              ],
            ),
          );
        }
        if (state is ManagerOrderDetailLoadedState) {
          return ListView.builder(
            itemCount: state.orderDetail!.orderItems!.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext c, int index) {
              return OrderProductCard(
                modelData: state.orderDetail!.orderItems![index],
                orderStatus: orderStatus,
                managerOrderDetail: state.orderDetail!,
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
