import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/inventory_model.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/sku_gallery.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/screens/cubit/inventory_cubit.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/utils/validations.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:orderly_ecom/src/widgets/app_button.dart';
import 'package:orderly_ecom/src/widgets/app_dialog.dart';
import 'package:orderly_ecom/src/widgets/image_picker_sheet.dart';
import 'package:orderly_ecom/src/widgets/shimmer.dart';

class InventoryAddForm extends StatefulWidget {
  const InventoryAddForm({super.key, this.galleryList, required this.fromBack});

  final SkuGalleryItem? galleryList;
  final bool fromBack;

  @override
  _InventoryAddFormState createState() => _InventoryAddFormState();
}

class _InventoryAddFormState extends State<InventoryAddForm> {
  late final GlobalKey<FormState> formKey;
  final ValueNotifier<XFile?> pickedImage = ValueNotifier(null);
  final ValueNotifier<String> policyNotifier = ValueNotifier<String>('');

  final ValueNotifier<String> estimateNotifier = ValueNotifier<String>('');

  late final TextEditingController titleNameController;
  late final TextEditingController descController;
  late final TextEditingController rateController;
  late final TextEditingController quantityController;
  late final TextEditingController estimatesController;

  List<String> selectedFiltersList = [];

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    titleNameController = TextEditingController();
    descController = TextEditingController();
    rateController = TextEditingController();
    quantityController = TextEditingController();
    estimatesController = TextEditingController();

