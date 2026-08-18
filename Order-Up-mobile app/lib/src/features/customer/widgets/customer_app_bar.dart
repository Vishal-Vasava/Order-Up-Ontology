import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/address/screens/components/home_address_sheet.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/cart/screens/cubit/cart_cubit.dart';
import 'package:orderly_ecom/src/features/notifications/screens/cubit/notification_cubit.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:orderly_ecom/src/widgets/app_dialog.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomerAppBar extends PreferredSize {
  const CustomerAppBar({
    super.key,
    required this.title,
  }) : super(
          preferredSize: const Size.fromHeight(50.0),
          child: const Center(),
        );

  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: () {
        if (title == 'home') {
          return InkWell(
            onTap: () async {
              AppDialog.showBottomSheet(
                context: context,
                child: const HomeAddressSheet(),
              );
            },
            child: Row(
              children: [
                const Icon(
                  kIsWeb ? Icons.location_pin : PhosphorIcons.mapPinFill,
                  color: AppColor.accentColor,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: inject
                            .get<AuthLocalRepository>()
                            .authBox
                            .listenable(),
                        builder: (BuildContext context, Box<dynamic> value,
                            Widget? child) {
                          final String address = value.get('userAddress') ?? '';
                          if (address.isEmpty) {
                            return const Center();
                          }
                          return RichText(
                            text: TextSpan(
                              text: 'Deliver to :'.hardcoded,
                              style: Theme.of(context).textTheme.bodySmall,
                              children: [
                                TextSpan(
                                  text: '\n$address',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        );
      }(),
      backgroundColor: AppColor.whiteColor,
      elevation: 5.0,
      shadowColor: AppColor.whiteColor50,
      actions: [
        IconButton(
          onPressed: () {
            context.goNamed(AppRoute.search.toName);
          },
          icon: const Icon(
            kIsWeb ? Icons.search : PhosphorIcons.magnifyingGlass,
          ),
        ),
        BlocBuilder<NotificationCubit, NotificationState>(
          buildWhen: (_, newState) {
            return newState is NotificationLoadingState ||
                newState is NotificationLoadedState ||
                newState is NotificationFailedState;
          },
          builder: (context, state) {
            if (state is NotificationLoadedState) {
              return InkWell(
                onTap: () {
                  context.pushNamed(AppRoute.notificationScreen.toName);
                },
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      kIsWeb ? Icons.notifications : Iconsax.notification,
                    ),
                    Positioned(
                      right: -5,
                      top: 10,
                      child: Container(
                        height: 14.0,
                        width: 14.0,
                        decoration: BoxDecoration(
                          color: AppColor.accentColor,
                          borderRadius: BorderRadius.circular(8.5),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          () {
                            return state.notificationList.length.toString();
                          }(),
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: AppColor.whiteColor,
                                    fontSize: 10.0,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        gapW8,
        BlocBuilder<CartCubit, CartState>(
          buildWhen: (_, newState) {
            return newState is CartLoadedState || newState is CartFailedState;
          },
          builder: (context, state) {
            return InkWell(
              onTap: () {
                context.goNamed(AppRoute.cart.toName);
              },
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    kIsWeb ? Icons.shopping_bag_outlined : Iconsax.shopping_bag,
                  ),
                  Positioned(
                    right: -5,
                    top: 10,
                    child: Container(
                      height: 14.0,
                      width: 14.0,
                      decoration: BoxDecoration(
                        color: AppColor.accentColor,
                        borderRadius: BorderRadius.circular(8.5),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        context.read<CartCubit>().cartLength.toString(),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: AppColor.whiteColor,
                              fontSize: 10.0,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        gapW12,
      ],
    );
  }
}
