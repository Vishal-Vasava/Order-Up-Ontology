import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/theme/colors.dart';

const InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
  fillColor: AppColor.blackColor5,
  filled: true,
  hintStyle: TextStyle(color: AppColor.blackColor40),
  border: outlineInputBorder,
  enabledBorder: outlineInputBorder,
  focusedBorder: focusedOutlineInputBorder,
  errorBorder: errorOutlineInputBorder,
);

const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(kBorderRadius - 4)),
  borderSide: BorderSide(color: AppColor.greyColor),
);

const OutlineInputBorder focusedOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(kBorderRadius - 4)),
  borderSide: BorderSide(color: AppColor.blackColor),
);

const OutlineInputBorder errorOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(kBorderRadius - 4)),
  borderSide: BorderSide(
    color: AppColor.errorColor,
  ),
);

OutlineInputBorder secodaryOutlineInputBorder(BuildContext context) {
  return OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(kBorderRadius - 4)),
    borderSide: BorderSide(
      color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.15),
    ),
  );
}
