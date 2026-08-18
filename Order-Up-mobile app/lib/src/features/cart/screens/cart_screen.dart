import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/authentication/domain/auth_role_enum.dart';
import 'package:orderly_ecom/src/features/cart/screens/components/cart_list.dart';
import 'package:orderly_ecom/src/features/cart/screens/components/cart_time_slot.dart';
import 'package:orderly_ecom/src/features/cart/screens/cubit/cart_cubit.dart';
import 'package:orderly_ecom/src/features/location/data/location_local_repository.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/widgets/default_error_screen.dart';
import 'package:orderly_ecom/src/widgets/shimmer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late PageController pageController;
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final latitude = inject.get<LocationLocalRepository>().latitude;
      final longitude = inject.get<LocationLocalRepository>().longitude;
      await context.read<CartCubit>().getCartList(
            latitude: latitude,
            longitude: longitude,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderlyAppBar(
        title: AppLocalizations.of(context)!.cart,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        buildWhen: (_, newState) {
          return newState is CartLoadedState ||
              newState is CartFailedState ||
              newState is CartLoadingState;
        },
        builder: (context, state) {
          if (state is CartFailedState) {
            return DefaultErrorScreen(
              message: state.message,
            );
          }
          if (state is CartLoadingState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ...List.generate(
                    4,
                    (index) => const AppShimmer(
                      height: 150.0,
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is CartLoadedState) {
            return PageView.builder(
              controller: pageController,
              itemCount: state.cartList.length,
              onPageChanged: (value) {
                _currentPage.value = value;
              },
              itemBuilder: (c, i) => CartList(
                items: state.cartList[i].items,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _currentPage,
        builder: (context, value, _) {
          return CartTimeSlot(
            isFinalPage: value == context.read<CartCubit>().cartList.length - 1,
            onProceed: () => _onProceed(value),
            onPressed: () {},
          );
        },
      ),
    );
  }

  void _onProceed(int value) async {
    final cartCubit = context.read<CartCubit>();
    final state = cartCubit.state;
    if (value == cartCubit.cartList.length - 1) {
      if (inject.get<AuthLocalRepository>().guestAccessToken.isNotEmpty) {
        context.pushNamed(
          AppRoute.signIn.toName,
          params: {
            'role': AuthRole.consumer.name,
          },
          extra: {
            'isGuest': true,
          },
        );
        showSnackBar(
          context: context,
          title: 'Please login to proceed',
          message: 'Login to continue',
          snackbarType: SnackbarType.warning,
        );
      } else {
        if (context.read<CartCubit>().deliverySlot.isEmpty) {
          showSnackBar(
            context: context,
            title: AppLocalizations.of(context)!.select_delivery_option,
            message: 'Try again!.',
            snackbarType: SnackbarType.error,
          );
          return;
        }
        if (context.read<CartCubit>().deliverySlot == 'evening') {
          if (context.read<CartCubit>().deliveryDate == null) {
            showSnackBar(
              context: context,
              title: AppLocalizations.of(context)!.choose_delivery_time,
              message: 'Try again!.',
              snackbarType: SnackbarType.error,
            );
            return;
          }
        }
        context.pushNamed(
          AppRoute.destinationAddress.toName,
        );
      }
    } else {
      if (state is CartLoadedState) {
        final totalPages = state.cartList.length;
        if (value < totalPages - 1) {
          _currentPage.value++;
        } else {
          _currentPage.value = 0;
        }
        pageController.animateToPage(
          _currentPage.value,
          duration: defaultDuration,
          curve: Curves.easeInOut,
        );
      }
    }
  }
}
