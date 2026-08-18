import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/data/order_status_enum.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/screens/components/orders_list.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/screens/cubit/manager_order_cubit.dart';
import 'package:orderly_ecom/src/features/manager/widgets/manager_app_bar.dart';
import 'package:orderly_ecom/src/theme/colors.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<OrdersScreen> {
  TabController? _tabController;

  final ValueNotifier<int> currentTabIndex = ValueNotifier<int>(0);

  Map<OrderStatus, String> tabMap = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      context.read<ManagerOrderCubit>().getOrderList(
            status: OrderStatus.pending.name,
          );
      tabMap[OrderStatus.pending] = AppLocalizations.of(context)!.new_text;
      tabMap[OrderStatus.confirmed] = AppLocalizations.of(context)!.ready;
      tabMap[OrderStatus.shipped] = AppLocalizations.of(context)!.shipped;
      tabMap[OrderStatus.delivered] = AppLocalizations.of(context)!.delivered;
      tabMap[OrderStatus.cancelled] = AppLocalizations.of(context)!.cancelled;
      tabMap[OrderStatus.returned] = 'Returned';
      tabMap[OrderStatus.replaced] = 'Replaced';
      // tabList = [
      //   ,
      //   AppLocalizations.of(context)!.ready,
      //   AppLocalizations.of(context)!.shipped,
      //   AppLocalizations.of(context)!.delivered,
      //   AppLocalizations.of(context)!.cancelled,
      // ];
      _tabController = TabController(length: tabMap.length, vsync: this);
      _tabController!.addListener(() async {
        // This will make sure that only the requested tab api gets called.
        if (!_tabController!.indexIsChanging) {
          currentTabIndex.value = _tabController!.index;
          String orderStatus =
              tabMap.keys.elementAt(currentTabIndex.value).name;
          context.read<ManagerOrderCubit>().currentStatusId = orderStatus;
          await context.read<ManagerOrderCubit>().getOrderList(
                status: orderStatus,
                showLoading: true,
              );
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  int lastStateIndex = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<ManagerOrderCubit, ManagerOrderState>(
      listenWhen: (_, newState) {
        return newState is ManagerOrderLoadedState;
      },
      listener: (context, state) {
        if (state is ManagerOrderLoadedState) {
          // if (state.orderList.isNotEmpty) {

          // }
          lastStateIndex = currentTabIndex.value;
          _tabController!.animateTo(lastStateIndex);
        }
      },
      buildWhen: (oldState, newState) {
        return oldState is ManagerOrderInitialState ||
            newState is ManagerOrderLoadedState ||
            newState is ManagerOrderLoadingState ||
            newState is ManagerOrderFailedState;
      },
      builder: (context, state) {
        return Scaffold(
          appBar: ManagerAppBar(
            title: AppLocalizations.of(context)!.orders,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              String orderStatus =
                  tabMap.keys.elementAt(currentTabIndex.value).name;
              await context.read<ManagerOrderCubit>().getOrderList(
                    status: orderStatus,
                    showLoading: true,
                  );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gapH12,
                TabBar(
                  physics: const BouncingScrollPhysics(),
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: const TextStyle(
                    fontSize: 16.0,
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: kBorderRadius, vertical: kBorderRadius - 4),
                  unselectedLabelColor: AppColor.blackColor,
                  labelColor: Colors.white,
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                  indicatorColor: AppColor.primaryColor,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: AppColor.primaryColor,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 1,
                        color: AppColor.primaryColor.withOpacity(0.5),
                      )
                    ],
                    border: Border.all(color: AppColor.primaryColor),
                  ),
                  onTap: (int index) async {
                    currentTabIndex.value = index;
                  },
                  isScrollable: isDesktop(context)
                      ? false
                      : isTablet(context)
                          ? true
                          : true,
                  tabs: List.generate(
                    tabMap.length,
                    (index) => Tab(
                      height: 45.0,
                      child: Text(
                        tabMap.values.elementAt(index),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: List.generate(
                      _tabController!.length,
                      (index) => const OrdersList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
