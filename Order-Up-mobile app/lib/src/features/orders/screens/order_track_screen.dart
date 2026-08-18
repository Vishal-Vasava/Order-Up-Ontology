import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/orders/domain/order.dart';
import 'package:orderly_ecom/src/features/orders/screens/components/order_return_reason.dart';
import 'package:orderly_ecom/src/features/orders/screens/components/timeline_widget.dart';
import 'package:orderly_ecom/src/features/orders/screens/cubit/order_cubit.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderTrackScreen extends StatefulWidget {
  const OrderTrackScreen({
    super.key,
    required this.orderId,
    required this.orderDetailId,
  });
  final String orderId;
  final String orderDetailId;

  @override
  _OrderTrackScreenState createState() => _OrderTrackScreenState();
}

class _OrderTrackScreenState extends State<OrderTrackScreen> {
  late Order modelData;

  OrderItem? orderItem;

  @override
  void initState() {
    super.initState();

    final orderIndex = context
        .read<OrderCubit>()
        .orderList
        .indexWhere((element) => element.orderId!.toString() == widget.orderId);
    modelData = context.read<OrderCubit>().orderList[orderIndex];
    orderItem = modelData.orderItems!
        .firstWhere((element) => element.id.toString() == widget.orderDetailId);
    context.read<OrderCubit>().trackOrder(orderDetialId: widget.orderDetailId);
  }

  final RefreshController _refreshController = RefreshController();

