import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/features/orders/screens/components/order_expanded_card.dart';
import 'package:orderly_ecom/src/features/orders/screens/cubit/order_cubit.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/widgets/default_error_screen.dart';
import 'package:orderly_ecom/src/widgets/shimmer.dart';

class OrderList extends StatelessWidget {
  const OrderList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      buildWhen: (_, newState) {
        return newState is OrderLoadedState ||
            newState is OrderFailedState ||
            newState is OrderLoadingState;
      },
      builder: (context, state) {
        if (state is OrderFailedState) {
          return DefaultErrorScreen(
            message: state.message,
          );
        }
        if (state is OrderLoadingState) {
          return Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  children: [
                    ...List.generate(
                      4,
                      (index) => const AppShimmer(
                        height: 200.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (state is OrderLoadedState) {
          if (state.orderList.isEmpty) {
            return Column(
              children: [
                const Center(
                  child: DefaultErrorScreen(
                    message: 'No Orders Yet!',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    context.read<OrderCubit>().getOrderList(
                          timeType: '',
                          duration: '',
                          status: 'pending',
                        );
                  },
                  child: const Text(
                    'Retry',
                  ),
                ),
              ],
            );
          }
          if (state.searchOrderList.isNotEmpty) {
            return Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await context.read<OrderCubit>().getOrderList(
                        timeType: '',
                        duration: '',
                        status: 'pending',
                      );
                },
                child: SlideInRight(
                  duration: const Duration(milliseconds: 400),
                  child: ListView.builder(
                    itemCount: state.searchOrderList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return OrderExpandedCard(
                        modelData: state.searchOrderList[index],
                      );
                    },
                  ),
                ),
              ),
            );
          }
          return Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await context.read<OrderCubit>().getOrderList(
                      timeType: '',
                      duration: '',
                      status: 'pending',
                    );
              },
              child: SlideInRight(
                duration: const Duration(milliseconds: 400),
                child: ListView.builder(
                  itemCount: state.orderList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return OrderExpandedCard(
                      modelData: state.orderList[index],
                    );
                  },
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
