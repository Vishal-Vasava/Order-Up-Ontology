import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/screens/cubit/manager_order_cubit.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/screens/widgets/order_card.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/widgets/default_error_screen.dart';
import 'package:orderly_ecom/src/widgets/shimmer.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManagerOrderCubit, ManagerOrderState>(
      listenWhen: (_, newState) {
        return newState is ManagerOrderLoadedState ||
            newState is ManagerOrderFailedState;
      },
      listener: (context, state) {},
      buildWhen: (_, newState) {
        return newState is ManagerOrderLoadingState ||
            newState is ManagerOrderLoadedState ||
            newState is ManagerOrderFailedState;
      },
      builder: (context, state) {
        if (state is ManagerOrderFailedState) {
          return DefaultErrorScreen(
            message: state.message,
          );
        }
        if (state is ManagerOrderLoadingState) {
          return ListView(
            children: [
              ...List.generate(
                4,
                (index) => const AppShimmer(
                  height: 200.0,
                ),
              ),
            ],
          );
        }
        if (state is ManagerOrderLoadedState) {
          if (state.orderList.isEmpty) {
            return const DefaultErrorScreen(
              message: 'No Orders Yet!',
            );
          }
          if (isDesktop(context) || isTablet(context)) {
            return AlignedGridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: kDefaultPadding,
              itemCount: state.orderList.length,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              primary: false,
              itemBuilder: (BuildContext context, int index) {
                return OrderCard(
                  modelData: state.orderList[index],
                  onTap: () {
                    context.goNamed(
                      AppRoute.managerOrderDetailPage.toName,
                      params: {
                        'orderNumber': state.orderList[index].orderNumber,
                        'orderId': state.orderList[index].id,
                        'orderStatus':
                            state.orderList[index].status == 'return_pickup'
                                ? 'return_pickup'
                                : state.orderList[index].status ==
                                        'return_confirmed'
                                    ? 'return_confirmed'
                                    : state.orderList[index].status ==
                                            'replace_pickup'
                                        ? 'replace_pickup'
                                        : state.orderList[index].status ==
                                                'replace_confirmed'
                                            ? 'replace_confirmed'
                                            : context
                                                .read<ManagerOrderCubit>()
                                                .currentStatusId
                                                .toString(),
                      },
                    );
                  },
                );
              },
            );
          }
          return ListView.builder(
            itemCount: state.orderList.length,
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            itemBuilder: (BuildContext c, int index) {
              return OrderCard(
                modelData: state.orderList[index],
                onTap: () {
                  context.goNamed(
                    AppRoute.managerOrderDetailPage.toName,
                    params: {
                      'orderNumber': state.orderList[index].orderNumber,
                      'orderId': state.orderList[index].id,
                      'orderStatus': context
                          .read<ManagerOrderCubit>()
                          .currentStatusId
                          .toString(),
                    },
                  );
                },
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
