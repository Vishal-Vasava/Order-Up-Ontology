import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly_ecom/src/features/delivery/screens/cubit/delivery_cubit.dart';
import 'package:orderly_ecom/src/features/delivery/screens/widgets/delivery_card.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:shimmer/shimmer.dart';

class DeliveryList extends StatelessWidget {
  const DeliveryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryCubit, DeliveryState>(
      buildWhen: (_, newState) {
        return newState is DeliveryOrderFetchFailedState ||
            newState is DeliveryOrderFetchedState ||
            newState is DeliveryOrderFetchingState;
      },
      builder: (context, state) {
        if (state is DeliveryOrderFetchingState) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).hoverColor,
                  highlightColor: Theme.of(context).highlightColor,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 5,
                          bottom: 5,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 10,
                              width: 180,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 5),
                            ),
                            Container(
                              height: 10,
                              width: 150,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: 6,
          );
        }
        if (state is DeliveryOrderFetchFailedState) {
          return Center(
            child: Text(
              state.message,
            ),
          );
        }
        if (state is DeliveryOrderFetchedState) {
          return ListView.builder(
            itemCount: state.deliveryList.length,
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext c, int i) {
              return DeliveryCard(
                modelData: state.deliveryList[i],
                onPressed: () {
                  context
                      .pushNamed(AppRoute.deliveryDetailPage.toName, params: {
                    'orderId': state.deliveryList[i].id!,
                  });
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
