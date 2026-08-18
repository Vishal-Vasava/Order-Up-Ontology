import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/cart/screens/cubit/cart_cubit.dart';
import 'package:orderly_ecom/src/features/product/screens/components/product_search_bar.dart';
import 'package:orderly_ecom/src/features/product/screens/cubit/product_cubit.dart';
import 'package:orderly_ecom/src/features/product/screens/widgets/product_card.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:orderly_ecom/src/widgets/default_error_screen.dart';

class ProductSearchList extends StatelessWidget {
  const ProductSearchList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderlyAppBar(
        title: AppLocalizations.of(context)!.search_title,
      ),
      body: ListView(
        children: [
          const ProductSearchBar(),
          BlocBuilder<ProductCubit, ProductState>(
            buildWhen: (_, newState) {
              return newState is ProductLoadedState ||
                  newState is ProductLoadingState ||
                  newState is ProductFailedState;
            },
            builder: (context, state) {
              if (state is ProductSearchFailedState) {
                if (state.message.toLowerCase() == 'no result found') {
                  return const SizedBox.shrink();
                }
                return DefaultErrorScreen(
                  message: state.message,
                );
              }
              if (state is ProductLoadedState) {
                if (state.searchedProductList.isNotEmpty) {
                  return BlocListener<CartCubit, CartState>(
                    listenWhen: (_, newState) {
                      return newState is CartAddFailedState ||
                          newState is CartAddSuccessState;
                    },
                    listener: (context, state) {
                      if (state is CartAddSuccessState) {
                        showSnackBar(
                          context: context,
                          title: 'Added to your Cart',
                          message: 'Successful',
                          snackbarType: SnackbarType.success,
                        );
                      }
                      if (state is CartAddFailedState) {
                        showSnackBar(
                          context: context,
                          title: 'Oops',
                          message:
                              state.message.replaceAll('Exception:', '').trim(),
                          snackbarType: SnackbarType.error,
                        );
                      }
                    },
                    child: AlignedGridView.count(
                      mainAxisSpacing: 2,
                      crossAxisCount: 2,
                      crossAxisSpacing: kDefaultPadding,
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(kBorderRadius - 4),
                      itemCount: state.searchedProductList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ProductCard(
                          modelData: state.searchedProductList[index],
                          onTap: () async {
                            context.pushNamed(AppRoute.productDetail.toName,
                                params: {
                                  'id': state
                                      .searchedProductList[index].productId!
                                      .toString(),
                                  'name':
                                      state.searchedProductList[index].name!,
                                });
                          },
                        );
                      },
                    ),
                  );
                }
                return BlocListener<CartCubit, CartState>(
                  listenWhen: (_, newState) {
                    return newState is CartAddFailedState ||
                        newState is CartAddSuccessState;
                  },
                  listener: (context, state) {
                    if (state is CartAddSuccessState) {
                      showSnackBar(
                        context: context,
                        title: 'Added to your Cart',
                        message: 'Successful',
                        snackbarType: SnackbarType.success,
                      );
                    }
                    if (state is CartAddFailedState) {
                      showSnackBar(
                        context: context,
                        title: 'Oops',
                        message:
                            state.message.replaceAll('Exception:', '').trim(),
                        snackbarType: SnackbarType.error,
                      );
                    }
                  },
                  child: AlignedGridView.count(
                    mainAxisSpacing: 2,
                    crossAxisCount: 2,
                    crossAxisSpacing: kDefaultPadding,
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(kBorderRadius - 4),
                    itemCount: state.productList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ProductCard(
                        modelData: state.productList[index],
                        onTap: () async {
                          context.pushNamed(AppRoute.productDetail.toName,
                              params: {
                                'id': state.productList[index].productId!
                                    .toString(),
                                'name': state.productList[index].name!,
                              });
                        },
                      );
                    },
                  ),
                );
              }
              return const Center(
                child: Text(
                  'Search products',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
