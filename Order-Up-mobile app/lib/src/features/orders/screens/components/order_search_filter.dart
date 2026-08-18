import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/orders/screens/cubit/order_cubit.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OrderSearchFilter extends StatefulWidget {
  const OrderSearchFilter({super.key});

  @override
  _OrderSearchFilterState createState() => _OrderSearchFilterState();
}

class _OrderSearchFilterState extends State<OrderSearchFilter> {
  late TextEditingController searchController;
  ValueNotifier<String> searchNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextFormField(
                controller: searchController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Search here'.hardcoded,
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  constraints: const BoxConstraints(
                    maxHeight: 50.0,
                    minWidth: 30.0,
                  ),
                  prefixIcon: const Icon(
                    kIsWeb ? Icons.search : Iconsax.search_normal_1,
                    color: AppColor.primaryColor,
                    size: 20,
                  ),
                  suffixIcon: ValueListenableBuilder<String>(
                    valueListenable: searchNotifier,
                    builder: (context, state, child) {
                      return AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: state.isEmpty ? 0.0 : 1.0,
                        child: IconButton(
                          onPressed: () {
                            searchController.clear();
                            searchNotifier.value = '';
                            FocusManager.instance.primaryFocus?.unfocus();
                            context.read<OrderCubit>().searchOrders(
                                  searchText: '',
                                );
                          },
                          icon: const Icon(
                            kIsWeb ? Icons.close : PhosphorIcons.x,
                            color: AppColor.primaryColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                onChanged: (value) {
                  searchNotifier.value = value;
                  context.read<OrderCubit>().searchOrders(searchText: value);
                },
              ),
            ),
            Row(
              children: [
                gapW12,
                Text(
                  AppLocalizations.of(context)!.filter,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                IconButton(
                  icon: const Icon(
                    kIsWeb ? Icons.sort : PhosphorIcons.faders,
                  ),
                  onPressed: () {
                    context.goNamed(AppRoute.orderFilter.toName);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
