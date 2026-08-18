import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/cart/screens/cubit/cart_cubit.dart';
import 'package:orderly_ecom/src/features/category/screens/cubit/category_cubit.dart';
import 'package:orderly_ecom/src/features/category/screens/widgets/category_card.dart';
import 'package:orderly_ecom/src/features/location/data/location_local_repository.dart';
import 'package:orderly_ecom/src/features/product/screens/components/product_list.dart';
import 'package:orderly_ecom/src/features/product/screens/cubit/product_cubit.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';

class ProductSingleList extends StatefulWidget {
  const ProductSingleList({
    super.key,
    required this.categoryId,
    required this.index,
  });
  final String categoryId;
  final int index;
  @override
  State<ProductSingleList> createState() => _ProductSingleListState();
}

class _ProductSingleListState extends State<ProductSingleList> {
  late RefreshController refreshController;

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ProductCubit>().getProductList(
            storeId: widget.categoryId,
            nextCursor: '',
            isRefresh: true,
          );
    });
  }

  Future<void> bindApiData() async {
    final latitude = inject.get<LocationLocalRepository>().latitude;
    final longitude = inject.get<LocationLocalRepository>().longitude;
    await context.read<CategoryCubit>().getCategoryList(
          custLat: latitude,
          custLong: longitude,
        );
    if (context.mounted) {
      await context.read<ProductCubit>().getProductList(
            storeId: widget.categoryId,
            nextCursor: '',
            isRefresh: true,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: AppColor.textColor,
        ),
        leading: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            if (context.canPop()) {
              context.pop();
            }
          },
          child: Container(
            margin: const EdgeInsets.only(left: 12, right: 6.0),
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.whiteColor,
              boxShadow: [
                BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(0, 5),
                  color: AppColor.kShadowColor,
                ),
              ],
            ),
            child: const Icon(
              kIsWeb ? Icons.arrow_left_outlined : Iconsax.arrow_left,
              size: 20.0,
            ),
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.all_categories,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: false,
        actions: [
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
                      kIsWeb
                          ? Icons.shopping_bag_outlined
                          : Iconsax.shopping_bag,
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
            },
          ),
          gapW12,
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        buildWhen: (oldState, _) {
          return oldState is ProductInitialState;
        },
        builder: (context, state) {
          return SmartRefresher(
            controller: refreshController,
            enablePullDown: true,
            enablePullUp: true,
            header: const WaterDropHeader(),
            footer: const ClassicFooter(
              noDataText: 'Empty',
              canLoadingText: '',
              idleText: '',
              idleIcon: Center(),
              failedText: '',
            ),
            physics: const BouncingScrollPhysics(),
            onRefresh: () async {
              await bindApiData();
              refreshController.refreshCompleted();
            },
            onLoading: () async {
              try {
                if (!context.read<ProductCubit>().endPagination) {
                  await context.read<ProductCubit>().getProductList(
                        storeId: context
                            .read<CategoryCubit>()
                            .categoryList[
                                context.read<CategoryCubit>().categoryIndex]
                            .id!,
                        nextCursor: '',
                        isRefresh: false,
                      );
                }
              } catch (e) {
                refreshController.loadFailed();
              }
              refreshController.loadComplete();
            },
            child: ListView(
              shrinkWrap: true,
              primary: false,
              padding: EdgeInsets.zero,
              children: [
                gapH8,
                CategoryCard(
                  modelData: context
                      .read<CategoryCubit>()
                      .categoryList
                      .firstWhere(
                          (element) => element.id! == widget.categoryId),
                  onTap: null,
                ),
                const ProductList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
