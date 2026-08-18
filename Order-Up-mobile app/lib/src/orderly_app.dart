import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/constants/static_text.dart';
import 'package:orderly_ecom/src/features/address/data/address_repository.dart';
import 'package:orderly_ecom/src/features/address/screens/cubit/address_cubit.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_repository.dart';
import 'package:orderly_ecom/src/features/authentication/screens/cubit/auth_cubit.dart';
import 'package:orderly_ecom/src/features/cart/data/cart_repository.dart';
import 'package:orderly_ecom/src/features/cart/screens/cubit/cart_cubit.dart';
import 'package:orderly_ecom/src/features/category/data/category_repository.dart';
import 'package:orderly_ecom/src/features/category/screens/cubit/category_cubit.dart';
import 'package:orderly_ecom/src/features/delivery/data/delivery_repository.dart';
import 'package:orderly_ecom/src/features/delivery/screens/cubit/delivery_cubit.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/data/inventory_repository.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/screens/cubit/inventory_cubit.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/data/offer_repository.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/screens/cubit/offer_cubit.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/data/manager_order_repository.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/screens/cubit/manager_order_cubit.dart';
import 'package:orderly_ecom/src/features/navigation_bar/screens/cubit/navigation_cubit.dart';
import 'package:orderly_ecom/src/features/notifications/data/notification_repository.dart';
import 'package:orderly_ecom/src/features/notifications/data/notification_service.dart';
import 'package:orderly_ecom/src/features/notifications/screens/cubit/notification_cubit.dart';
import 'package:orderly_ecom/src/features/orders/data/order_repository.dart';
import 'package:orderly_ecom/src/features/orders/screens/cubit/order_cubit.dart';
import 'package:orderly_ecom/src/features/payment/data/payment_repository.dart';
import 'package:orderly_ecom/src/features/payment/screens/cubit/payment_cubit.dart';
import 'package:orderly_ecom/src/features/product/data/product_repository.dart';
import 'package:orderly_ecom/src/features/product/screens/cubit/product_cubit.dart';
import 'package:orderly_ecom/src/features/profile/data/profile_repository.dart';
import 'package:orderly_ecom/src/features/profile/screens/cubit/profile_cubit.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';
import 'package:orderly_ecom/src/theme/theme.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';

class OrderlyApp extends StatelessWidget {
  const OrderlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(
            networkAdapter: inject.get<NetworkAdapter>(),
            firebaseInstance: inject.get<FirebaseAuth>(),
            authLocalRepository: inject.get<AuthLocalRepository>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => NotificationRepository(
            networkAdapter: inject.get<NetworkAdapter>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => ProfileRepository(
            networkAdapter: inject.get<NetworkAdapter>(),
          ),
        ),
        RepositoryProvider(
          create: (context) =>
              DeliveryRepository(networkAdapter: inject.get<NetworkAdapter>()),
        ),
        RepositoryProvider(
          create: (context) => ManagerOrderRepository(
            networkAdapter: inject.get<NetworkAdapter>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => InventoryRepository(
            networkAdapter: inject.get<NetworkAdapter>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => CategoryRepository(
            networkAdapter: inject.get<NetworkAdapter>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => ProductRepository(
            networkAdapter: inject.get<NetworkAdapter>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => CartRepository(
            networkAdapter: inject.get<NetworkAdapter>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => AddressRepository(
            networkAdapter: inject.get<NetworkAdapter>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => OrderRepository(
            networkAdapter: inject.get<NetworkAdapter>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => OfferRepository(
            networkAdapter: inject.get<NetworkAdapter>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => PaymentRepository(
            networkAdapter: inject.get<NetworkAdapter>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => NotificationCubit(
              notificationRepository: context.read<NotificationRepository>(),
              notificationService: inject.get<NotificationService>(),
            ),
          ),
          BlocProvider(
            create: (context) => NavigationCubit(
              notificationCubit: context.read<NotificationCubit>(),
            ),
          ),
          BlocProvider(
            create: (context) => ProfileCubit(
              profileAdapter: context.read<ProfileRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => DeliveryCubit(
              deliveryInterface: context.read<DeliveryRepository>(),
              notificationCubit: context.read<NotificationCubit>(),
            ),
          ),
          BlocProvider(
            create: (context) => ManagerOrderCubit(
              orderAdapter: context.read<ManagerOrderRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => InventoryCubit(
              inventoryAdapter: context.read<InventoryRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => CategoryCubit(
              categoryAdapter: context.read<CategoryRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ProductCubit(
              productAdapter: context.read<ProductRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => CartCubit(
              cartAdapter: context.read<CartRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => AddressCubit(
              addressAdapter: context.read<AddressRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => OrderCubit(
              orderAdapter: context.read<OrderRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => OfferCubit(
              offerInterface: context.read<OfferRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => PaymentCubit(
              paymentRepository: context.read<PaymentRepository>(),
            ),
          ),
        ],
        child: GestureDetector(
          onTap: () {
            final currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
          },
          child: MaterialApp.router(
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            // builder: kIsWeb
            //     ? null
            //     : (context, child) {
            //         final mediaQueryData = MediaQuery.of(context);
            //         final double scale =
            //             mediaQueryData.textScaleFactor.clamp(0.7, 0.9);
            //         return MediaQuery(
            //           data:
            //               MediaQuery.of(context).copyWith(textScaleFactor: scale),
            //           child: child!,
            //         );
            //       },
            onGenerateTitle: (_) => StaticText.appName,
            supportedLocales: StaticText.supportLanguage,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            title: StaticText.appName,
            theme: AppTheme.theme,
            themeMode: ThemeMode.light,
            routeInformationProvider: goRouter.routeInformationProvider,
            routeInformationParser: goRouter.routeInformationParser,
            routerDelegate: goRouter.routerDelegate,
          ),
        ),
      ),
    );
  }
}
