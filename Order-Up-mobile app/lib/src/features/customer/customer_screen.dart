import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/cart/screens/cubit/cart_cubit.dart';
import 'package:orderly_ecom/src/features/category/screens/category_screen.dart';
import 'package:orderly_ecom/src/features/location/data/location_local_repository.dart';
import 'package:orderly_ecom/src/features/navigation_bar/domain/navigation_bar.dart';
import 'package:orderly_ecom/src/features/navigation_bar/screens/cubit/navigation_cubit.dart';
import 'package:orderly_ecom/src/features/notifications/screens/cubit/notification_cubit.dart';
import 'package:orderly_ecom/src/features/orders/screens/order_screen.dart';
import 'package:orderly_ecom/src/features/payment/screens/cubit/payment_cubit.dart';
import 'package:orderly_ecom/src/features/product/screens/product_screen.dart';
import 'package:orderly_ecom/src/features/profile/screens/profile_screen.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/features/category/screens/cubit/category_cubit.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key, required this.isGuest});
  final bool isGuest;

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final List<Widget> _pages = [
    const ProductScreen(),
    const CategoryScreen(),
    const OrderScreen(),
    const ProfileScreen(),
  ];

  List<NavigationBarItem> navigationBarItem = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cartCubit = context.cubit<CartCubit>();
      final notificationCubit = context.cubit<NotificationCubit>();

      final latitude = inject.get<LocationLocalRepository>().latitude;
      final longitude = inject.get<LocationLocalRepository>().longitude;
      await cartCubit.getCartList(
        latitude: latitude,
        longitude: longitude,
      );
      if (context.mounted) {}
      await notificationCubit.getNotification();
      if (context.mounted) {
        if (widget.isGuest) {
          context.goNamed(
            AppRoute.cart.toName,
          );
        }
      }
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (context.mounted) {
      generateNavigationItem();
      final cartCubit = context.cubit<CartCubit>();
      final latitude = inject.get<LocationLocalRepository>().latitude;
      final longitude = inject.get<LocationLocalRepository>().longitude;
      await cartCubit.getCartList(
        latitude: latitude,
        longitude: longitude,
      );
    }
  }

  void generateNavigationItem() {
    if (navigationBarItem.length != _pages.length) {
      navigationBarItem.add(
        NavigationBarItem(
          icon: kIsWeb ? Icons.home : Iconsax.home_2,
          label: AppLocalizations.of(context)!.home,
        ),
      );
      navigationBarItem.add(
        NavigationBarItem(
          icon: kIsWeb ? Icons.store : Iconsax.category_2,
          label: AppLocalizations.of(context)!.category,
        ),
      );
      navigationBarItem.add(
        NavigationBarItem(
          icon: kIsWeb ? Icons.history : Iconsax.receipt,
          label: AppLocalizations.of(context)!.orders,
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
      body: BlocListener<PaymentCubit, PaymentState>(
        listenWhen: (_, newState) {
          return newState is PaymentSuccessState;
        },
        listener: (context, state) {
          if (state is PaymentSuccessState) {
            final latitude = inject.get<LocationLocalRepository>().latitude;
            final longitude = inject.get<LocationLocalRepository>().longitude;
            context
                .read<CartCubit>()
                .getCartList(latitude: latitude, longitude: longitude);
          }
        },
        child: BlocListener<CartCubit, CartState>(
          listenWhen: (_, newState) {
            return newState is CartPlaceOrderSuccessState;
          },
          listener: (context, state) async {
            if (state is CartPlaceOrderSuccessState) {
              final latitude = inject.get<LocationLocalRepository>().latitude;
              final longitude = inject.get<LocationLocalRepository>().longitude;
              await context.read<CategoryCubit>().getCategoryList(
                    custLat: latitude,
                    custLong: longitude,
                  );
            }
          },
          child: BlocConsumer<NavigationCubit, NavigationState>(
            listener: (context, state) async {
              /// Deep Linking of Notification
              if (state is NavigationInitialState) {
                if (state.deepLinkData.isNotEmpty) {
                  /// CUSTOMER PLACED ORDER
                  if (state.deepLinkData['api_url'] == 'shopping/orders') {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    context.read<NavigationCubit>().changeIndex(index: 2);
                  } else if (state.deepLinkData['api_url']
                      .toString()
                      .contains('shopping/orders/track')) {
                    final String orderDetailId = state.deepLinkData['api_url']
                        .toString()
                        .replaceAll('shopping/orders/track/', '')
                        .trim();
                    context.goNamed(AppRoute.orderTrack.toName, params: {
                      'orderDetailId': orderDetailId,
                      'orderId': '',
                    });
                  }
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
        ),
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.whiteColor50,
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
                builder: (context, state) {
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
