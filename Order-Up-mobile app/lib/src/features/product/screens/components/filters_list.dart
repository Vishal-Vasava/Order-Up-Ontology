import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/category/screens/cubit/category_cubit.dart';
import 'package:orderly_ecom/src/features/product/screens/cubit/product_cubit.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/widgets/image_builder.dart';
import 'package:orderly_ecom/src/widgets/shimmer.dart';

class FiltersList extends StatefulWidget {
  const FiltersList({super.key});

  @override
  State<FiltersList> createState() => _FiltersListState();
}

class _FiltersListState extends State<FiltersList> {
  @override
  void initState() {
    super.initState();
    // context.read<ProductCubit>().selectedFiltersList = ['0'];
    context.read<ProductCubit>().getFilters();
  }

  @override
  void deactivate() {
    super.deactivate();
    if (!context.read<ProductCubit>().isClosed) {
      context.read<ProductCubit>().resetFilterList();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      buildWhen: (_, newState) {
        return newState is ProductFiltersFailedState ||
            newState is ProductFiltersLoadedState ||
            newState is ProductFiltersLoadingState;
      },
      builder: (context, state) {
        if (state is ProductFiltersFailedState) {
          return const Center(
            child: Text('Failed to load filters.'),
          );
        }
        if (state is ProductFiltersLoadingState) {
          return AppShimmer(
            height: 60,
            width: MediaQuery.of(context).size.width,
          );
        }
        if (state is ProductFiltersLoadedState) {
          if (state.filtersList.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: kDefaultPadding, top: kBorderRadius),
                  child: Text(
                    'Filters',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        state.filtersList.length,
                        (index) {
                          final isSelected = context
                              .read<ProductCubit>()
                              .selectedFiltersList
                              .contains(state.filtersList[index].id!);
                          return GestureDetector(
                            onTap: () async {
                              HapticFeedback.lightImpact();
                              if (!context
                                  .read<ProductCubit>()
                                  .selectedFiltersList
                                  .contains(state.filtersList[index].id!)) {
                                context
                                    .read<ProductCubit>()
                                    .selectedFiltersList
                                    .add(state.filtersList[index].id!);
                              } else {
                                context
                                    .read<ProductCubit>()
                                    .selectedFiltersList
                                    .remove(state.filtersList[index].id!);
                              }
                              context.read<ProductCubit>().emitSelectedFilter();
                              await context.read<ProductCubit>().getProductList(
                                    storeId: context
                                        .read<CategoryCubit>()
                                        .categoryList[context
                                            .read<CategoryCubit>()
                                            .categoryIndex]
                                        .id!,
                                    nextCursor: '',
                                    isRefresh: false,
                                  );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: kBorderRadius),
                              child: DottedBorder(
                                borderType: BorderType.Rect,
                                dashPattern: const [12, 2],
                                padding: EdgeInsets.zero,
                                strokeWidth: 0.8,
                                color: isSelected
                                    ? AppColor.primaryColor
                                    : AppColor.greyColor,
                                child: Container(
                                  padding:
                                      state.filtersList[index].iconUrl!.isEmpty
                                          ? const EdgeInsets.all(10)
                                          : const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColor.primaryColor
                                            .withOpacity(0.13)
                                        : AppColor.whiteColor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      state.filtersList[index].iconUrl!.isEmpty
                                          ? const Icon(
                                              Iconsax.sort,
                                              color: AppColor.primaryColor,
                                              size: 22.0,
                                            )
                                          : ImageBuilder(
                                              imageUrl: state
                                                  .filtersList[index].iconUrl!,
                                              height: 30.0,
                                              imgBgColor: Colors.transparent,
                                              borderColor: Colors.transparent,
                                              width: 30.0,
                                              borderRadius: 0,
                                            ),
                                      Text(
                                        state.filtersList[index].name ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      gapW8,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }
        return const SizedBox.shrink();
      },
    );
  }
}