  List<TrackOrderList> staticTrackOrderList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderlyAppBar(
        title: AppLocalizations.of(context)!.track_order,
      ),
      body: BlocConsumer<OrderCubit, OrderState>(
        listenWhen: (_, newState) {
          return newState is OrderTrackLoadedState ||
              newState is OrderTrackLoadedState;
        },
        buildWhen: (_, newState) {
          return newState is OrderTrackLoadedState ||
              newState is OrderTrackLoadedState;
        },
        listener: (context, state) {
          if (state is OrderTrackLoadedState) {
            staticTrackOrderList.clear();
            staticTrackOrderList.add(
              TrackOrderList(
                id: 0,
                trackStatusName:
                    AppLocalizations.of(context)!.order_pending_status,
                orderStatus: 'pending',
                isActiveColor: false,
                date: null,
                cancelReason: '',
              ),
            );
            staticTrackOrderList.add(
              TrackOrderList(
                id: 1,
                trackStatusName:
                    AppLocalizations.of(context)!.order_accepted_status,
                orderStatus: 'confirmed',
                isActiveColor: false,
                date: null,
                cancelReason: '',
              ),
            );
            staticTrackOrderList.add(
              TrackOrderList(
                id: 2,
                trackStatusName:
                    AppLocalizations.of(context)!.order_shipped_status,
                orderStatus: 'shipped',
                isActiveColor: false,
                date: null,
                cancelReason: '',
              ),
            );
            staticTrackOrderList.add(
              TrackOrderList(
                id: 3,
                trackStatusName:
                    AppLocalizations.of(context)!.order_delivered_status,
                orderStatus: 'delivered',
                isActiveColor: false,
                date: null,
                cancelReason: '',
              ),
            );
            staticTrackOrderList.add(
              TrackOrderList(
                id: 3,
                trackStatusName:
                    AppLocalizations.of(context)!.order_cancelled_status,
                orderStatus: 'cancelled',
                isActiveColor: false,
                date: null,
                cancelReason: '',
              ),
            );

            //   //for new
            for (int i = 0; i <= state.trackOrder.history!.length; i++) {
              for (int j = 0; j < staticTrackOrderList.length; j++) {
                try {
                  if (state.trackOrder.history![i].status ==
                      staticTrackOrderList[j].orderStatus!.toString()) {
                    staticTrackOrderList[j].isActiveColor = true;
                    staticTrackOrderList[j].date =
                        state.trackOrder.history![i].createdAt!;
                    staticTrackOrderList[j].cancelReason = state.cancelReason;
                  } else {
                    // staticTrackOrderList.removeAt(i);
                    staticTrackOrderList[j].date =
                        state.trackOrder.history![i].createdAt!;
                  }
                } catch (e) {
                  // staticTrackOrderList[i].date="";
                  // staticTrackOrderList[i].date =
                  //     state.trackOrder.orderDate!;
                }
              }
            }

            // } else if (state.currentstatus == '') {
            //   //for original flow
            //   staticTrackOrderList.add(TrackOrderList(
            //       id: 0,
            //       trackStatusName:
            //           AppLocalizations.of(context)!.order_pending_status,
            //       orderStatus: 0,
            //       isActiveColor: false,
            //       date: '',),);
            //   staticTrackOrderList.add(TrackOrderList(
            //       id: 1,
            //       trackStatusName:
            //           AppLocalizations.of(context)!.order_accepted_status,
            //       orderStatus: 1,
            //       isActiveColor: false,
            //       date: '',),);
            //   staticTrackOrderList.add(TrackOrderList(
            //       id: 2,
            //       trackStatusName:
            //           AppLocalizations.of(context)!.order_shipped_status,
            //       orderStatus: 2,
            //       isActiveColor: false,
            //       date: '',),);
            //   staticTrackOrderList.add(TrackOrderList(
            //       id: 3,
            //       trackStatusName:
            //           AppLocalizations.of(context)!.order_delivered_status,
            //       orderStatus: 3,
            //       isActiveColor: false,
            //       date: '',),);
            //   // staticTrackOrderList.add(TrackOrderList(
            //   //   id: 4, trackStatusName: "Order Cancelled", orderStatus: 6,isActiveColor: false,date: ""));

            //   //for new
            //   for (int i = 0;
            //       i <=
            //           int.parse(state
            //               .trackOrderList[state.trackOrder.length - 1]
            //               .ohStatus
            //               .toString());
            //       i++) {
            //     staticTrackOrderList[i].isActiveColor = true;
            //     for (int j = 0; j < state.trackOrder.length; j++) {
            //       try {
            //         if (state.trackOrder[j].ohStatus == i.toString()) {
            //           staticTrackOrderList[i].date =
            //               state.trackOrder[j].orderDate!;
            //         } else {
            //           staticTrackOrderList[i].date =
            //               state.trackOrder.orderDate!;
            //         }
            //       } catch (e) {
            //         // staticTrackOrderList[i].date="";
            //         staticTrackOrderList[i].date =
            //             state.trackOrder.orderDate!;
            //       }
            //     }
            //   }
            // } else if (state.currentstatus == '4') {
            //   //for return part
            //   staticTrackOrderList.add(TrackOrderList(
            //       id: 0,
            //       trackStatusName: 'Return Order Pending',
            //       orderStatus: 4,
            //       isActiveColor: false,
            //       date: '',),);
            //   staticTrackOrderList.add(TrackOrderList(
            //       id: 1,
            //       trackStatusName: 'Return Order Confirmed',
            //       orderStatus: 7,
            //       isActiveColor: false,
            //       date: '',),);
            //   staticTrackOrderList.add(TrackOrderList(
            //       id: 2,
            //       trackStatusName: 'Return Order Shipped',
            //       orderStatus: 9,
            //       isActiveColor: false,
            //       date: '',),);
            //   staticTrackOrderList.add(TrackOrderList(
            //       id: 3,
            //       trackStatusName: 'Return Order Delivered',
            //       orderStatus: 10,
            //       isActiveColor: false,
            //       date: '',),);
            //   // staticTrackOrderList.add(TrackOrderList(
            //   //   id: 4, trackStatusName: "Return Order Cancelled", orderStatus: 8,isActiveColor: false,date: ""));

            //   //for return
            //   for (int i = 0; i <= staticTrackOrderList.length - 1; i++) {
            //     if (staticTrackOrderList[i].orderStatus ==
            //         int.parse(state
            //             .trackOrderList[state.trackOrder.length - 1]
            //             .ohStatus
            //             .toString())) {
            //       int size = staticTrackOrderList[i].id!;
            //       for (int j = 0; j <= size; j++) {
            //         staticTrackOrderList[j].isActiveColor = true;
            //         try {
            //           if (state.trackOrder[j].ohStatus == i.toString()) {
            //             staticTrackOrderList[i].date =
            //                 state.trackOrder[j].orderDate!;
            //           } else {
            //             staticTrackOrderList[i].date =
            //                 state.trackOrder.orderDate!;
            //           }
            //         } catch (e) {
            //           // staticTrackOrderList[j].date="";
            //           staticTrackOrderList[j].date =
            //               state.trackOrder.orderDate!;
            //         }
            //       }
            //     }
            //   }
            // } else if (state.currentstatus == '5') {
            //   //for replace
            //   staticTrackOrderList.add(TrackOrderList(
            //       id: 0,
            //       trackStatusName: 'Replace Order Pending',
            //       orderStatus: 5,
            //       isActiveColor: false,
            //       date: '',),);
            //   staticTrackOrderList.add(TrackOrderList(
            //       id: 1,
            //       trackStatusName: 'Replace Order Confirmed',
            //       orderStatus: 11,
            //       isActiveColor: false,
            //       date: '',),);
            //   staticTrackOrderList.add(TrackOrderList(
            //       id: 2,
            //       trackStatusName: 'Replace Order Shipped',
            //       orderStatus: 13,
            //       isActiveColor: false,
            //       date: '',),);
            //   staticTrackOrderList.add(TrackOrderList(
            //       id: 3,
            //       trackStatusName: 'Replace Order Delivered',
            //       orderStatus: 14,
            //       isActiveColor: false,
            //       date: '',),);
            //   // staticTrackOrderList.add(TrackOrderList(
            //   //   id: 4, trackStatusName: "Replace Order Cancelled", orderStatus: 12,isActiveColor: false,date: ""));

            //   //for replace
            //   for (int i = 0; i <= staticTrackOrderList.length - 1; i++) {
            //     if (staticTrackOrderList[i].orderStatus ==
            //         int.parse(state
            //             .trackOrderList[state.trackOrder.length - 1]
            //             .ohStatus
            //             .toString())) {
            //       int size = staticTrackOrderList[i].id!;
            //       for (int j = 0; j <= size; j++) {
            //         staticTrackOrderList[j].isActiveColor = true;
            //         try {
            //           if (state.trackOrder[j].ohStatus == i.toString()) {
            //             staticTrackOrderList[i].date =
            //                 state.trackOrder[j].orderDate!;
            //           } else {
            //             staticTrackOrderList[i].date =
            //                 state.trackOrder.orderDate!;
            //           }
            //         } catch (e) {
            //           // staticTrackOrderList[j].date="";
            //           staticTrackOrderList[i].date =
            //               state.trackOrder.orderDate!;
            //         }
            //       }
            //     }
            //   }
            // }
          }
        },
        builder: (context, state) {
          if (state is OrderTrackLoadingState) {
            return const Center();
            // return ListView.builder(
            //   padding: const EdgeInsets.all(0),
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemBuilder: (context, index) {
            //     return Padding(
            //       padding: const EdgeInsets.only(bottom: 15),
            //       child: Shimmer.fromColors(
            //         baseColor: Theme.of(context).hoverColor,
            //         highlightColor: Theme.of(context).highlightColor,
            //         child: Row(
            //           children: <Widget>[
            //             Container(
            //               width: 80,
            //               height: 80,
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(8),
            //                 color: Colors.white,
            //               ),
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.only(
            //                 left: 10,
            //                 right: 10,
            //                 top: 5,
            //                 bottom: 5,
            //               ),
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: <Widget>[
            //                   Container(
            //                     height: 10,
            //                     width: 180,
            //                     color: Colors.white,
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     );
            //   },
            //   itemCount: 6,
            // );
          } else if (state is OrderTrackLoadedState) {
            // String statusCode = '';

            // for (var i = 0; i < orderItem!.product!.productList!.length; i++) {
            //   statusCode =
            //       orderItem!.product!.productList![i].returnPolicy!.code!;
            // }
            return SmartRefresher(
              controller: _refreshController,
              onRefresh: () async {
                await context
                    .read<OrderCubit>()
                    .trackOrder(orderDetialId: widget.orderDetailId);
                _refreshController.refreshCompleted();
              },
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                physics: const BouncingScrollPhysics(),
                children: [
                  // ProductCard(
                  //   modelData: modelData.modelData,
                  // ),
                  Container(
                    margin: const EdgeInsets.all(12.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      border: Border.all(
                        width: 0.3,
                        color: AppColor.accentColor,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ImageBuilder(
                        //   imageUrl:
                        //       modelData.orderItems![0].productImageUrl ?? '',
                        //   height: 80.0,
                        //   width: 80.0,
                        // ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                modelData.orderItems![0].productName ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                              // ReadMoreText(
                              //   modelData.productName,
                              //   style: Theme.of(context)
                              //       .textTheme
                              //       .button!
                              //       .copyWith(
                              //         fontSize: 12.0,
                              //         color: AppTheme.textColor,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //   trimLines: 2,
                              //   trimMode: TrimMode.Line,
                              //   trimCollapsedText: 'Show more',
                              //   trimExpandedText: 'Show less',
                              // ),
                              Text(
                                'Convinience Fee - : ${modelData.conveyanceCharge}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                'Item Price -  : ${modelData.currency?.locale!.getCurrencyPerLocale}  ${orderItem?.price}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontSize: 11.0,
                                    ),
                              ),
                              Text(
                                '${AppLocalizations.of(context)!.quantity}: ${orderItem?.qty}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TimeLineWidget(
                      trackOrderList: staticTrackOrderList
                          .where((element) =>
                              element.date != null && element.isActiveColor!)
                          .toList(),
                    ),
                  ),
                  gapH8,
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tracking ID',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            modelData.orderNumber.toString(),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  gapH32,

                  orderItem!.status == 'delivered' &&
                          orderItem!.product!.returnPolicy != null &&
                          orderItem!.product!.returnPolicy!.title
                                  .toLowerCase() !=
                              'none'
                      ? OrderReturnDropDown(
                          orderItemData: orderItem!,
                          productData: orderItem!.product!,
                          orderId: widget.orderId,
                          returnPolicyData: orderItem!.product!.returnPolicy!,
                        )
                      : const Center(),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class TrackOrderList {
  TrackOrderList({
    this.id,
    this.trackStatusName,
    this.orderStatus,
    this.date,
    this.isActiveColor,
    this.cancelReason,
  });
  int? id;
  String? trackStatusName;
  String? orderStatus;
  DateTime? date;
  bool? isActiveColor = false;
  String? cancelReason;
}
