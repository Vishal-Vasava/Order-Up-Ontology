import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/theme/button_theme.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/theme/input_decoration_theme.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.light,
      primaryColor: AppColor.primaryColor,
      primarySwatch: AppColor.getMaterialColorFromColor(AppColor.primaryColor),
      dividerColor: AppColor.blackColor.withOpacity(0.1),
      shadowColor: AppColor.kShadowColor,
      fontFamily: 'poppins',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColor.blackColor),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColor.blackColor,
        ),
      ),
      tabBarTheme: const TabBarTheme(),
      cupertinoOverrideTheme: const CupertinoThemeData(
        primaryColor: AppColor.primaryColor,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all(AppColor.primaryColor),
      ),
      tooltipTheme: const TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColor.lighterBlack,
        ),
        textStyle: TextStyle(color: Colors.white),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all(AppColor.primaryColor),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(AppColor.primaryColor),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(kBorderRadius / 2),
          ),
        ),
        side: const BorderSide(color: AppColor.blackColor10),
      ).copyWith(
        side: const BorderSide(color: AppColor.blackColor40),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColor.primaryColor,
      ),
      textButtonTheme: textButtonThemeData(primaryColor: AppColor.primaryColor),
      elevatedButtonTheme:
          elevatedButtonThemeData(primaryColor: AppColor.primaryColor),
      outlinedButtonTheme:
          outlinedButtonTheme(borderColor: AppColor.primaryColor),
      inputDecorationTheme: lightInputDecorationTheme,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColor.primaryColor,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColor.blackColor40),
      ),
      iconTheme: const IconThemeData(color: AppColor.blackColor),
    );
  }
}
