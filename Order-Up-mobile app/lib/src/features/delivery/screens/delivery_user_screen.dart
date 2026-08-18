import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/delivery/domain/tab_item.dart';
import 'package:orderly_ecom/src/features/delivery/screens/components/delivery_list.dart';
import 'package:orderly_ecom/src/features/delivery/screens/cubit/delivery_cubit.dart';
import 'package:orderly_ecom/src/features/notifications/screens/cubit/notification_cubit.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:orderly_ecom/src/widgets/ai_intent_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';

class DeliveryUserScreen extends StatefulWidget {
  const DeliveryUserScreen({super.key});

  @override
  State<DeliveryUserScreen> createState() => _DeliveryUserScreenState();
}

class _DeliveryUserScreenState extends State<DeliveryUserScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int lastStateIndex = 0;

  late RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _tabController = TabController(length: orderTab.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<DeliveryCubit>().getOrders(
            status: orderTab[0].orderTabName,
          );
    });

    /// TAB CONTROLLER LISTENER
    _tabController!.addListener(() async {
      int currentIndex = 0;
      if (!_tabController!.indexIsChanging) {
        currentIndex = _tabController!.index;
        await context.read<DeliveryCubit>().getOrders(
              status: orderTab[currentIndex].orderTabName,
            );
      }
      lastStateIndex = currentIndex;
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeliveryCubit, DeliveryState>(
      listenWhen: (_, newState) {
        return newState is DeliveryOrderFetchedState;
      },
      listener: (context, state) {
        if (state is DeliveryOrderFetchedState) {
          if (state.deepLinkData.isNotEmpty) {
            if (state.deepLinkData['api_url'] == 'agent/orders') {
              _tabController!.animateTo(0);
            }
            if (state.deepLinkData['api_url']
                .toString()
                .contains('agent/order/details')) {
              final String orderDetailId = state.deepLinkData['api_url']
                  .toString()
                  .replaceAll('agent/order/details/', '')
                  .trim()
                  .toString();
              context.pushNamed(AppRoute.deliveryDetailPage.toName, params: {
                'orderId': orderDetailId,
              });
            }
          }
        }
      },
      buildWhen: (oldState, _) {
        return oldState is DeliveryInitialState;
      },
      builder: (context, state) {
        return Scaffold(
          appBar: OrderlyAppBar(
            leadingWidget: const SizedBox.shrink(),
            centerTitle: true,
            title: AppLocalizations.of(context)!.my_order,
            action: [
              BlocBuilder<NotificationCubit, NotificationState>(
                buildWhen: (oldState, newState) {
                  return newState is NotificationLoadedState;
                },
                builder: (context, state) {
                  if (state is NotificationLoadedState) {
                    return InkWell(
                      onTap: () {
                        context.pushNamed(AppRoute.notificationScreen.toName);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(
                              kIsWeb
                                  ? Icons.shopping_bag_outlined
                                  : Iconsax.notification,
                            ),
                            Positioned(
                              right: -5,
                              top: 15,
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: AppColor.accentColor,
                                  borderRadius: BorderRadius.circular(8.5),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 17,
                                  minHeight: 4,
                                ),
                                child: Text(
                                  () {
                                    return state.notificationList.length
                                        .toString();
                                  }(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const Offstage();
                },
              ),
              IconButton(
                onPressed: () {
                  context.pushNamed(AppRoute.profile.toName);
                },
                icon: const Icon(
                  kIsWeb ? Icons.person : Iconsax.profile_circle,
                  size: 32.0,
                  color: AppColor.primaryColor,
                ),
              ),
              gapW12,
            ],
            toolbarHeight: kToolbarHeight + 50.0,
            bottomWidget: PreferredSize(
              preferredSize: const Size.fromHeight(20),
              child: TabBar(
                controller: _tabController,
                indicatorWeight: 6,
                isScrollable: false,
                indicatorColor: AppColor.accentColor,
                physics: const BouncingScrollPhysics(),
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: const TextStyle(
                  fontSize: 16.0,
                ),
                padding: const EdgeInsets.symmetric(horizontal: kBorderRadius),
                unselectedLabelColor: AppColor.blackColor,
                labelColor: Colors.white,
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                ),
                onTap: (value) {
                  lastStateIndex = value;
                },
                tabs: [
                  ...List.generate(
                    orderTab.length,
                    (index) => Tab(
                      iconMargin: EdgeInsets.zero,
                      child: Text(
                        orderTab[index].normalize,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              const AiIntentBar(
                hintText: 'Ask about a delivery or describe an issue…',
              ),
              Expanded(
                child: SmartRefresher(
                  controller: _refreshController,
                  onRefresh: () async {
                    await context
                        .read<DeliveryCubit>()
                        .getOrders(status: orderTab[lastStateIndex]);
                    _refreshController.refreshCompleted();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: kBorderRadius),
                    child: TabBarView(
                      physics: const BouncingScrollPhysics(),
                      controller: _tabController,
                      children: List.generate(
                        orderTab.length,
                        (index) => const DeliveryList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
