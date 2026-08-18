import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/screens/cubit/inventory_cubit.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/screens/widgets/inventory_card.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/widgets/app_dialog.dart';
import 'package:orderly_ecom/src/widgets/confirmation_dialog.dart';
import 'package:orderly_ecom/src/widgets/default_error_screen.dart';
import 'package:orderly_ecom/src/widgets/shimmer.dart';

class InventoryList extends StatelessWidget {
  const InventoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InventoryCubit, InventoryState>(
      listenWhen: (_, newState) {
        return newState is InventoryDeleteFailedState ||
            newState is InventoryDeleteSuccessState;
      },
      listener: (_, state) {
        if (state is InventoryDeleteFailedState) {
          showSnackBar(
            context: context,
            title: 'Oops',
            message: state.message,
            snackbarType: SnackbarType.error,
          );
        }
        if (state is InventoryDeleteSuccessState) {
          context.pop();
          showSnackBar(
            context: context,
            title: 'Success',
            message: 'Item has been deleted',
            snackbarType: SnackbarType.success,
          );
        }
      },
      buildWhen: (_, newState) {
        return newState is InventoryLoadingState ||
            newState is InventoryLoadedState ||
            newState is InventoryFailedState;
      },
      builder: (context, state) {
        if (state is InventoryFailedState) {
          return DefaultErrorScreen(
            message: state.message,
          );
        }
        if (state is InventoryLoadingState) {
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
        if (state is InventoryLoadedState) {
          if (state.inventoryList.isEmpty) {
            return const Center(
              child: DefaultErrorScreen(
                message: 'No Products Yet!',
              ),
            );
          }
          if (isDesktop(context) || isTablet(context)) {
            if (state.searchInventoryList.isNotEmpty) {
              return Expanded(
                child: AlignedGridView.count(
                  shrinkWrap: true,
                  primary: false,
                  crossAxisCount: 3,
                  // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //   crossAxisCount: 3,
                  //   mainAxisExtent: MediaQuery.of(context).size.height * 0.33,
                  //   childAspectRatio: 4,
                  //   crossAxisSpacing: kDefaultPadding,
                  // ),
                  itemCount: state.searchInventoryList.length,
                  // shrinkWrap: true,
                  itemBuilder: (BuildContext c, int index) {
                    return InventoryCard(
                      modelData: state.searchInventoryList[index],
                      onEdit: () {
                        context.goNamed(AppRoute.inventoryEdit.toName,
                            extra: state.searchInventoryList[index]);
                      },
                      onRemove: () {
                        AppDialog.viewDialog(
                          context: context,
                          content: ConfirmationDialog(
                            title: 'Are you Sure?',
                            message: 'You want to delete this dish.',
                            height: MediaQuery.of(context).size.height * 0.17,
                            width: MediaQuery.of(context).size.width * 0.85,
                            onConfirm: () async {
                              await context
                                  .read<InventoryCubit>()
                                  .deleteInventory(
                                    productId:
                                        state.searchInventoryList[index].id!,
                                  );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            }
            return Expanded(
              child: AlignedGridView.count(
                // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //   crossAxisCount: 3,
                //   mainAxisExtent: MediaQuery.of(context).size.height * 0.33,
                //   childAspectRatio: 4,
                //   crossAxisSpacing: kDefaultPadding,
                // ),
                itemCount: state.inventoryList.length,
                shrinkWrap: true,
                primary: false,
                crossAxisCount: 3,
                itemBuilder: (BuildContext c, int index) {
                  return InventoryCard(
                    modelData: state.inventoryList[index],
                    onEdit: () {
                      context.goNamed(AppRoute.inventoryEdit.toName,
                          extra: state.inventoryList[index]);
                    },
                    onRemove: () {
                      AppDialog.viewDialog(
                        context: context,
                        content: ConfirmationDialog(
                          title: 'Are you Sure?',
                          message: 'You want to delete this dish.',
                          height: MediaQuery.of(context).size.height * 0.17,
                          width: MediaQuery.of(context).size.width * 0.85,
                          onConfirm: () async {
                            await context
                                .read<InventoryCubit>()
                                .deleteInventory(
                                  productId: state.inventoryList[index].id!,
                                );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
          if (state.searchInventoryList.isNotEmpty) {
            return Expanded(
              child: ListView.builder(
                itemCount: state.searchInventoryList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext c, int index) {
                  return InventoryCard(
                    modelData: state.searchInventoryList[index],
                    onEdit: () {
                      context.goNamed(AppRoute.inventoryEdit.toName,
                          extra: state.searchInventoryList[index]);
                    },
                    onRemove: () {
                      AppDialog.viewDialog(
                        context: context,
                        content: ConfirmationDialog(
                          title: 'Are you Sure?',
                          message: 'You want to delete this dish.',
                          height: MediaQuery.of(context).size.height * 0.17,
                          width: MediaQuery.of(context).size.width * 0.85,
                          onConfirm: () async {
                            await context
                                .read<InventoryCubit>()
                                .deleteInventory(
                                  productId:
                                      state.searchInventoryList[index].id!,
                                );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
          return Expanded(
            child: ListView.builder(
              itemCount: state.inventoryList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext c, int index) {
                return InventoryCard(
                  modelData: state.inventoryList[index],
                  onEdit: () {
                    context.goNamed(AppRoute.inventoryEdit.toName,
                        extra: state.inventoryList[index]);
                  },
                  onRemove: () {
                    AppDialog.viewDialog(
                      context: context,
                      content: ConfirmationDialog(
                        title: 'Are you Sure?',
                        message: 'You want to delete this dish.',
                        height: MediaQuery.of(context).size.height * 0.17,
                        width: MediaQuery.of(context).size.width * 0.85,
                        onConfirm: () async {
                          await context.read<InventoryCubit>().deleteInventory(
                                productId: state.inventoryList[index].id!,
                              );
                        },
                      ),
                    );
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