    if (widget.fromBack) {
      titleNameController.text = widget.galleryList!.title ?? '';
      descController.text = widget.galleryList!.description ?? '';
    }
    context.read<InventoryCubit>().getFilters();
    context.read<InventoryCubit>().getProductReason();
    context.read<InventoryCubit>().getPickupEstimates();
  }

  @override
  void dispose() {
    titleNameController.dispose();
    descController.dispose();
    rateController.dispose();
    quantityController.dispose();
    estimatesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderlyAppBar(
        title: 'Add Inventory',
        action: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Add Estimates'),
                      gapH12,
                      const Divider(
                        color: AppColor.primaryColor,
                        thickness: 2,
                        endIndent: 20,
                        indent: 20,
                      ),
                      gapH20,
                      TextFormField(
                        controller: estimatesController,
                        decoration:
                            const InputDecoration(hintText: 'Add some text'),
                      ),
                      gapH20,
                      BlocConsumer<InventoryCubit, InventoryState>(
                        listener: (_, newState) {
                          if (newState is InventoryCreateEstimatesFailedState) {
                            showSnackBar(
                              context: context,
                              title: 'Oops',
                              message: 'Something went wrong',
                              snackbarType: SnackbarType.error,
                            );
                          }
                          if (newState is InventoryCreateEstimatesLoadedState) {
                            context.pop();
                            showSnackBar(
                              context: context,
                              title: 'Success!!',
                              message: 'Estimate Added Successfully',
                              snackbarType: SnackbarType.success,
                            );
                          }
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () {
                              context.read<InventoryCubit>().createEstimates(
                                    title: estimatesController.text,
                                  );
                            },
                            child: Text(
                              'Submit',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            icon: const Icon(Iconsax.add),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context)
                                .primaryColor, // red as border color
                          ),
                          color: Colors.white,
                        ),
                        child: BlocListener<InventoryCubit, InventoryState>(
                          listenWhen: (_, newState) {
                            return newState is InventoryImagePickFailedState ||
                                newState is InventoryImagePickLoadedState;
                          },
                          listener: (context, state) {
                            if (state is InventoryImagePickFailedState) {
                              showSnackBar(
                                context: context,
                                title: 'Oops',
                                message: state.message,
                                snackbarType: SnackbarType.error,
                              );
                            }
                            if (state is InventoryImagePickLoadedState) {
                              context.pop();
                              pickedImage.value = state.pickedImage;
                            }
                          },
                          child: ValueListenableBuilder(
                            valueListenable: pickedImage,
                            builder: (BuildContext c, XFile? value, Widget? _) {
                              if (value != null) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image(
                                    image: FileImage(
                                      File(value.path),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              } else {
                                if (widget.fromBack) {
                                  return CachedNetworkImage(
                                    imageUrl:
                                        widget.galleryList!.imageUrl ?? '',
                                    height: 100,
                                    fit: BoxFit.contain,
                                  );
                                }
                              }
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: IconButton(
                                  onPressed: () {
                                    AppDialog.showBottomSheet(
                                      context: context,
                                      child: ImagePickerSheet(
                                        onCameraClick: () async {
                                          await context
                                              .read<InventoryCubit>()
                                              .pickImage(
                                                imageSource: ImageSource.camera,
                                              );
                                        },
                                        onGalleryClick: () async {
                                          await context
                                              .read<InventoryCubit>()
                                              .pickImage(
                                                imageSource:
                                                    ImageSource.gallery,
                                              );
                                        },
                                        showSku: true,
                                        onSkuGalleryClick: () {
                                          context.goNamed(
                                              AppRoute.skuinventory.toName);
                                        },
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    kIsWeb ? Icons.photo : Iconsax.gallery_add,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -15,
                        right: -10,
                        child: CircleAvatar(
                          backgroundColor: AppColor.primaryColor,
                          radius: 18.0,
                          child: IconButton(
                            icon: const Icon(
                              kIsWeb ? Icons.camera_alt : Iconsax.camera,
                              color: AppColor.whiteColor,
                              size: 18.0,
                            ),
                            onPressed: () {
                              AppDialog.showBottomSheet(
                                context: context,
                                child: ImagePickerSheet(
                                  onCameraClick: () async {
                                    await context
                                        .read<InventoryCubit>()
                                        .pickImage(
                                          imageSource: ImageSource.camera,
                                        );
                                  },
                                  onGalleryClick: () async {
                                    await context
                                        .read<InventoryCubit>()
                                        .pickImage(
                                          imageSource: ImageSource.gallery,
                                        );
                                  },
                                  showSku: true,
                                  onSkuGalleryClick: () {
                                    context
                                        .goNamed(AppRoute.skuinventory.toName);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                gapH20,
                Text(
                  'Name',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColor.blackColor60,
                      ),
                ),
                gapH8,
                TextFormField(
                  controller: titleNameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  validator: Validator.validateName,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.input_title,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
                gapH20,
                Text(
                  'Product Description',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColor.blackColor60,
                      ),
                ),
                gapH8,
                TextFormField(
                  controller: descController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validator.validateRequired,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.input_desc,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
                gapH20,
                Text(
                  'Product Rate',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColor.blackColor60,
                      ),
                ),
                gapH8,
                TextFormField(
                  controller: rateController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  validator: Validator.validateRequired,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.input_rate,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
                gapH20,
                Text(
                  'Product Quantity',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColor.blackColor60,
                      ),
                ),
                gapH8,
                TextFormField(
                  controller: quantityController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  validator: Validator.validateRequired,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(9),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.input_items,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
                BlocBuilder<InventoryCubit, InventoryState>(
                  buildWhen: (_, newState) {
                    return newState is InventoryFilterFailedState ||
                        newState is InventoryFilterLoadedState ||
                        newState is InventoryAddLoadingState;
                  },
                  builder: (context, state) {
                    if (state is InventoryFilterLoadingState) {
                      return AppShimmer(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                      );
                    }
                    if (state is InventoryFilterFailedState) {
                      return const SizedBox.shrink();
                    }
                    if (state is InventoryFilterLoadedState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          gapH20,
                          Text(
                            'Product Filters',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: AppColor.blackColor60,
                                ),
                          ),
                          gapH8,
                          Wrap(
                            children: List.generate(
                              state.filtersList.length,
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.only(right: kBorderRadius),
                                child: ChoiceChip(
                                  label: Text(
                                    state.filtersList[index].name!,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(),
                                  ),
                                  selectedColor: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.8),
                                  selected: selectedFiltersList
                                      .contains(state.filtersList[index].id!),
                                  onSelected: (value) {
                                    HapticFeedback.lightImpact();
                                    if (!selectedFiltersList.contains(
                                        state.filtersList[index].id!)) {
                                      selectedFiltersList
                                          .add(state.filtersList[index].id!);
                                    } else {
                                      selectedFiltersList
                                          .remove(state.filtersList[index].id!);
                                    }
                                    context
                                        .read<InventoryCubit>()
                                        .emitSelectedFilter(state.filtersList);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                gapH20,
                BlocBuilder<InventoryCubit, InventoryState>(
                  buildWhen: (_, newState) {
                    return newState is InventoryReturnPolicyLoadingState ||
                        newState is InventoryReturnPolicyLoadedState ||
                        newState is InventoryReturnPolicyFailedState;
                  },
                  builder: (context, state) {
                    if (state is InventoryReturnPolicyLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is InventoryReturnPolicyLoadedState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Policy',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: AppColor.blackColor60,
                                ),
                          ),
                          gapH8,
                          DropdownButtonHideUnderline(
                            child: Container(
                              padding: const EdgeInsets.only(right: 10.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: AppColor.scaleGreyColor,
                                ), //custom color
                                child: ValueListenableBuilder(
                                  valueListenable: policyNotifier,
                                  builder: (BuildContext context, String value,
                                      Widget? child) {
                                    return ButtonTheme(
                                      buttonColor: Colors.white,
                                      alignedDropdown: true,
                                      child: DropdownButtonFormField(
                                        isExpanded: true,
                                        itemHeight: 50,
                                        menuMaxHeight: 300.0,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        // validator: (value) {
                                        //   if (value == null) {
                                        //     return 'Please select one policy';
                                        //   }
                                        //   if (value.isEmpty) {
                                        //     return 'Please select one policy';
                                        //   }
                                        //   return null;
                                        // },
                                        icon: const Icon(
                                          kIsWeb
                                              ? Icons.arrow_circle_down
                                              : Iconsax.arrow_circle_down,
                                          size: 20.0,
                                          color: AppColor.blackColor,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                          fillColor: Colors.grey.shade200,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          hintText: '   Please Select Policy'
                                              .hardcoded,
                                        ),
                                        value: value.isEmpty ? null : value,
                                        onChanged: (data) {
                                          policyNotifier.value = data!;
                                          log(policyNotifier.value,
                                              name:
                                                  'CHANGED VALUE>>>>>>>>>>>>');
                                        },
                                        items: state.productReasonList.data
                                            .map<DropdownMenuItem>(
                                          (value) {
                                            return DropdownMenuItem(
                                              value: value.id,
                                              child: Text(
                                                value.title,
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
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                gapH20,
                BlocBuilder<InventoryCubit, InventoryState>(
                  buildWhen: (_, newState) {
                    return newState is InventoryPickupLoadingState ||
                        newState is InventoryPickupLoadedState ||
                        newState is InventoryPickupFailedState;
                  },
                  builder: (context, state) {
                    if (state is InventoryPickupLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is InventoryPickupLoadedState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Estimates',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: AppColor.blackColor60,
                                ),
                          ),
                          gapH8,
                          DropdownButtonHideUnderline(
                            child: Container(
                              padding: const EdgeInsets.only(right: 10.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: AppColor.scaleGreyColor,
                                ), //custom color
                                child: ValueListenableBuilder(
                                  valueListenable: estimateNotifier,
                                  builder: (BuildContext context, String value,
                                      Widget? child) {
                                    return ButtonTheme(
                                      buttonColor: Colors.white,
                                      alignedDropdown: true,
                                      child: DropdownButtonFormField(
                                        isExpanded: true,
                                        itemHeight: 50,
                                        menuMaxHeight: 300.0,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        // validator: (value) {
                                        //   if (value == null) {
                                        //     return 'Please select one estimate';
                                        //   }
                                        //   if (value.isEmpty) {
                                        //     return 'Please select one estimate';
                                        //   }
                                        //   return null;
                                        // },
                                        icon: const Icon(
                                          kIsWeb
                                              ? Icons.arrow_circle_down
                                              : Iconsax.arrow_circle_down,
                                          size: 20.0,
                                          color: AppColor.blackColor,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                          fillColor: Colors.grey.shade200,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          hintText: '   Please Select Estimate'
                                              .hardcoded,
                                        ),
                                        value: value.isEmpty ? null : value,
                                        onChanged: (data) {
                                          estimateNotifier.value = data;
                                          log(estimateNotifier.value,
                                              name:
                                                  'CHANGED VALUE>>>>>>>>>>>>');
                                        },
                                        items: state.productEstimatesList.data
                                            .map<DropdownMenuItem>(
                                          (value) {
                                            return DropdownMenuItem(
                                              value: value.id,
                                              child: Text(
                                                value.title,
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
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                gapH20,
                BlocConsumer<InventoryCubit, InventoryState>(
                  listenWhen: (_, newState) {
                    return newState is InventoryAddFailedState ||
                        newState is InventoryAddSuccessState;
                  },
                  listener: (context, state) {
                    if (state is InventoryAddFailedState) {
                      showSnackBar(
                        context: context,
                        title: 'Oops',
                        message: state.message,
                        snackbarType: SnackbarType.error,
                      );
                    }
                    if (state is InventoryAddSuccessState) {
                      context.pop();
                      showSnackBar(
                        context: context,
                        title: 'Success',
                        message: 'New product has been added',
                        snackbarType: SnackbarType.success,
                      );
                    }
                  },
                  buildWhen: (_, newState) {
                    return newState is InventoryAddFailedState ||
                        newState is InventoryAddLoadingState ||
                        newState is InventoryAddSuccessState;
                  },
                  builder: (context, state) {
                    return AppButton(
                      isLoading: state is InventoryAddLoadingState,
                      buttonText: 'Add Product',
                      onPressed: () async {
                        if (formKey.currentState?.validate() ?? false) {
                          if (pickedImage.value == null && !widget.fromBack) {
                            showSnackBar(
                              context: context,
                              title: 'Upload Image',
                              message: 'Choose product image',
                              snackbarType: SnackbarType.error,
                            );
                          }
                          if (!widget.fromBack) {
                            final addInventory = InventoryModel(
                              productId: '',
                              productName: titleNameController.text.trim(),
                              productDesc: descController.text.trim(),
                              rate: rateController.text,
                              productQty: quantityController.text,
                              image: pickedImage.value,
                              estimatedPickup: estimateNotifier.value,
                              returnPolicy: policyNotifier.value,
                              filters: selectedFiltersList,
                            );
                            await context.read<InventoryCubit>().addInventory(
                                  inventoryModel: addInventory,
                                );
                          } else {
                            final addInventory = InventoryModel(
                              productId: '',
                              productName: titleNameController.text.trim(),
                              productDesc: descController.text.trim(),
                              rate: rateController.text,
                              productQty: quantityController.text,
                              imageId: widget.galleryList!.id,
                              estimatedPickup: estimateNotifier.value,
                              returnPolicy: policyNotifier.value,
                              filters: selectedFiltersList,
                            );
                            await context.read<InventoryCubit>().addInventory(
                                  inventoryModel: addInventory,
                                );
                          }
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
