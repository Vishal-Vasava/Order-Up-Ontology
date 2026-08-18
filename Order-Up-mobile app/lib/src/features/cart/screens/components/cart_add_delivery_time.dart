import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/cart/screens/cubit/cart_cubit.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';

class CartAddDeliveryTime extends StatefulWidget {
  const CartAddDeliveryTime({super.key});

  @override
  _CartAddDeliveryTimeState createState() => _CartAddDeliveryTimeState();
}

class _CartAddDeliveryTimeState extends State<CartAddDeliveryTime> {
  final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final String currentTime = DateFormat('hh:mm a').format(DateTime.now());

  late ValueNotifier<String> deliveryTime;

  @override
  void initState() {
    super.initState();
    deliveryTime = ValueNotifier('0');
    checkIfTimeValid();
    deliverySlot.value = context.read<CartCubit>().deliverySlot;
  }

  bool isMorning = false;
  bool isEvening = false;
  void checkIfTimeValid({DateTime? picked}) {
    final currentTime = DateTime.now();

    /// Executed when user picks date.
    if (picked != null) {
      selectedDateTime.value = DateFormat('yyyy-MM-dd').format(picked);
      // If Day is same
      if (currentTime.day == picked.day) {
        /// If current hours falls between 7Am and 11Am then it is morning
        if (currentTime.hour >= 7 && currentTime.hour <= 11) {
          isMorning = true;
          deliveryTime.value = '0';
        } else {
          isMorning = false;
          deliveryTime.value = '1';
        }
        if (currentTime.hour >= 0 && currentTime.hour <= 7) {
          isMorning = true;
          deliveryTime.value = '0';
        } else {
          isEvening = false;
          deliveryTime.value = '0';
        }
        // If current hour is 5pm
        if (currentTime.hour >= 17) {
          /// If current hour is any hour after 5pm. then it is evening.
          if (currentTime.hour <= 24) {
            isEvening = true;
            deliveryTime.value = '1';
          } else {
            isEvening = false;
            deliveryTime.value = '0';
          }
        } else {
          isEvening = false;
          deliveryTime.value = '0';
        }
      } else {
        isMorning = true;
        isEvening = true;
        deliveryTime.value = '0';
      }
    } else {
      selectedDateTime.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
      if (currentTime.hour >= 7 && currentTime.hour <= 11) {
        isMorning = true;
        deliveryTime.value = '0';
      } else if (currentTime.hour >= 17) {
        if (currentTime.hour <= 24) {
          isEvening = true;
          deliveryTime.value = '1';
        } else {
          isEvening = false;
          deliveryTime.value = '0';
        }
      } else {
        isMorning = true;
        isEvening = false;
        deliveryTime.value = '0';
      }
    }
    setState(() {});
  }

  DateTime? selectedDate;

  ValueNotifier<String> deliverySlot = ValueNotifier<String>('-1');

