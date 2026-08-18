import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/product/screens/cubit/product_cubit.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProductSearchBar extends StatefulWidget {
  const ProductSearchBar({super.key});

  @override
  _ProductSearchBarState createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
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
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: const [
                  BoxShadow(
                    color: AppColor.kShadowColor,
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
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
                    color: AppColor.errorColor,
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
                            context
                                .read<ProductCubit>()
                                .searchProduct(search: '');
                          },
                          icon: const Icon(
                            PhosphorIcons.x,
                            color: AppColor.primaryColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                onChanged: (value) {
                  searchNotifier.value = value;
                  context.read<ProductCubit>().searchProduct(search: value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
