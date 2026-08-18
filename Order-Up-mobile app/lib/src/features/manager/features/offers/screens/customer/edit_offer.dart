// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/domain/new_customer_product.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/domain/offers_by_id.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/screens/cubit/offer_cubit.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/screens/cubit/offer_state.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/utils/validations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';

class EditOffers extends StatefulWidget {
  const EditOffers({
    super.key,
    required this.id,
  });

  final String id;

  @override
  _EditOffersState createState() => _EditOffersState();
}

class _EditOffersState extends State<EditOffers> {
  final ValueNotifier<bool> checkStatus = ValueNotifier(true);
  late TextEditingController offerController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ValueNotifier<DateTime> startDateTime =
      ValueNotifier<DateTime>(DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour,
    DateTime.now().minute,
  ));

  final ValueNotifier<DateTime> endDateTime = ValueNotifier<DateTime>(DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour,
    DateTime.now().minute,
  ));

  //variables for checking if its edited or not
  bool isEditStartDate = true;
  bool isEditStartTime = true;

  bool isEditEndDate = true;
  bool isEditEndTime = true;

  List<CustomerDetail> customer = [];

  /// List For ExistingCustomerId From Api
  List<Customers> existingCustomer = [];
  List<String> existingCustomerId = [];

  /// List For ExistingPrpductId From Api
  List<Products> existingProducts = [];
  List<String> existingProductsId = [];

  /// Final StartDateTime Variables For Passing in Api
  String startDateData = '';
  String startTimeData = '';

  /// Final EndDateTime Variables For Passing in Api
  String endDateData = '';
  String endTimeData = '';

  late TextEditingController editTitleController;

  @override
  void initState() {
    super.initState();
    editTitleController = TextEditingController();
    offerController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (context.mounted) {
        await context.read<OfferCubit>().getOffersById(id: widget.id);
      }
    });
  }

  @override
  void dispose() {
    editTitleController.dispose();
    offerController.dispose();
    super.dispose();
  }

  List<String> newSelectedProductId = [];

  List<String> newSelectedCustomerId = [];

  String offerId = '';

  final ValueNotifier<bool> selectAllCustomerCheck = ValueNotifier(false);
  final ValueNotifier<bool> selectAllProductCheck = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final startHours = startDateTime.value.hour.toString().padLeft(2, '0');
    final startMinutes = startDateTime.value.minute.toString().padLeft(2, '0');
    final endHours = endDateTime.value.hour.toString().padLeft(2, '0');
    final endMinutes = endDateTime.value.minute.toString().padLeft(2, '0');

    String existingStartTime = '';
    String existingEndTime = '';

    String newStartDate =
        '${startDateTime.value.year}-${startDateTime.value.month}-${startDateTime.value.day}';
    String newStartTime = '$startHours:$startMinutes';

    String newEndDate =
        '${endDateTime.value.year}-${endDateTime.value.month}-${endDateTime.value.day}';
    String newEndTime = '$endHours:$endMinutes';
    return WillPopScope(
      onWillPop: () async {
        context.read<OfferCubit>().getAllOffers();
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              context.read<OfferCubit>().getAllOffers();
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: InkWell(
            onTap: () {
              debugPrint(existingProductsId.toString());
              debugPrint(existingCustomerId.toString());
              debugPrint('$startDateData $startTimeData');
              debugPrint('$endDateData $endTimeData');
            },
            child: Text(
              'Edit Offer',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColor.whiteColor,
                    fontSize: 18,
                  ),
            ),
          ),
        ),
        body: BlocBuilder<OfferCubit, OfferState>(
          buildWhen: (_, newState) {
            return newState is OfferByIdLoadingState ||
                newState is OfferByIdLoadedState;
          },
          builder: (context, state) {
            if (state is OfferByIdLoadingState) {
              return ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
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

            if (state is OfferByIdLoadedState) {
              List<CustomerDetail> selectedCustomer = [];
              List<ProductDetail> selectedProducts = [];

              /// This is to store startDateTime data from api
              String apiStartDateAndTime =
                  state.offerByIdList.data.startDate.toString();

              /// Made new variable for storing only startDate from the api
              String apiStartDate = apiStartDateAndTime.substring(
                  0, state.offerByIdList.data.startDate.toString().length - 14);

              /// This is to store endDateTime data from api
              String apiEndDateAndTime =
                  state.offerByIdList.data.endDate.toString();

              /// Made new variable for storing only endDate from the api
              String apiEndDate = apiEndDateAndTime.substring(
                  0, state.offerByIdList.data.endDate.toString().length - 14);

              offerId = state.offerByIdList.data.id;

              editTitleController.text = state.offerByIdList.data.title;

              selectAllCustomerCheck.value =
                  state.offerByIdList.data.allCustomers;

              selectAllProductCheck.value =
                  state.offerByIdList.data.allProducts;

              if (isEditStartDate) {
                apiStartDate;
              }

              if (isEditStartTime) {
                existingStartTime = state.offerByIdList.data.startDate
                    .toString()
                    .substring(
                        11,
                        state.offerByIdList.data.startDate.toString().length -
                            8);
              }

              if (isEditEndDate) {
                apiEndDate;
              }

              if (isEditEndTime) {
                existingEndTime = state.offerByIdList.data.endDate
                    .toString()
                    .substring(
                        11,
                        state.offerByIdList.data.startDate.toString().length -
                            8);
              }

              offerController.text =
                  state.offerByIdList.data.offerPercentage.toString();

              for (int i = 0;
                  i < state.offerByIdList.data.customers.length;
                  i++) {
                if (state.offerByIdList.data.customers[i].isSelected == true) {
                  existingCustomer.add(state.offerByIdList.data.customers[i]);
                }
              }

              for (int i = 0;
                  i < state.offerByIdList.data.customers.length;
                  i++) {
                if (state.offerByIdList.data.customers[i].isSelected == true) {
                  existingCustomerId
                      .add(state.offerByIdList.data.customers[i].id);
                }
              }

              for (int i = 0;
                  i < state.offerByIdList.data.products.length;
                  i++) {
                if (state.offerByIdList.data.products[i].isSelected == true) {
                  existingProducts.add(state.offerByIdList.data.products[i]);
                }
              }

              for (int i = 0;
                  i < state.offerByIdList.data.products.length;
                  i++) {
                if (state.offerByIdList.data.products[i].isSelected == true) {
                  existingProductsId
                      .add(state.offerByIdList.data.products[i].id);
                }
              }

              startDateData = isEditStartDate ? apiStartDate : newStartDate;
              startTimeData =
                  isEditStartTime ? existingStartTime : newStartTime;

              endDateData = isEditEndDate ? apiEndDate : newEndDate;
              endTimeData = isEditEndTime ? existingEndTime : newEndTime;

              if (state.offerByIdList.data.customers.isEmpty &&
                  state.offerByIdList.data.products.isEmpty) {
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.no_data,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: AppColor.textColor,
                    ),
                  ),
                );
              }
              return SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 2),
                                blurRadius: 1.0,
                                spreadRadius: 1.0,
                                color: AppColor.kShadowColor,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Edit Offer Title :',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: editTitleController,
                                  validator: Validator.validateRequired,
                                  textInputAction: TextInputAction.done,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ValueListenableBuilder(
                            valueListenable: selectAllCustomerCheck,
                            builder: (context, bool value, Widget? _) {
                              return Column(
                                children: [
                                  CheckboxListTile(
                                    value: selectAllCustomerCheck.value,
                                    onChanged: (val) {
                                      selectAllCustomerCheck.value = val!;
                                      selectedCustomer.clear();
                                      newSelectedCustomerId.clear();
                                    },
                                    title: Text(
                                      'Select All Customers',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontSize: 16,
                                          ),
                                    ),
                                  ),
                                  selectAllCustomerCheck.value == true
                                      ? const Center()
                                      : Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 20),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                offset: Offset(0, 2),
                                                blurRadius: 1.0,
                                                spreadRadius: 1.0,
                                                color: AppColor.kShadowColor,
                                              ),
                                            ],
                                          ),
                                          child: MultiSelectDialogField(
                                            initialValue: existingCustomer,
                                            items: state
                                                .offerByIdList.data.customers
                                                .map((e) => MultiSelectItem<
                                                        Customers>(e,
                                                    '${e.firstName} ${e.lastName}'))
                                                .toList(),
                                            title:
                                                const Text('Select Customers'),
                                            selectedColor: AppColor.bgColor,
                                            selectedItemsTextStyle:
                                                const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            buttonIcon: const Icon(
                                              Icons.keyboard_arrow_down_sharp,
                                              size: 30,
                                            ),
                                            buttonText: Text(
                                              'Select Customers',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                            ),
                                            listType: MultiSelectListType.LIST,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.black54,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  offset: Offset(0, -17),
                                                  blurRadius: 12.0,
                                                  spreadRadius: -17.0,
                                                  color: AppColor.kShadowColor,
                                                ),
                                              ],
                                            ),
                                            onConfirm: (val) {
                                              // selectedCustomer = val;
                                              List<String> selectedCustomerId =
                                                  [];
                                              for (int i = 0;
                                                  i < val.length;
                                                  i++) {
                                                selectedCustomerId
                                                    .add(val[i].id);
                                              }
                                              newSelectedCustomerId =
                                                  selectedCustomerId;
                                            },
                                            searchable: true,
                                          ),
                                        ),
                                ],
                              );
                            }),
                        const SizedBox(height: 20),
                        ValueListenableBuilder(
                            valueListenable: selectAllProductCheck,
                            builder: (context, bool value, Widget? _) {
                              return Column(
                                children: [
                                  CheckboxListTile(
                                    value: selectAllProductCheck.value,
                                    onChanged: (val) {
                                      selectAllProductCheck.value = val!;
                                      selectedProducts.clear();
                                      newSelectedProductId.clear();
                                    },
                                    title: Text(
                                      'Select All Products',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontSize: 16,
                                          ),
                                    ),
                                  ),
                                  selectAllProductCheck.value == true
                                      ? const Center()
                                      : Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 20),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                offset: Offset(0, 2),
                                                blurRadius: 1.0,
                                                spreadRadius: 1.0,
                                                color: AppColor.kShadowColor,
                                              ),
                                            ],
                                          ),
                                          child: MultiSelectDialogField(
                                            initialValue: existingProducts,
                                            items: state
                                                .offerByIdList.data.products
                                                .map((e) =>
                                                    MultiSelectItem<Products>(
                                                        e, e.name))
                                                .toList(),
                                            title:
                                                const Text('Select Products'),
                                            selectedColor: AppColor.bgColor,
                                            buttonIcon: const Icon(
                                              Icons.keyboard_arrow_down_sharp,
                                              size: 30,
                                            ),
                                            selectedItemsTextStyle:
                                                const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            buttonText: Text(
                                              'Select Products',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                            ),
                                            listType: MultiSelectListType.LIST,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.black54,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  offset: Offset(0, -17),
                                                  blurRadius: 12.0,
                                                  spreadRadius: -17.0,
                                                  color: AppColor.kShadowColor,
                                                ),
                                              ],
                                            ),
                                            onConfirm: (val) {
                                              // selectedProducts = val;
                                              List<String> selectedProductId =
                                                  [];
                                              for (int i = 0;
                                                  i < val.length;
                                                  i++) {
                                                selectedProductId
                                                    .add(val[i].id);
                                              }
                                              newSelectedProductId =
                                                  selectedProductId;
                                            },
                                            searchable: true,
                                          ),
                                        ),
                                ],
                              );
                            }),
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 2),
                                blurRadius: 1.0,
                                spreadRadius: 1.0,
                                color: AppColor.kShadowColor,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Offer\nPercentage :',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: offerController,
                                  validator: Validator.validateRequired,
                                  textInputAction: TextInputAction.done,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(2),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 2),
                                blurRadius: 1.0,
                                spreadRadius: 1.0,
                                color: AppColor.kShadowColor,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Start Date',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontSize: 18,
                                        ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: ValueListenableBuilder(
                                      valueListenable: startDateTime,
                                      builder: (context, child, value) {
                                        return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColor.accentColor,
                                          ),
                                          onPressed: () async {
                                            final date = await startPickData();
                                            if (date == null) return;
                                            final newDateTime = DateTime(
                                              date.year,
                                              date.month,
                                              date.day,
                                              startDateTime.value.hour,
                                              startDateTime.value.minute,
                                            );
                                            setState(() {
                                              startDateTime.value = newDateTime;
                                              isEditStartDate = false;
                                            });
                                          },
                                          child: Text(
                                            isEditStartDate
                                                ? apiStartDate
                                                : newStartDate,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 100,
                                color: Colors.black45,
                                width: 1,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Start Time',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontSize: 18,
                                        ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: ValueListenableBuilder(
                                      valueListenable: startDateTime,
                                      builder: (context, child, value) {
                                        return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColor.accentColor,
                                          ),
                                          onPressed: () async {
                                            final time = await startPickTime();
                                            if (time == null) return;
                                            final newDateTime = DateTime(
                                              startDateTime.value.year,
                                              startDateTime.value.month,
                                              startDateTime.value.day,
                                              time.hour,
                                              time.minute,
                                            );
                                            setState(() {
                                              startDateTime.value = newDateTime;
                                              isEditStartTime = false;
                                            });
                                          },
                                          child: Text(
                                            isEditStartTime
                                                ? existingStartTime
                                                : newStartTime,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 2),
                                blurRadius: 1.0,
                                spreadRadius: 1.0,
                                color: AppColor.kShadowColor,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'End Date',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontSize: 18,
                                        ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: ValueListenableBuilder(
                                        valueListenable: endDateTime,
                                        builder: (context, child, value) {
                                          return ElevatedButton(
                                            onPressed: () async {
                                              final date = await endPickData();
                                              if (date == null) return;
                                              final newDateTime = DateTime(
                                                date.year,
                                                date.month,
                                                date.day,
                                                endDateTime.value.hour,
                                                endDateTime.value.minute,
                                              );
                                              setState(() {
                                                endDateTime.value = newDateTime;
                                                isEditEndDate = false;
                                              });
                                            },
                                            child: Text(
                                              isEditEndDate
                                                  ? apiEndDate
                                                  : newEndDate,
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                              Container(
                                height: 100,
                                color: Colors.black45,
                                width: 1,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'End Time',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontSize: 18,
                                        ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final time = await endPickTime();
                                        if (time == null) return;
                                        final newDateTime = DateTime(
                                          endDateTime.value.year,
                                          endDateTime.value.month,
                                          endDateTime.value.day,
                                          time.hour,
                                          time.minute,
                                        );
                                        setState(() {
                                          endDateTime.value = newDateTime;
                                          isEditEndTime = false;
                                        });
                                      },
                                      child: Text(
                                        isEditEndTime
                                            ? existingEndTime
                                            : newEndTime,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Status :',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: checkStatus,
                              builder: (context, child, value) {
                                return Checkbox(
                                  activeColor: AppColor.primaryColor,
                                  value: checkStatus.value,
                                  onChanged: (val) {
                                    checkStatus.value = val!;
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        BlocListener<OfferCubit, OfferState>(
                          listenWhen: (_, newState) {
                            return newState is OfferUpdateLoadingState ||
                                newState is OfferUpdateSuccessState ||
                                newState is OfferUpdateFailedState;
                          },
                          listener: (context, state) {
                            if (state is OfferUpdateSuccessState) {
                              Navigator.pop(context);
                              showSnackBar(
                                context: context,
                                title: 'Success!!',
                                message: 'Offer Updated Successfully',
                                snackbarType: SnackbarType.success,
                              );
                            }
                          },
                          child: SizedBox(
                            height: 55,
                            width: MediaQuery.of(context).size.width / 1,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primaryColor,
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<OfferCubit>().updateOffers(
                                        title: editTitleController.text,
                                        id: offerId,
                                        offerPercentage:
                                            int.parse(offerController.text),
                                        startDate:
                                            '$startDateData $startTimeData',
                                        endDate: '$endDateData $endTimeData',
                                        status:
                                            checkStatus.value == true ? 1 : 0,
                                        products: selectAllProductCheck.value
                                            ? []
                                            : newSelectedProductId.isEmpty
                                                ? existingProductsId
                                                : newSelectedProductId,
                                        customers: selectAllCustomerCheck.value
                                            ? []
                                            : newSelectedCustomerId.isEmpty
                                                ? existingCustomerId
                                                : newSelectedCustomerId,
                                      );
                                }
                              },
                              child: Text(
                                'Submit',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<DateTime?> startPickData() => showDatePicker(
        context: context,
        initialDate: startDateTime.value,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

  Future<TimeOfDay?> startPickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: startDateTime.value.hour, minute: startDateTime.value.minute),
      );

  Future<DateTime?> endPickData() => showDatePicker(
        context: context,
        initialDate: endDateTime.value,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

  Future<TimeOfDay?> endPickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: endDateTime.value.hour, minute: endDateTime.value.minute),
      );
}
