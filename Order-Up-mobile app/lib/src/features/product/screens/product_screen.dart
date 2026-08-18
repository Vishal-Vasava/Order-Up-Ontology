import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/category/screens/category_avatar_banner.dart';
import 'package:orderly_ecom/src/features/category/screens/cubit/category_cubit.dart';
import 'package:orderly_ecom/src/features/customer/widgets/customer_app_bar.dart';
import 'package:orderly_ecom/src/features/location/data/location_local_repository.dart';
import 'package:orderly_ecom/src/features/product/screens/components/filters_list.dart';
import 'package:orderly_ecom/src/features/product/screens/components/product_list.dart';
import 'package:orderly_ecom/src/features/product/screens/cubit/product_cubit.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/widgets/ai_intent_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late RefreshController refreshController;

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await bindApiData();
    });
  }

  Future<void> bindApiData() async {
    final latitude = inject.get<LocationLocalRepository>().latitude;
    final longitude = inject.get<LocationLocalRepository>().longitude;
    await context.read<CategoryCubit>().getCategoryList(
          custLat: latitude,
          custLong: longitude,
          isRefresh: true,
        );
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomerAppBar(
        title: 'home',
      ),
      body: SmartRefresher(
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
        primary: false,
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
          primary: false,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            // InkWell(
            //   onTap: () {
            //     context.goNamed(AppRoute.search.toName);
            //   },
            //   child: const ProductSearchBar(),
            // ),
            CategoryAvatar(),
            AiIntentBar(
              negotiationEnabled: true,
              hintText: 'Ask this store for a better basket price…',
            ),
            FiltersList(),
            ProductList(),
            gapH32,
          ],
        ),
      ),
    );
  }
}
