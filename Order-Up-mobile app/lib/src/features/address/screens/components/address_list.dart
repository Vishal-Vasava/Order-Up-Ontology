import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/address/screens/cubit/address_cubit.dart';
import 'package:orderly_ecom/src/features/address/screens/widgets/address_card.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/widgets/default_error_screen.dart';
import 'package:orderly_ecom/src/widgets/shimmer.dart';

class AddressList extends StatelessWidget {
  const AddressList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressCubit, AddressState>(
      listenWhen: (_, newState) {
        return newState is AddressUpdateFailedState ||
            newState is AddressDeleteFailedState ||
            newState is AddressDeleteSuccessState;
      },
      listener: (context, state) {
        if (state is AddressUpdateFailedState) {
          showSnackBar(
            context: context,
            title: 'Failed to update',
            message: state.message,
            snackbarType: SnackbarType.error,
          );
        }
        if (state is AddressDeleteFailedState) {
          showSnackBar(
            context: context,
            title: 'Failed to delete',
            message: state.message,
            snackbarType: SnackbarType.error,
          );
        }
      },
      buildWhen: (_, newState) {
        return newState is AddressLoadedState ||
            newState is AddressLoadingState ||
            newState is AddressFailedState;
      },
      builder: (context, state) {
        if (state is AddressFailedState) {
          return DefaultErrorScreen(
            message: state.message,
          );
        }
        if (state is AddressLoadingState) {
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
        if (state is AddressLoadedState) {
          if (state.addressList.isEmpty) {
            return const Center(
              child: DefaultErrorScreen(
                message: 'No Address Yet!',
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              await context.read<AddressCubit>().getAddressList();
            },
            child: ListView.builder(
              itemCount: state.addressList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext _, int index) {
                return AddressCard(
                  modelData: state.addressList[index],
                  showButton: true,
                  selectedAddressId: '-1',
                  onTap: () {
                    // context.read<AddressCubit>().selectAddress(
                    //     addressId:
                    //         state.addressList[index].uaId ?? 0);
                  },
                  onDelete: () async {
                    HapticFeedback.mediumImpact();
                    await context.read<AddressCubit>().deleteAddress(
                          addressId: state.addressList[index].id!,
                        );
                  },
                  onEdit: () {
                    context.pushNamed(AppRoute.editAddress.toName, params: {
                      'addressId': state.addressList[index].id!,
                    });
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
