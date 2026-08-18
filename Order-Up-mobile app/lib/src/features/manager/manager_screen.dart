import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/manager/features/claims/screens/claims_screen.dart';
import 'package:orderly_ecom/src/features/manager/features/customer_list/screens/customer_list_screen.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/screens/inventory_screen.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/screens/orders_screen.dart';
import 'package:orderly_ecom/src/features/navigation_bar/domain/navigation_bar.dart';
import 'package:orderly_ecom/src/features/navigation_bar/screens/cubit/navigation_cubit.dart';
import 'package:orderly_ecom/src/features/profile/screens/profile_screen.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';

class ManagerScreen extends StatefulWidget {
  const ManagerScreen({super.key});

  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  final List<Widget> _pages = [
    const OrdersScreen(),
    const InventoryScreen(),
    const ClaimsScreen(),
    const CustomerListScreen(),
    const ProfileScreen(),
  ];

  List<NavigationBarItem> navigationBarItem = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.mounted) {
      generateNavigationItem();
    }
  }

  void generateNavigationItem() {
    if (navigationBarItem.length != _pages.length) {
      navigationBarItem.add(
        NavigationBarItem(
          icon: kIsWeb ? Icons.history : Iconsax.receipt,
          label: AppLocalizations.of(context)!.orders,
        ),
      );
      navigationBarItem.add(
        NavigationBarItem(
          icon: kIsWeb ? Icons.inventory_2_outlined : Iconsax.box_tick,
          label: AppLocalizations.of(context)!.inventory,
        ),
      );
      navigationBarItem.add(
        NavigationBarItem(
          icon: kIsWeb ? Icons.money : Iconsax.money,
          label: AppLocalizations.of(context)!.claims,
        ),
      );
      navigationBarItem.add(
        NavigationBarItem(
          icon: kIsWeb ? Icons.pie_chart : Iconsax.presention_chart,
          label: AppLocalizations.of(context)!.customers,
        ),
      );
      navigationBarItem.add(
        NavigationBarItem(
          icon: kIsWeb ? Icons.person : Iconsax.tag_user,
          label: AppLocalizations.of(context)!.profile,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: BlocConsumer<NavigationCubit, NavigationState>(
        listener: (context, state) async {
          if (state is NavigationInitialState) {
            if (state.deepLinkData['api_url']
                .toString()
                .contains('store/order/details')) {
              final Map<String, dynamic> deepData =
                  jsonDecode(state.deepLinkData['api_data']);
              final String orderId = state.deepLinkData['api_url']
                  .toString()
                  .replaceAll('store/order/details/', '')
                  .trim()
                  .toString();
              final String currentStatus = deepData['status'].toString();
              final String orderNumber = deepData['order_number'].toString();
              log('INSIDE Manager ORDER', name: 'DEEP');
              context.goNamed(AppRoute.managerOrderDetailPage.toName, params: {
                'orderId': orderId,
                'orderStatus': currentStatus,
                'orderNumber': orderNumber,
              });
            }
          }
        },
        builder: (context, state) {
          if (state is NavigationInitialState) {
            return _pages[state.activeIndex];
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.blackColor20,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(kDefaultPadding + kBorderRadius),
                topRight: Radius.circular(kDefaultPadding + kBorderRadius),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35.0),
              child: BlocBuilder<NavigationCubit, NavigationState>(
                buildWhen: (_, newState) {
                  return newState is NavigationInitialState;
                },
                builder: (_, state) {
                  if (state is NavigationInitialState) {
                    return BottomNavigationBar(
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      type: BottomNavigationBarType.fixed,
                      unselectedItemColor:
                          Theme.of(context).unselectedWidgetColor,
                      selectedItemColor: Theme.of(context).primaryColor,
                      showUnselectedLabels: true,
                      currentIndex: state.activeIndex,
                      items: navigationBarItem
                          .map(
                            (e) => BottomNavigationBarItem(
                              icon: Icon(
                                e.icon,
                              ),
                              label: e.label,
                            ),
                          )
                          .toList(),
                      onTap: (index) {
                        HapticFeedback.lightImpact();
                        context
                            .read<NavigationCubit>()
                            .changeIndex(index: index);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
