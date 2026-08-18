import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/manager/features/claims/screens/cubit/claim_cubit.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ClaimSearchBar extends StatefulWidget {
  const ClaimSearchBar({super.key});

  @override
  _ClaimSearchBarState createState() => _ClaimSearchBarState();
}

class _ClaimSearchBarState extends State<ClaimSearchBar> {
  late TextEditingController searchController;

  final ValueNotifier<String> searchNotifier = ValueNotifier<String>('');

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
    return BlocBuilder<ClaimCubit, ClaimState>(
      buildWhen: (_, newState) {
        return newState is ClaimLoadedState || newState is ClaimLoadingState;
      },
      builder: (context, state) {
        if (state is ClaimLoadingState) {
          return const SizedBox();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 4, vertical: kBorderRadius),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColor.scaleGreyColor,
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 5),
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
                                context.read<ClaimCubit>().search(
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
                      context.read<ClaimCubit>().search(
                            searchText: value,
                          );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
