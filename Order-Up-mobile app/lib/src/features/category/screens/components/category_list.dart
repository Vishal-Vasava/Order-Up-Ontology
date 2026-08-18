import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/category/screens/cubit/category_cubit.dart';
import 'package:orderly_ecom/src/features/category/screens/widgets/category_card.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/widgets/default_error_screen.dart';
import 'package:orderly_ecom/src/widgets/shimmer.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen: (_, newState) {
        return newState is CategoryFailedState ||
            newState is CategoryLoadedState ||
            newState is CategoryLoadingState;
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
          return DefaultErrorScreen(
            message: state.message,
          );
        }
        if (state is CategoryLoadingState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [
                  ...List.generate(
                    4,
                    (index) => const AppShimmer(
                      height: 100.0,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is CategoryLoadedState) {
          if (state.categoryList.isEmpty) {
            return const Center(
              child: DefaultErrorScreen(
                message: 'No Categories Yet!',
              ),
            );
          }
          return ListView.builder(
            itemCount: state.categoryList.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext _, int index) {
              return CategoryCard(
                modelData: state.categoryList[index],
                onTap: () {
                  context.goNamed(AppRoute.productAll.toName, params: {
                    'index': index.toString(),
                    'categoryId': state.categoryList[index].id!.toString(),
                  });
                },
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
