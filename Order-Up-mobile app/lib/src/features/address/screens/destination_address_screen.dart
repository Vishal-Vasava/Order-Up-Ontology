// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/features/address/screens/cubit/address_cubit.dart';
import 'package:orderly_ecom/src/features/address/screens/widgets/address_card.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/cart/screens/cubit/cart_cubit.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/widgets/app_button.dart';
import 'package:shimmer/shimmer.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';

class DestinationAddressScreen extends StatefulWidget {
  const DestinationAddressScreen({super.key});

  @override
  _DestinationAddressScreenState createState() =>
      _DestinationAddressScreenState();
}

class _DestinationAddressScreenState extends State<DestinationAddressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AddressCubit>().getAddressList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderlyAppBar(
        title: AppLocalizations.of(context)!.dest_add,
        action: [
          BlocBuilder<AddressCubit, AddressState>(
            buildWhen: (oldState, newState) {
              return newState is AddressLoadedState;
            },
            builder: (context, state) {
              return IconButton(
                onPressed: () async {
                  context.pushNamed(AppRoute.addAddress.toName);
                },
                icon: const Icon(
                  kIsWeb ? Icons.add : Iconsax.add,
                  size: 30.0,
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BlocListener<AddressCubit, AddressState>(
        listenWhen: (_, newState) {
          return newState is AddressCheckLoadingState ||
              newState is AddressCheckSuccessState ||
              newState is AddressCheckSuccessState;
        },
        listener: (context, state) {
          if (state is AddressCheckFailedState) {
            showSnackBar(
              context: context,
              title: state.message,
              message: 'Please change Address',
              snackbarType: SnackbarType.error,
              duration: 4,
            );
          }
          if (state is AddressCheckSuccessState) {
            inject.get<AuthLocalRepository>().setUserAddress(state.address);
            if (context.mounted) {}
            context.pushNamed(AppRoute.paymentPage.toName);
          }
        },
        child: BlocBuilder<AddressCubit, AddressState>(
          builder: (context, addressState) {
            if (addressState is AddressLoadedState) {
              if (addressState.addressList.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: AppButton(
                    onPressed: () async {
                      await context
                          .read<AddressCubit>()
                          .checkAddressBeforeOrder(
                            context: context,
                            sourceAddressId: addressState.sourceAddressId ?? '',
                            addressList: addressState.addressList,
                            destinationAddressId:
                                addressState.destinationAddressId!,
                          );
                      await context.read<CartCubit>().getCartList(
                            latitude: context
                                    .read<AddressCubit>()
                                    .address!
                                    .latitude ??
                                '',
                            longitude: context
                                    .read<AddressCubit>()
                                    .address!
                                    .longitude ??
                                '',
                          );
                    },
                    isLoading: false,
                    buttonText: AppLocalizations.of(context)!.submit,
                  ),
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      body: BlocBuilder<AddressCubit, AddressState>(
        buildWhen: (_, newState) {
          return newState is AddressLoadedState ||
              newState is AddressLoadingState ||
              newState is AddressFailedState;
        },
        builder: (context, state) {
          if (state is AddressLoadingState) {
            return ListView.builder(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (c, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Shimmer.fromColors(
                    baseColor: Theme.of(context).hoverColor,
                    highlightColor: Theme.of(context).highlightColor,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 5,
                            bottom: 5,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 10,
                                width: 180,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 5),
                              ),
                              Container(
                                height: 10,
                                width: 150,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: 6,
            );
          }
          if (state is AddressFailedState) {
            return Center(child: Text(state.message));
          }
          if (state is AddressLoadedState) {
            context.read<CartCubit>().destinationId =
                state.destinationAddressId!;
            if (state.addressList.isEmpty) {
              return Center(
                child: Text(
                  AppLocalizations.of(context)!.no_data,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<AddressCubit>().getAddressList();
              },
              child: ListView.builder(
                itemCount: state.addressList.length,
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (c, index) {
                  return SlideInRight(
                    duration: Duration(milliseconds: 80 * index),
                    child: AddressCard(
                      modelData: state.addressList[index],
                      showButton: true,
                      selectedAddressId: state.destinationAddressId!,
                      onTap: () {
                        context.read<CartCubit>().destinationId =
                            state.addressList[index].id!;
                        context.read<AddressCubit>().selectAddress(
                            destinationAddressId: state.addressList[index].id!);
                      },
                      onDelete: () async {
                        await context.read<AddressCubit>().deleteAddress(
                            addressId: state.addressList[index].id!);
                      },
                      onEdit: () {
                        context.pushNamed(AppRoute.editAddress.toName, params: {
                          'addressId': state.addressList[index].id!
                        });
                      },
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
