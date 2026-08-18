import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/category/screens/cubit/category_cubit.dart';
import 'package:orderly_ecom/src/features/product/screens/components/banner_card.dart';
import 'package:orderly_ecom/src/features/product/screens/cubit/product_cubit.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/widgets/image_builder.dart';
import 'package:orderly_ecom/src/widgets/shimmer.dart';
import 'package:orderly_ecom/src/features/category/screens/widgets/category_card.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';

class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryCubit, CategoryState>(
      listener: (context, state) async {
        if (state is CategoryLoadedState) {
          context.read<ProductCubit>().nextCursorPagination = '';
          context.read<ProductCubit>().endPagination = true;
          await context.read<ProductCubit>().getProductList(
                storeId: state.categoryList[state.selectedCategoryIndex].id!,
                nextCursor: '',
                isRefresh: true,
              );
        }
        if (state is CategoryFailedState) {
          if (state.message == 'No result found') {
            if (context.mounted) {
              context.read<ProductCubit>().nextCursorPagination = '';
              context.read<ProductCubit>().endPagination = true;
              // await context.read<ProductCubit>().getProductList(
              //       storeId: '',
              //       nextCursor: '',
              //       isRefresh: true,
              //     );
            }
          }
        }
      },
      buildWhen: (_, newState) {
        return newState is CategoryLoadedState ||
            newState is CategoryLoadingState ||
            newState is CategoryFailedState;
      },
      builder: (context, state) {
        if (state is CategoryFailedState) {
          if (state.message == 'No result found') {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.2,
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.location_no_data,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            );
          }
        }
        if (state is CategoryLoadingState) {
          return Row(
            children: [
              ...List.generate(
                4,
                (index) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: AppShimmer(
                    height: 40.0,
                    width: 40.0,
                  ),
                ),
              ),
            ],
          );
        }
        if (state is CategoryLoadedState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: kDefaultPadding, top: kBorderRadius),
                child: Text(
                  'Trustworthy Brands In Your Area',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColor.textColor,
                      ),
                ),
              ),
              SizedBox(
                height: 100.0,
                child: ListView.builder(
                  itemCount: state.categoryList.length,
                  scrollDirection: Axis.horizontal,
                  // padding: const EdgeInsets.only(right: kBorderRadius),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        onTap: () async {
                          if (state.selectedCategoryIndex != index) {
                            context.read<CategoryCubit>().updateCategoryId(
                                  categoryIndex: index,
                                );
                          }
                          context.read<ProductCubit>().nextCursorPagination =
                              '';

                          await context.read<ProductCubit>().getProductList(
                                storeId: state.categoryList[index].id!,
                                nextCursor: '',
                                isRefresh: true,
                              );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            gapH12,
                            DottedBorder(
                              borderType: BorderType.Circle,
                              dashPattern: const [10, 4],
                              strokeWidth: 1,
                              color: state.selectedCategoryIndex == index
                                  ? AppColor.accentColor
                                  : Colors.transparent,
                              child: ImageBuilder(
                                imageUrl: state.categoryList[index].iconUrl!,
                                height: state.selectedCategoryIndex == index
                                    ? 50.0
                                    : 52.0,
                                width: state.selectedCategoryIndex == index
                                    ? 50.0
                                    : 52.0,
                                borderRadius: 25.0,
                                borderColor: Colors.transparent,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 3),
                              child: Text(
                                state.categoryList[index].name ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color:
                                          state.selectedCategoryIndex == index
                                              ? AppColor.primaryColor
                                              : AppColor.textColor,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Keep the store-banner feature available, but do not render its
              // broken placeholder until the selected store has a banner.
              if (state.categoryList.isNotEmpty &&
                  (state.categoryList[state.selectedCategoryIndex].bannerUrl ?? '')
                      .trim()
                      .isNotEmpty)
                CategoryCard(
                  modelData: state.categoryList[state.selectedCategoryIndex],
                  onTap: null,
                ),
              const BannerCard(),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
