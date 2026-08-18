import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/inventory.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/inventory_model.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/screens/cubit/inventory_cubit.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/utils/validations.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:orderly_ecom/src/widgets/app_button.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/widgets/app_dialog.dart';
import 'package:orderly_ecom/src/widgets/image_builder.dart';
import 'package:orderly_ecom/src/widgets/image_picker_sheet.dart';
import 'package:orderly_ecom/src/widgets/shimmer.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';

class InventoryEditForm extends StatefulWidget {
  const InventoryEditForm({
    super.key,
    required this.inventory,
  });
  final InventoryItem inventory;
  @override
  _InventoryEditFormState createState() => _InventoryEditFormState();
}

class _InventoryEditFormState extends State<InventoryEditForm> {
  late final GlobalKey<FormState> formKey;
  final ValueNotifier<XFile?> pickedImage = ValueNotifier(null);
  final ValueNotifier<String> generatedImageUrl = ValueNotifier('');
  final ValueNotifier<bool> generatingImage = ValueNotifier(false);

  final ValueNotifier<String> policyNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> estimateNotifier = ValueNotifier<String>('');

  late final TextEditingController titleNameController;
  late final TextEditingController descController;
  late final TextEditingController rateController;
  late final TextEditingController quantityController;

  List<String> selectedFiltersList = [];

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    titleNameController = TextEditingController(text: widget.inventory.name);
    descController = TextEditingController(text: widget.inventory.desc);
    rateController =
        TextEditingController(text: widget.inventory.price?.toString() ?? '');
    quantityController =
        TextEditingController(text: widget.inventory.qty?.toString() ?? '');

    context.read<InventoryCubit>().getFilters();
    context.read<InventoryCubit>().getProductReason();
    context.read<InventoryCubit>().getPickupEstimates();
    // log(widget.inventory.returnPolicy!.title.toString(),
    //     name: '>>>>>>>>>>>>>>>>>>>>>NAME');
    policyNotifier.value = widget.inventory.returnPolicy?.id.toString() ?? '';
    estimateNotifier.value =
        widget.inventory.estimatedPickup?.id.toString() ?? '';
    widget.inventory.filters?.forEach((element) {
      selectedFiltersList.add(element.id!);
    });
  }

  @override
  void dispose() {
    pickedImage.dispose();
    generatedImageUrl.dispose();
    generatingImage.dispose();
    policyNotifier.dispose();
    estimateNotifier.dispose();
    titleNameController.dispose();
    descController.dispose();
    rateController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderlyAppBar(
        title: 'Update Inventory',
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
                              if (generatedImageUrl.value.isNotEmpty) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    generatedImageUrl.value,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }
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
                              }
                              if (widget.inventory.imageUrl != null) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: ImageBuilder(
                                    imageUrl: widget.inventory.imageUrl!,
                                    height: 100.0,
                                    width: 100.0,
                                    fitType: BoxFit.cover,
                                  ),
                                );
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
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    kIsWeb
                                        ? Icons.add_photo_alternate_rounded
                                        : Iconsax.gallery_add,
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
                Center(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: generatingImage,
                    builder: (context, isGenerating, _) {
                      return OutlinedButton.icon(
                        onPressed: isGenerating
                            ? null
                            : () async {
                                final name = titleNameController.text.trim();
                                if (name.isEmpty) {
                                  showSnackBar(
                                    context: context,
                                    title: 'Product name required',
                                    message: 'Enter a product name before generating an image.',
                                    snackbarType: SnackbarType.error,
                                  );
                                  return;
                                }
                                generatingImage.value = true;
                                try {
                                  final response = await inject
                                      .get<NetworkAdapter>()
                                      .post(
                                    Endpoints.storeGenerateInventoryImage,
                                    data: {
                                      'product_id': widget.inventory.id,
                                      'name': name,
                                      'description': descController.text.trim(),
                                    },
                                  );
                                  if (mounted) {
                                    setState(() {
                                      generatedImageUrl.value =
                                          response.data['data']['image_url'];
                                      pickedImage.value = null;
                                    });
                                  }
                                } catch (error) {
                                  if (context.mounted) {
                                    showSnackBar(
                                      context: context,
                                      title: 'Generation failed',
                                      message: error.toString(),
                                      snackbarType: SnackbarType.error,
                                    );
                                  }
                                } finally {
                                  generatingImage.value = false;
                                }
                              },
                        icon: isGenerating
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.auto_awesome),
                        label: Text(isGenerating
                            ? 'Generating product image...'
                            : 'Generate with AI'),
                      );
                    },
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
                      // policyNotifier.value =
                      // widget.inventory.returnPolicy?.title ?? '';

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
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please select one policy';
                                          }
                                          if (value.isEmpty) {
                                            return 'Please select one policy';
                                          }
                                          return null;
                                        },
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
                                        // value: widget.inventory.returnPolicy!
                                        //             .title ==
                                        //         ''
                                        //     ? null
                                        //     : widget
                                        //         .inventory.returnPolicy!.title,
                                        onChanged: (data) {
                                          policyNotifier.value = data;
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
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please select one estimate';
                                          }
                                          if (value.isEmpty) {
                                            return 'Please select one estimate';
                                          }
                                          return null;
                                        },
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
                    return newState is InventoryUpdateFailedState ||
                        newState is InventoryUpdateSuccessState;
                  },
                  listener: (context, state) {
                    if (state is InventoryUpdateFailedState) {
                      showSnackBar(
                        context: context,
                        title: 'Oops',
                        message: state.message,
                        snackbarType: SnackbarType.error,
                      );
                    }
                    if (state is InventoryUpdateSuccessState) {
                      context.pop();
                      showSnackBar(
                        context: context,
                        title: 'Success',
                        message: '${widget.inventory.name} has been updated',
                        snackbarType: SnackbarType.success,
                      );
                    }
                  },
                  buildWhen: (_, newState) {
                    return newState is InventoryUpdateFailedState ||
                        newState is InventoryUpdateLoadingState ||
                        newState is InventoryUpdateSuccessState;
                  },
                  builder: (context, state) {
                    return AppButton(
                      isLoading: state is InventoryUpdateLoadingState,
                      buttonText: 'Edit Product',
                      onPressed: () async {
                        if (formKey.currentState?.validate() ?? false) {
                          final editInventory = InventoryModel(
                            productId: widget.inventory.id!,
                            productName: titleNameController.text.trim(),
                            productDesc: descController.text.trim(),
                            rate: rateController.text,
                            productQty: quantityController.text,
                            image: pickedImage.value,
                            estimatedPickup: estimateNotifier.value,
                            returnPolicy: policyNotifier.value,
                            filters: selectedFiltersList,
                          );
                          await context.read<InventoryCubit>().editInventory(
                                inventoryModel: editInventory,
                              );
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
