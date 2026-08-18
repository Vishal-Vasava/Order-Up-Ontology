import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/pickup_estimates.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';

class PickupDropDown extends StatelessWidget {
  PickupDropDown({super.key, required this.productEstimatesList});

  final ValueNotifier<String> statusNotifier = ValueNotifier<String>('');

  final List<ProductEstimates> productEstimatesList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Estimates',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
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
                valueListenable: statusNotifier,
                builder: (BuildContext context, String value, Widget? child) {
                  return ButtonTheme(
                    buttonColor: Colors.white,
                    alignedDropdown: true,
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      itemHeight: 50,
                      menuMaxHeight: 300.0,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        hintText: '   Please Select Estimate'.hardcoded,
                      ),
                      value: value.isEmpty ? null : value,
                      onChanged: (data) {
                        statusNotifier.value = data;
                        log(statusNotifier.value,
                            name: 'CHANGED VALUE>>>>>>>>>>>>');
                      },
                      items: productEstimatesList.map<DropdownMenuItem>(
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
}
