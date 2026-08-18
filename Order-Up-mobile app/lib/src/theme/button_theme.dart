import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';

ElevatedButtonThemeData elevatedButtonThemeData({required Color primaryColor}) {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(kDefaultPadding),
      backgroundColor: primaryColor,
      minimumSize: const Size(double.infinity, Sizes.p32),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(kBorderRadius - 4)),
      ),
    ),
  );
}

TextButtonThemeData textButtonThemeData({required Color primaryColor}) {
  return TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: primaryColor),
  );
}

OutlinedButtonThemeData outlinedButtonTheme({Color borderColor = Colors.red}) {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.all(kDefaultPadding),
      foregroundColor: borderColor,
      minimumSize: const Size(double.infinity, Sizes.p32),
      side: BorderSide(width: 1, color: borderColor),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(kBorderRadius - 4)),
      ),
    ),
  );
}
