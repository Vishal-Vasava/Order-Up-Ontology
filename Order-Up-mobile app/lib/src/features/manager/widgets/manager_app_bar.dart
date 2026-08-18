import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/constants/app_assets.dart';
import 'package:orderly_ecom/src/features/notifications/screens/cubit/notification_cubit.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/widgets/ai_intent_bar.dart';

Future<String>? _storeNameFuture;

Future<String> _fetchStoreName() async {
  try {
    final response = await inject.get<NetworkAdapter>().get('store/context');
    if (response.statusCode == 200 && response.data['statusCode'] == 200) {
      return response.data['data']['name']?.toString() ?? '';
    }
  } catch (_) {
    // Keep the header usable if store context is temporarily unavailable.
  }
  return '';
}

class StoreNameText extends StatelessWidget {
  const StoreNameText({
    super.key,
    this.prefix = '',
    this.style,
  });

  final String prefix;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _storeNameFuture ??= _fetchStoreName(),
      builder: (context, snapshot) {
        final storeName = snapshot.data ?? '';
        if (storeName.isEmpty) return const SizedBox.shrink();
        return Text(
          '$prefix$storeName',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: style ??
              Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
        );
      },
    );
  }
}

class ManagerAppBar extends PreferredSize {
  const ManagerAppBar({
    super.key,
    required this.title,
  }) : super(
          preferredSize: const Size.fromHeight(118.0),
          child: const Center(),
        );

  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      backgroundColor: AppColor.whiteColor,
      elevation: 5.0,
      shadowColor: AppColor.whiteColor50,
      centerTitle: false,
      flexibleSpace: SafeArea(
        child: IgnorePointer(
          child: Center(
            child: const StoreNameText(),
          ),
        ),
      ),
      actions: [
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
        gapW12,
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: SizedBox(
            width: 68.0,
            height: 40.0,
            child: ClipRect(
              child: Transform.scale(
                scale: 1.84,
                child: Image.asset(
                  AppAssets.appLogo,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(68),
        child: AiIntentBar(
          hintText: 'What should OrderUp help your store do?',
        ),
      ),
    );
  }
}