  ValueNotifier<String> selectedDateTime = ValueNotifier('');

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime(2025),
    );
    checkIfTimeValid(picked: picked);
    final month = DateFormat('MM').format(picked!);
    final year = DateFormat('yyyy').format(picked);
    final day = DateFormat('dd').format(picked);
    selectedDate = DateTime(int.parse(year), int.parse(month), int.parse(day));
    selectedDateTime.value = DateFormat('yyyy-MM-dd').format(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.select_delivery_slot,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textColor,
                  ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Card(
                elevation: 2.0,
                child: Column(
                  children: [
                    Row(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: deliverySlot,
                          builder: (BuildContext context, String value,
                              Widget? child) {
                            return Checkbox(
                              checkColor: Colors.white,
                              activeColor: AppColor.primaryColor,
                              fillColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return Colors.orange.withOpacity(.32);
                                }
                                if (states.contains(MaterialState.pressed)) {
                                  return AppColor.primaryColor;
                                }
                                if (states.contains(MaterialState.selected)) {
                                  return AppColor.primaryColor;
                                }
                                return Colors.white;
                              }),
                              value: value == 'morning',
                              onChanged: (bool? value) {
                                deliverySlot.value = value! ? 'morning' : '-1';
                              },
                            );
                          },
                        ),
                        Text(
                          AppLocalizations.of(context)!.chargeable_delivery,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.textColor,
                                  ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 35.0),
                          child: Text(
                            'Chargeable ${context.read<CartCubit>().currency.getCurrencyPerLocale} ${context.read<CartCubit>().chargeAmount}',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).primaryColor,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    ValueListenableBuilder(
                      valueListenable: deliverySlot,
                      builder:
                          (BuildContext context, String value, Widget? child) {
                        return Visibility(
                          visible: value == 'morning',
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 5.0, bottom: 10.0),
                            child: Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .schedule_delivery_for,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                                Text(
                                  DateFormat('dd MMM yyyy')
                                      .format(DateTime.parse(currentDate)),
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.textColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            //for planned
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Card(
                elevation: 2.0,
                child: Column(
                  children: [
                    Row(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: deliverySlot,
                          builder: (BuildContext context, String value,
                              Widget? child) {
                            return Checkbox(
                              checkColor: Colors.white,
                              activeColor: AppColor.primaryColor,
                              fillColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return Colors.orange.withOpacity(.32);
                                }
                                if (states.contains(MaterialState.pressed)) {
                                  return AppColor.primaryColor;
                                }
                                if (states.contains(MaterialState.selected)) {
                                  return AppColor.primaryColor;
                                }
                                return Colors.white;
                              }),
                              value: value == 'evening',
                              onChanged: (bool? value) {
                                deliverySlot.value = value! ? 'evening' : '-1';
                              },
                            );
                          },
                        ),
                        Text(
                          AppLocalizations.of(context)!.free_delivery,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.textColor,
                                  ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Text(
                            'Free',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).primaryColor,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    ValueListenableBuilder(
                      valueListenable: deliverySlot,
                      builder:
                          (BuildContext context, String value, Widget? child) {
                        return Visibility(
                          visible: value == 'evening',
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0, top: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.choose_date,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                    ),
                                    //date
                                    Row(
                                      children: [
                                        ValueListenableBuilder(
                                          valueListenable: selectedDateTime,
                                          builder: (BuildContext context,
                                              String value, Widget? child) {
                                            return Text(
                                              value,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColor.textColor,
                                                  ),
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 8.0),
                                        GestureDetector(
                                          onTap: _selectDate,
                                          child: const Icon(
                                            kIsWeb
                                                ? Icons.calendar_month
                                                : Iconsax.calendar,
                                            color: AppColor.accentColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              //morning/evening day selection
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: ValueListenableBuilder(
                                  valueListenable: deliveryTime,
                                  builder: (BuildContext context, String value,
                                      Widget? child) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, top: 10.0),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .choose_delivery_time,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 35.0,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    unselectedWidgetColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                  ),
                                                  child: ListTileTheme(
                                                    horizontalTitleGap: 1,
                                                    child: RadioListTile(
                                                      dense: true,
                                                      activeColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      groupValue: value,
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .morning,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall!
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: !isMorning
                                                                      ? AppColor
                                                                          .greyColor
                                                                      : AppColor
                                                                          .textColor,
                                                                ),
                                                          ),
                                                          Text(
                                                            '7 am - 11 am',
                                                            style: TextStyle(
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: !isMorning
                                                                  ? AppColor
                                                                      .greyColor
                                                                  : AppColor
                                                                      .textColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      value: '0',
                                                      onChanged: !isMorning
                                                          ? null
                                                          : (String? val) {
                                                              deliveryTime
                                                                  .value = val!;
                                                            },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        //for evening
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Theme(
                                                data:
                                                    Theme.of(context).copyWith(
                                                  unselectedWidgetColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                ),
                                                child: ListTileTheme(
                                                  horizontalTitleGap: 1,
                                                  child: RadioListTile(
                                                    dense: true,
                                                    activeColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    groupValue: value,
                                                    title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .evening,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: !isEvening
                                                                        ? AppColor
                                                                            .greyColor
                                                                        : AppColor
                                                                            .textColor,
                                                                  ),
                                                        ),
                                                        Text(
                                                          '5 pm - 9 pm',
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: !isEvening
                                                                ? AppColor
                                                                    .greyColor
                                                                : AppColor
                                                                    .textColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    value: '1',
                                                    onChanged: !isEvening
                                                        ? null
                                                        : (String? val) {
                                                            deliveryTime.value =
                                                                val!;
                                                          },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // const Padding(
                                            //   padding: EdgeInsets.all(5.0),
                                            //   child:
                                            // )
                                          ],
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            gapH8,
            CupertinoButton(
              color: AppColor.primaryColor,
              onPressed: () {
                if (deliverySlot.value == '-1') {
                  showSnackBar(
                    context: context,
                    title: 'Please Select',
                    message: 'Delivery Slot',
                    snackbarType: SnackbarType.error,
                  );
                  return;
                }
                if (deliverySlot.value == 'evening') {
                  if (deliveryTime.value == '') {
                    showSnackBar(
                      context: context,
                      title: 'Please Select',
                      message: 'Delivery Time',
                      snackbarType: SnackbarType.error,
                    );
                    return;
                  }
                  if (selectedDateTime.value == '') {
                    showSnackBar(
                      context: context,
                      title: 'Please Select',
                      message: 'Delivery Date',
                      snackbarType: SnackbarType.error,
                    );
                    return;
                  }
                }
                if (deliverySlot.value == 'morning') {
                  context.read<CartCubit>().changeDeliveryTime(
                        deliverySlot: deliverySlot.value,
                        deliveryTime: '',
                        deliveryDate: selectedDateTime.value,
                      );
                } else {
                  context.read<CartCubit>().changeDeliveryTime(
                        deliverySlot: deliverySlot.value,
                        deliveryTime: deliveryTime.value,
                        deliveryDate: selectedDateTime.value,
                      );
                }
                context.pop();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Confirm Delivery Option'.hardcoded,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: AppColor.whiteColor,
                        ),
                  ),
                ],
              ),
            ),
            gapH8,
          ],
        ),
      ),
    );
  }
}
