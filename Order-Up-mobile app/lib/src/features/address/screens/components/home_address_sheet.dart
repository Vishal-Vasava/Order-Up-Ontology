// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/address/domain/postal_code.dart';
import 'package:orderly_ecom/src/features/address/screens/cubit/address_cubit.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/features/address/screens/widgets/address_card.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/category/screens/cubit/category_cubit.dart';
import 'package:orderly_ecom/src/features/location/data/location_local_repository.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:orderly_ecom/src/widgets/app_dialog.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeAddressSheet extends StatefulWidget {
  const HomeAddressSheet({super.key});

  @override
  State<HomeAddressSheet> createState() => _HomeAddressSheetState();
}

class _HomeAddressSheetState extends State<HomeAddressSheet> {
  List<String> countryList = [
    'India',
    'US',
  ];
  final ValueNotifier<String> selectedCountry = ValueNotifier<String>('US');

  @override
  Widget build(BuildContext context) {
    context.read<AddressCubit>().getAddressList();
    final zipSearchController = TextEditingController();
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: ValueListenableBuilder(
          valueListenable:
              inject.get<AuthLocalRepository>().userBox.listenable(),
          builder: (context, value, _) {
            final user = value.values.elementAt(0);
            return Visibility(
              visible: user.signupType != 'Guest',
              replacement: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search for Zip code',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  gapH16,
                  Text(
                    'Country',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  gapH8,
                  Row(
                    children: [
                      SizedBox(
                        width: 70.0,
                        child: ValueListenableBuilder(
                          valueListenable: selectedCountry,
                          builder: (BuildContext context, String value,
                              Widget? child) {
                            return DropdownButtonFormField(
                              isExpanded: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select one Country';
                                }
                                if (value.isEmpty) {
                                  return 'Please select one Country';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Select Country',
                              ),
                              value: value.isEmpty ? null : value,
                              onChanged: (data) {
                                selectedCountry.value = data!;
                              },
                              items: countryList.map<DropdownMenuItem>(
                                (value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      value,
                                    ),
                                  );
                                },
                              ).toList(),
                            );
                          },
                        ),
                      ),
                      gapW12,
                      Expanded(
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
                            controller: zipSearchController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Search Zip'.hardcoded,
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
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  PhosphorIcons.x,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                            ),
                            onChanged: (value) async {
                              if (value.length >= 5) {
                                await _callAPIForPincode(zipCode: value);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              child: BlocBuilder<AddressCubit, AddressState>(
                buildWhen: (oldState, newState) {
                  return newState is AddressLoadedState ||
                      newState is AddressLoadingState;
                },
                builder: (context, state) {
                  if (state is AddressLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is AddressLoadedState) {
                    if (state.addressList.isEmpty) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context)!.no_data,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.choose_location,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .select_delivery_location,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.22,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: state.addressList.length,
                            itemBuilder: (c, i) {
                              return AddressCard(
                                modelData: state.addressList[i],
                                showButton: false,
                                selectedAddressId: state.destinationAddressId!,
                                onTap: () {
                                  context.read<AddressCubit>().selectAddress(
                                      destinationAddressId:
                                          state.addressList[i].id!);
                                },
                                onDelete: () async {
                                  await context
                                      .read<AddressCubit>()
                                      .deleteAddress(
                                          addressId: state.addressList[i].id!);
                                },
                                onEdit: () {
                                  context.pushNamed(AppRoute.editAddress.toName,
                                      params: {
                                        'addressId': state.addressList[i].id!,
                                      });
                                },
                              );
                            },
                          ),
                        ),
                        Center(
                          child: CupertinoButton(
                            color: AppColor.primaryColor,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .change_password
                                  .substring(
                                      0,
                                      AppLocalizations.of(context)!
                                          .change_password
                                          .indexOf(' '))
                                  .trim(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: AppColor.whiteColor,
                                  ),
                            ),
                            onPressed: () async {
                              final address = state.addressList.firstWhere(
                                  (element) =>
                                      element.id! ==
                                      state.destinationAddressId!);
                              inject
                                  .get<LocationLocalRepository>()
                                  .setLatitude(address.latitude ?? '');
                              inject
                                  .get<LocationLocalRepository>()
                                  .setLongitude(address.longitude ?? '');
                              inject
                                  .get<AuthLocalRepository>()
                                  .setUserAddress(address.address ?? '');
                              inject
                                  .get<AuthLocalRepository>()
                                  .setUserAddressId(address.id.toString());
                              context.pop();
                              await context
                                  .read<CategoryCubit>()
                                  .getCategoryList(
                                    custLat: address.latitude ?? '',
                                    custLong: address.longitude ?? '',
                                    isRefresh: true,
                                  );
                            },
                          ),
                        ),
                        gapH12,
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _callAPIForPincode({required String zipCode}) async {
    late PostalCode? postalCode;
    try {
      AppDialog.showLoader(context);
      final url = Endpoints.worldPostalLocationApi(
        pinCode: zipCode,
        countryCode: selectedCountry.value,
      );
      final response = await Dio().get(url);
      postalCode = PostalCode.fromJson(response.data);
      if (postalCode.message?.toLowerCase() == 'success') {
        if (postalCode.result != null && postalCode.result!.isNotEmpty) {
          inject
              .get<LocationLocalRepository>()
              .setLatitude(postalCode.result![0].latitude);
          inject
              .get<LocationLocalRepository>()
              .setLongitude(postalCode.result![0].longitude);
          inject.get<AuthLocalRepository>().setUserAddress(zipCode);
          inject.get<AuthLocalRepository>().setUserAddressId('');
          context.pop();
          context.pop();
          await context.read<CategoryCubit>().getCategoryList(
                custLat: postalCode.result![0].latitude,
                custLong: postalCode.result![0].longitude,
                isRefresh: true,
              );
          // setState(() {
          //   postResultList = postalCode?.result ?? [];
          //   if (postResultList.isEmpty) {
          //     addressController.text = '';
          //   } else {
          //     addressController.text =
          //         '${postResultList[0].postalCode}, ${postResultList[0].state},'
          //         '${postResultList[0].country}, ${postResultList[0].postalLocation},${postResultList[0].province}';
          //     cityController.text = postResultList[0].province;
          //     stateController.text = postResultList[0].state;
          //     countryController.text = postResultList[0].country;
          //     latitude = postResultList[0].latitude;
          //     longitude = postResultList[0].longitude;
          //   }
          // });
        }
      }
    } on DioException catch (e) {
      DioExceptions.fromDioError(e).toString();
    }
  }
}
