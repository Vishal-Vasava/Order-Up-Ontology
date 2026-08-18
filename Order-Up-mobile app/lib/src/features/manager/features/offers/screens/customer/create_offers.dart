// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/domain/new_customer_product.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/screens/cubit/offer_cubit.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/screens/cubit/offer_state.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/utils/validations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';

final ValueNotifier<bool> selectAllCustomerCheck = ValueNotifier(false);
final ValueNotifier<bool> selectAllProductCheck = ValueNotifier(false);

List<String> newSelectedProductId = [];
List<String> newSelectedCustomerId = [];

class CreateOffers extends StatefulWidget {
  const CreateOffers({super.key});

  @override
  _CreateOffersState createState() => _CreateOffersState();
}

class _CreateOffersState extends State<CreateOffers> {
  final ValueNotifier<DateTime> startDate = ValueNotifier<DateTime>(DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  ));

  final ValueNotifier<DateTime> startTime = ValueNotifier<DateTime>(DateTime(
    DateTime.now().hour,
    DateTime.now().minute,
  ));

  final ValueNotifier<DateTime> endDate = ValueNotifier<DateTime>(DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  ));

  late TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    context.read<OfferCubit>().getProductCustomer();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> selectAllCustomerCheck = ValueNotifier(false);
    final ValueNotifier<bool> selectAllProductCheck = ValueNotifier(false);
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
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Create Offer',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppColor.whiteColor,
                  fontSize: 18,
                ),
          ),
        ),
        body: BlocBuilder<OfferCubit, OfferState>(
          buildWhen: (_, newState) {
            return newState is OfferCustomerProductLoadingState ||
                newState is OfferCustomerProductLoadedState ||
                newState is OfferCustomerProductFailedState;
          },
          builder: (context, state) {
            if (state is OfferCustomerProductLoadingState) {
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
            if (state is OfferCustomerProductFailedState) {
              return Center(
                child: Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                ),
              );
            }
            if (state is OfferCustomerProductLoadedState) {
              List<CustomerDetail> selectedCustomer = [];
              List<ProductDetail> selectedProducts = [];
              if (state.productCustomerList.data.customerDetails.isEmpty) {
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
                              'Add Offer Title :',
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
                                controller: titleController,
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
                        builder:
                            (BuildContext context, bool value, Widget? child) {
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
                                      child: MultiSelectDialogField(
                                        initialValue: selectedCustomer,
                                        title: const Text('Select Customers'),
                                        selectedColor: AppColor.bgColor,
                                        selectedItemsTextStyle: const TextStyle(
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
                                        items: state.productCustomerList.data
                                            .customerDetails
                                            .map((e) => MultiSelectItem<
                                                    CustomerDetail>(e,
                                                '${e.firstName} ${e.lastName}'))
                                            .toList(),
                                        onConfirm: (val) {
                                          selectedCustomer = val;
                                          List<String> selectedCustomerId = [];
                                          for (int i = 0; i < val.length; i++) {
                                            selectedCustomerId.add(val[i].id!);
                                          }
                                          newSelectedCustomerId =
                                              selectedCustomerId;
                                        },
                                        searchable: true,
                                      ),
                                    ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      ValueListenableBuilder(
                          valueListenable: selectAllProductCheck,
                          builder: (BuildContext context, bool value,
                              Widget? child) {
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
                                          initialValue: selectedProducts,
                                          title: const Text('Select Products'),
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
                                          items: state.productCustomerList.data
                                              .productDetails
                                              .map((e) => MultiSelectItem<
                                                  ProductDetail>(e, e.name!))
                                              .toList(),
                                          onConfirm: (val) {
                                            selectedProducts = val;
                                            List<String> selectedProductId = [];
                                            for (int i = 0;
                                                i < val.length;
                                                i++) {
                                              selectedProductId.add(val[i].id!);
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
                      TimeDateWidget(
                        titleController: titleController,
                      ),
                      // ),
                    ],
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
}

class TimeDateWidget extends StatefulWidget {
  const TimeDateWidget({
    super.key,
    required this.titleController,
  });
  final TextEditingController titleController;

  @override
  State<TimeDateWidget> createState() => _TimeDateWidgetState();
}

class _TimeDateWidgetState extends State<TimeDateWidget> {
  late TextEditingController offerController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<DateTime> startDate = ValueNotifier<DateTime>(DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  ));

  final ValueNotifier<DateTime> startTime = ValueNotifier<DateTime>(DateTime(
    DateTime.now().hour,
    DateTime.now().minute,
  ));

  final ValueNotifier<DateTime> endDate = ValueNotifier<DateTime>(DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  ));

  @override
  void initState() {
    offerController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    offerController.dispose();
    super.dispose();
  }

  final ValueNotifier<bool> checkStatus = ValueNotifier(true);
  @override
  Widget build(BuildContext context) {
    final endHours = endDate.value.hour.toString().padLeft(2, '0');
    final endMinutes = endDate.value.minute.toString().padLeft(2, '0');
    String selectedStartDateTime =
        '${startDate.value.year}-${startDate.value.month}-${startDate.value.day} ${startTime.value.hour}:${startTime.value.minute}';
    String selectedEndDateTime =
        '${endDate.value.year}-${endDate.value.month}-${endDate.value.day} $endHours:$endMinutes';
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      if (value.length == 2) {
                        FocusManager.instance.primaryFocus!.unfocus();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 18,
                          ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: ValueListenableBuilder(
                          valueListenable: startDate,
                          builder: (context, child, value) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primaryColor,
                              ),
                              onPressed: () async {
                                final date = await startPickData();
                                if (date == null) return;
                                final newDateTime = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  startDate.value.hour,
                                  startDate.value.minute,
                                );
                                startDate.value = newDateTime;
                              },
                              child: Text(
                                '${startDate.value.year} - ${startDate.value.month} - ${startDate.value.day}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
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
                      'Start Time',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 18,
                          ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: ValueListenableBuilder(
                        valueListenable: startTime,
                        builder: (context, child, value) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primaryColor,
                            ),
                            onPressed: () async {
                              final time = await startPickTime();
                              if (time == null) return;
                              final newDateTime = DateTime(
                                startTime.value.year,
                                startTime.value.month,
                                startTime.value.day,
                                time.hour,
                                time.minute,
                              );
                              startTime.value = newDateTime;
                            },
                            child: Text(
                              '${startTime.value.hour.toString().padLeft(2, '0')}:${startTime.value.minute.toString().padLeft(2, '0')}',
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
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 18,
                          ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: ValueListenableBuilder(
                          valueListenable: endDate,
                          builder: (context, child, value) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.accentColor,
                              ),
                              onPressed: () async {
                                final date = await endPickData();
                                if (date == null) return;
                                final newDateTime = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  endDate.value.hour,
                                  endDate.value.minute,
                                );
                                endDate.value = newDateTime;
                              },
                              child: Text(
                                '${endDate.value.year} - ${endDate.value.month} - ${endDate.value.day}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
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
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 18,
                          ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: ValueListenableBuilder(
                          valueListenable: endDate,
                          builder: (context, child, value) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.accentColor,
                              ),
                              onPressed: () async {
                                final time = await endPickTime();
                                if (time == null) return;
                                final newDateTime = DateTime(
                                  endDate.value.year,
                                  endDate.value.month,
                                  endDate.value.day,
                                  time.hour,
                                  time.minute,
                                );
                                setState(() {
                                  endDate.value = newDateTime;
                                });
                              },
                              child: Text(
                                '$endHours:$endMinutes',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                'Status :',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
          const SizedBox(height: 10),
          BlocConsumer<OfferCubit, OfferState>(
            listenWhen: (_, newState) {
              return newState is OfferCreateLoadingState ||
                  newState is OfferCreateSuccessState;
            },
            listener: (context, state) {
              if (state is OfferCreateSuccessState) {
                Navigator.pop(context);
                showSnackBar(
                  context: context,
                  title: 'Success!!',
                  message: 'Offer Created Successfully',
                  snackbarType: SnackbarType.success,
                );
              }
            },
            builder: (context, state) {
              return SizedBox(
                height: 55,
                width: MediaQuery.of(context).size.width / 1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<OfferCubit>().createOffers(
                            title: widget.titleController.text,
                            offerPercentage: int.parse(offerController.text),
                            startDate: selectedStartDateTime,
                            endDate: selectedEndDateTime,
                            status: checkStatus.value == true ? 1 : 0,
                            products: selectAllProductCheck.value == false
                                ? newSelectedProductId
                                : [],
                            customers: selectAllCustomerCheck.value == false
                                ? newSelectedCustomerId
                                : [],
                          );
                    }
                  },
                  child: Text(
                    'Submit',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  Future<DateTime?> startPickData() => showDatePicker(
        context: context,
        initialDate: startDate.value,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

  Future<TimeOfDay?> startPickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: startTime.value.hour, minute: startTime.value.minute),
      );

  Future<DateTime?> endPickData() => showDatePicker(
        context: context,
        initialDate: endDate.value,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

  Future<TimeOfDay?> endPickTime() => showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: endDate.value.hour, minute: endDate.value.minute),
      );
}
