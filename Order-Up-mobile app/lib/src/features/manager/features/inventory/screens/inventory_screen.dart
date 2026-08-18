import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/screens/components/inventory_add_form.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/screens/components/inventory_list.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/screens/components/inventory_search_bar.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/screens/cubit/inventory_cubit.dart';
import 'package:orderly_ecom/src/features/manager/widgets/manager_app_bar.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/theme/colors.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<InventoryCubit>().getInventoryList();
    });
    debugPrint(inject.get<AuthLocalRepository>().accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCubit, InventoryState>(
      buildWhen: (oldState, _) {
        return oldState is InventoryInitialState;
      },
      builder: (context, state) {
        return Scaffold(
          appBar: ManagerAppBar(
            title: AppLocalizations.of(context)!.inventory,
          ),
          floatingActionButton: InkWell(
            onTap: () {
              // context.goNamed(
              //   AppRoute.inventoryAdd.toName,
              //   extra: null,
              // );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InventoryAddForm(
                    galleryList: null,
                    fromBack: false,
                  ),
                ),
              );
            },
            child: Padding(
              padding: MediaQuery.of(context).padding,
              child: Container(
                height: 40.0,
                width: 115.0,
                margin: const EdgeInsets.only(top: 40.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                  ),
                  color: AppColor.primaryColor,
                ),
                child: Row(
                  children: [
                    gapW4,
                    const CircleAvatar(
                      backgroundColor: AppColor.whiteColor,
                      radius: 18.0,
                      child: Icon(
                        Icons.add,
                      ),
                    ),
                    gapW4,
                    Text(
                      'Add Item',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: AppColor.whiteColor,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await context.read<InventoryCubit>().getInventoryList();
            },
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InventorySearchBar(),
                InventoryList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
