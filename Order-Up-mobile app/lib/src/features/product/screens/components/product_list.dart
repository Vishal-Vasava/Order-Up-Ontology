import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/cart/screens/cubit/cart_cubit.dart';
import 'package:orderly_ecom/src/features/product/screens/cubit/product_cubit.dart';
import 'package:orderly_ecom/src/features/product/screens/widgets/product_card.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/widgets/default_error_screen.dart';
import 'package:shimmer/shimmer.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      buildWhen: (_, newState) {
        return newState is ProductLoadedState ||
            newState is ProductLoadingState ||
            newState is ProductFailedState;
      },
      builder: (context, state) {
        if (state is ProductFailedState) {
          if (state.message.toLowerCase() == 'no result found') {
            return const SizedBox.shrink();
          }
          return DefaultErrorScreen(
            message: state.message,
          );
        }
        if (state is ProductLoadingState) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: !kIsWeb
                  ? Platform.isAndroid
                      ? 80 / 92
                      : 80 / 94
                  : 80.0,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 2,
            ),
            itemBuilder: (c, i) {
              return FadeInUp(
                child: Card(
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white, width: 0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Shimmer.fromColors(
                    baseColor: Theme.of(context).hoverColor,
                    highlightColor: Theme.of(context).highlightColor,
                    enabled: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 110,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.zero,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Loading',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: AppColor.textColor,
                                  ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Loading...',
                          maxLines: 1,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        if (state is ProductLoadedState) {
          if (state.productList.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Text(
                  AppLocalizations.of(context)!.no_data,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            );
          }
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
                    message: state.message.replaceAll('Exception:', '').trim(),
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
                      context.pushNamed(AppRoute.productDetail.toName, params: {
                        'id': state.searchedProductList[index].productId!
                            .toString(),
                        'name': state.searchedProductList[index].name!,
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
                  message: state.message.replaceAll('Exception:', '').trim(),
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
                    context.pushNamed(AppRoute.productDetail.toName, params: {
                      'id': state.productList[index].productId!.toString(),
                      'name': state.productList[index].name!,
                    });
                  },
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
