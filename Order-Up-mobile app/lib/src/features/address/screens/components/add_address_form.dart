import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/constants/app_keys.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/address/domain/address_model.dart';
import 'package:orderly_ecom/src/features/address/domain/postal_code.dart';
import 'package:orderly_ecom/src/features/address/screens/cubit/address_cubit.dart';
import 'package:orderly_ecom/src/features/address/screens/widgets/address_type_chip.dart';
import 'package:orderly_ecom/src/features/location/data/location_local_repository.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/clippers.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/utils/validations.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/widgets/app_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddAddressForm extends StatefulWidget {
  const AddAddressForm({super.key});

  @override
  _AddAddressFormState createState() => _AddAddressFormState();
}

class _AddAddressFormState extends State<AddAddressForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> isZipValid = ValueNotifier<bool>(true);
  final ValueNotifier<bool> markAsDefault = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isHomeAddress = ValueNotifier<bool>(true);

  List<PostalData> postResultList = <PostalData>[];

  List<String> countryList = [
    'India',
    'US',
  ];

  String latitude = '';
  String longitude = '';

  final ValueNotifier<String> selectedCountry = ValueNotifier<String>('');

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController zipController;
  late TextEditingController emailController;
  late TextEditingController mobileController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController countryController;
  late TextEditingController streetNoController;
  late TextEditingController flatNoController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    zipController = TextEditingController();
    emailController = TextEditingController();
    mobileController = TextEditingController();
    addressController = TextEditingController();
    streetNoController = TextEditingController();
    flatNoController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    countryController = TextEditingController();
  }

  Future<void> _callAPIForPincode() async {
    await Future.delayed(const Duration(milliseconds: 800));
    late PostalCode? postalCode;
    try {
      final url = Endpoints.worldPostalLocationApi(
        pinCode: zipController.text.trim(),
        countryCode:
            selectedCountry.value.isEmpty ? 'IN' : selectedCountry.value,
      );
      final response = await Dio().get(url);
      postalCode = PostalCode.fromJson(response.data);
      if (postalCode.message?.toLowerCase() == 'success') {
        if (postalCode.result != null && postalCode.result!.isNotEmpty) {
          isZipValid.value = true;
          setState(() {
            postResultList = postalCode?.result ?? [];
            if (postResultList.isEmpty) {
              addressController.text = '';
            } else {
              addressController.text =
                  '${postResultList[0].postalCode}, ${postResultList[0].state},'
                  '${postResultList[0].country}, ${postResultList[0].postalLocation},${postResultList[0].province}';
              cityController.text = postResultList[0].province;
              stateController.text = postResultList[0].state;
              countryController.text = postResultList[0].country;
              latitude = postResultList[0].latitude;
              longitude = postResultList[0].longitude;
            }
          });
        } else {
          isZipValid.value = false;
        }
      } else {
        isZipValid.value = false;
      }
    } on DioException catch (e) {
      DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    zipController.dispose();
    emailController.dispose();
    mobileController.dispose();
    addressController.dispose();
    streetNoController.dispose();
    flatNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderlyAppBar(
        title: AppLocalizations.of(context)!.address,
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gapH16,
                Text(
                  AppLocalizations.of(context)!.first_name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                gapH8,
                TextFormField(
                  controller: firstNameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  validator: Validator.validateRequired,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.first_name,
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(kBorderRadius - 4),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(kBorderRadius - 4),
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                gapH16,
                Text(
                  AppLocalizations.of(context)!.last_name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                gapH8,
                TextFormField(
                  controller: lastNameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  validator: Validator.validateRequired,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.last_name,
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(kBorderRadius - 4),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(kBorderRadius - 4),
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                gapH16,
                Text(
                  AppLocalizations.of(context)!.email,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                gapH8,
                TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validator.validateEmail,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.email,
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(kBorderRadius - 4),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(kBorderRadius - 4),
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                gapH16,
                Text(
                  AppLocalizations.of(context)!.mobile,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                gapH8,
                TextFormField(
                  controller: mobileController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  validator: Validator.validateMobile,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.mobile,
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(kBorderRadius - 4),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(kBorderRadius - 4),
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                if (!kIsWeb) gapH8,
                if (!kIsWeb)
                  Text(
                    AppLocalizations.of(context)!.address,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                gapH8,
                if (kIsWeb)
                  // TextFormField(
                  //   controller: addressController,
                  //   textInputAction: TextInputAction.next,
                  //   readOnly: true,
                  //   onTap: () async {
                  //     final result = await AppDialog.viewDialog(
                  //       context: context,
                  //       content: const PlacesAutoComplete(
                  //         address: '',
                  //       ),
                  //     );
                  // final AutocompletePrediction data =
                  //     (result as AutocompletePrediction);
                  // addressController.text = data.fullText;
                  //   String lat = data.;
                  //   String lng = data[0]
                  //   List<Placemark> placemark =
                  //       await placemarkFromCoordinates(
                  //           double.parse(lat), double.parse(lng));
                  //   log(placemark[0].toJson().toString());
                  //   if (placemark.isNotEmpty) {
                  //     zipController.text = placemark[0].postalCode ?? ' ';
                  //     countryController.text =
                  //         placemark[0].isoCountryCode.toString();
                  //     stateController.text = placemark[0].street ?? '';
                  //     cityController.text = placemark[0].locality ?? '';

                  //     addressController.text =
                  //         '${placemark[0].name} ${placemark[0].postalCode}, ${placemark[0].subLocality}, ${placemark[0].locality}, ${placemark[0].country}';
                  //     streetNoController.text =
                  //         placemark[0].subLocality ?? '';
                  //   }
                  //     log((result as AutocompletePrediction)
                  //         .toMap()
                  //         .toString());
                  //     final mapResult = await MapBoxGeocoder(AppKey.mapBoxToken)
                  //         .forwardSearch((result).fullText);
                  //     log(mapResult.toString());
                  //   },
                  //   keyboardType: TextInputType.streetAddress,
                  //   decoration: InputDecoration(
                  //     hintText: 'Search your location',
                  //     suffixIcon: IconButton(
                  //       onPressed: () {
                  //         addressController.clear();
                  //       },
                  //       icon: const Icon(
                  //         Icons.clear,
                  //       ),
                  //     ),
                  //     enabledBorder: const OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(
                  //         Radius.circular(kBorderRadius - 4),
                  //       ),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //     border: const OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(
                  //         Radius.circular(kBorderRadius - 4),
                  //       ),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //   ),
                  // )
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      gapH16,
                      Text(
                        'Country',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      gapH8,
                      DropdownButtonHideUnderline(
                        child: Container(
                          padding: const EdgeInsets.only(right: 10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            // color: AppColor.lightAccentColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: AppColor.scaleGreyColor,
                            ), //custom color
                            child: ValueListenableBuilder(
                              valueListenable: selectedCountry,
                              builder: (BuildContext context, String value,
                                  Widget? child) {
                                return ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButtonFormField(
                                    isExpanded: true,
                                    itemHeight: 50,
                                    menuMaxHeight: 300.0,
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
                                    borderRadius:
                                        BorderRadius.circular(kBorderRadius),
                                    icon: const Icon(
                                      kIsWeb
                                          ? Icons.arrow_circle_down
                                          : Iconsax.arrow_circle_down,
                                      size: 20.0,
                                      color: AppColor.blackColor,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Select Country',
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(kBorderRadius - 4),
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(kBorderRadius - 4),
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    value: value.isEmpty ? null : value,
                                    onChanged: (data) {
                                      selectedCountry.value = data!;
                                      countryController.text =
                                          selectedCountry.value;
                                      // widget.onChanged.call(statusNotifier.value);
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
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      gapH16,
                      Text(
                        AppLocalizations.of(context)!.zipcode,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      gapH8,
                      TextFormField(
                        controller: zipController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        readOnly: kIsWeb ? false : true,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.zipcode,
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(kBorderRadius - 4),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(kBorderRadius - 4),
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (zip) {
                          if (zip!.isEmpty || zip.length < 5 || zip[0] == ' ') {
                            return 'Please enter Valid zip code';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.length >= 4) {
                            _callAPIForPincode();
                          }
                        },
                        onEditingComplete: () {
                          if (postResultList.isEmpty) {
                            if (zipController.text.length >= 4) {
                              _callAPIForPincode();
                            }
                          }
                        },
                        onFieldSubmitted: (value) {
                          if (postResultList.isEmpty) {
                            if (value.length >= 4) {
                              _callAPIForPincode();
                            }
                          }
                        },
                      ),
                      gapH8,
                      Text(
                        AppLocalizations.of(context)!.state,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      gapH8,
                      TextFormField(
                        controller: stateController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.streetAddress,
                        validator: Validator.validateRequired,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.state,
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(kBorderRadius - 4),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(kBorderRadius - 4),
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      gapH16,
                      Text(
                        AppLocalizations.of(context)!.city,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      gapH8,
                      TextFormField(
                        controller: cityController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.streetAddress,
                        validator: Validator.validateRequired,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.city,
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(kBorderRadius - 4),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(kBorderRadius - 4),
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      gapH16,
                      Text(
                        AppLocalizations.of(context)!.address,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      gapH8,
                      TextFormField(
                        controller: addressController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.address,
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(kBorderRadius - 4),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(kBorderRadius - 4),
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  GooglePlaceAutoCompleteTextField(
                    textEditingController: addressController,
                    googleAPIKey: AppKey.googlePlacesKey,
                    inputDecoration: InputDecoration(
                      hintText: 'Search your location',
                      suffixIcon: IconButton(
                        onPressed: () {
                          addressController.clear();
                        },
                        icon: const Icon(
                          Icons.clear,
                        ),
                      ),
                    ),
                    textStyle: Theme.of(context).textTheme.titleSmall!,
                    debounceTime: 200,
                    isLatLngRequired: true,
                    getPlaceDetailWithLatLng: (Prediction prediction) async {
                      Future.delayed(const Duration(milliseconds: 400))
                          .then((_) async {
                        String lat = prediction.lat.toString();
                        String lng = prediction.lng.toString();
                        latitude = lat;
                        longitude = lng;
                        List<Placemark> placemark =
                            await placemarkFromCoordinates(
                                double.parse(lat), double.parse(lng));
                        log(placemark[0].toJson().toString());
                        if (placemark.isNotEmpty) {
                          zipController.text = placemark[0].postalCode ?? ' ';
                          countryController.text =
                              placemark[0].isoCountryCode.toString();
                          stateController.text =
                              placemark[0].administrativeArea ?? '';
                          cityController.text = placemark[0].locality ?? '';

                          // addressController.text =
                          //     '${placemark[0].name} ${placemark[0].postalCode}, ${placemark[0].subLocality}, ${placemark[0].locality}, ${placemark[0].country}';
                          addressController.text = prediction.description ?? '';
                          streetNoController.text =
                              placemark[0].subLocality ?? '';
                        }
                      });
                    },
                    itmClick: (Prediction prediction) {},
                  ),
                gapH16,
                // gapH16,
                // Text(
                //   AppLocalizations.of(context)!.address,
                //   style: Theme.of(context).textTheme.titleMedium,
                // ),
                // gapH8,
                // TextFormField(
                //   controller: addressController,
                //   textInputAction: TextInputAction.next,
                //   keyboardType: TextInputType.streetAddress,
                //   validator: Validator.validateRequired,
                //   decoration: InputDecoration(
                //     hintText: AppLocalizations.of(context)!.address,
                //     enabledBorder: const OutlineInputBorder(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(kBorderRadius - 4),
                //       ),
                //       borderSide: BorderSide.none,
                //     ),
                //     border: const OutlineInputBorder(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(kBorderRadius - 4),
                //       ),
                //       borderSide: BorderSide.none,
                //     ),
                //   ),
                // ),
                gapH16,
                Text(
                  AppLocalizations.of(context)!.street,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                gapH8,
                TextFormField(
                  controller: streetNoController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.streetAddress,
                  validator: Validator.validateRequired,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.street,
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(kBorderRadius - 4),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(kBorderRadius - 4),
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                gapH16,

                Text(
                  AppLocalizations.of(context)!.flat,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                gapH8,
                TextFormField(
                  controller: flatNoController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: Validator.validateRequired,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.flat,
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(kBorderRadius - 4),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(kBorderRadius - 4),
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                gapH16,
                CustomPaint(
                  painter: DashedLinePainter(
                    lineColor: AppColor.greyDarkColor,
                  ),
                  size: const Size(double.infinity, 4),
                ),
                gapH8,
                ValueListenableBuilder(
                  valueListenable: isHomeAddress,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return Row(
                      children: [
                        AddressTypeChip(
                          isSelected: value,
                          title: 'Home',
                          icon: kIsWeb ? Icons.home : Iconsax.home,
                          onTap: () {
                            isHomeAddress.value = true;
                          },
                        ),
                        const SizedBox(width: 10.0),
                        AddressTypeChip(
                          isSelected: !value,
                          title: 'Work',
                          icon: kIsWeb ? Icons.work : PhosphorIcons.buildings,
                          onTap: () {
                            isHomeAddress.value = false;
                          },
                        ),
                      ],
                    );
                  },
                ),
                gapH16,
                CustomPaint(
                  painter: DashedLinePainter(
                    lineColor: AppColor.accentColor,
                  ),
                  size: const Size(double.infinity, 4),
                ),
                gapH8,
                ValueListenableBuilder(
                  valueListenable: markAsDefault,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return Card(
                      elevation: 0.0,
                      color: AppColor.accentColor.withOpacity(0.3),
                      child: SwitchListTile.adaptive(
                        value: value,
                        visualDensity: VisualDensity.compact,
                        activeTrackColor: AppColor.primaryColor,
                        activeColor: AppColor.primaryColor,
                        title: Text(
                          'Mark as Default Address',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        onChanged: (bool? value) {
                          markAsDefault.value = value!;
                        },
                      ),
                    );
                  },
                ),
                gapH16,
                BlocConsumer<AddressCubit, AddressState>(
                  listenWhen: (_, newState) {
                    return newState is AddressAddFailedState ||
                        newState is AddressAddSuccessState;
                  },
                  listener: (context, state) {
                    if (state is AddressAddFailedState) {
                      showSnackBar(
                        context: context,
                        title: 'Couldn\'t add address',
                        message: state.message,
                        snackbarType: SnackbarType.error,
                      );
                    }
                    if (state is AddressAddSuccessState) {
                      context.pop();
                      showSnackBar(
                        context: context,
                        title: 'Success',
                        message: 'Address has been added.',
                        snackbarType: SnackbarType.success,
                      );
                    }
                  },
                  buildWhen: (_, newState) {
                    return newState is AddressAddFailedState ||
                        newState is AddressAddSuccessState ||
                        newState is AddressAddLoadingState;
                  },
                  builder: (context, state) {
                    return AppButton(
                      isLoading: state is AddressAddLoadingState,
                      buttonText: 'Add Address',
                      onPressed: () async {
                        if (formKey.currentState?.validate() ?? false) {
                          String lat =
                              inject.get<LocationLocalRepository>().latitude;
                          String long =
                              inject.get<LocationLocalRepository>().longitude;
                          lat = latitude.isNotEmpty ? latitude : lat;
                          long = longitude.isNotEmpty ? longitude : long;
                          final model = AddressModel(
                            firstName: firstNameController.text.trim(),
                            lastName: lastNameController.text.trim(),
                            mobile: mobileController.text,
                            emailId: emailController.text.trim(),
                            address: addressController.text.trim(),
                            zipcode: zipController.text.trim(),
                            city: cityController.text.trim(),
                            state: stateController.text.trim(),
                            country: countryController.text.trim(),
                            streetNo: streetNoController.text.trim(),
                            flatNo: flatNoController.text.trim(),
                            addLatitude: lat,
                            addLongitude: long,
                            addressType:
                                isHomeAddress.value ? 'home' : 'office',
                            isDefault: markAsDefault.value,
                          );

                          await context
                              .read<AddressCubit>()
                              .addAddress(model: model);
                        }
                      },
                    );
                  },
                ),
                gapH12,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
