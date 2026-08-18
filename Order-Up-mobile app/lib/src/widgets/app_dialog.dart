import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/theme/colors.dart';

class AppDialog {
  static Future<dynamic> viewDialog({
    required BuildContext context,
    required Widget content,
    double elevation = 1.0,
    double padding = kDefaultPadding,
    Color barrierColor = AppColor.darkGreyColor,
    Color backgroundColor = Colors.white,
    bool barrierDismissible = true,
  }) async {
    final result = await showDialog(
      context: context,
      barrierColor: barrierColor.withOpacity(0.7),
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return barrierDismissible;
          },
          child: AlertDialog(
            elevation: elevation,
            insetPadding: EdgeInsets.zero,
            backgroundColor: backgroundColor,
            contentPadding: EdgeInsets.all(padding),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            content: content,
          ),
        );
      },
    );
    return result;
  }

  static Future<void> simpleDialog({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
    Color backgroundColor = AppColor.blackColor,
  }) async {
    await showDialog(
      context: context,
      barrierColor: backgroundColor.withOpacity(0.7),
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return child;
      },
    );
  }

  static void showBottomSheet({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = false,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      barrierColor: AppColor.blackColor80.withOpacity(0.6),
      backgroundColor: Colors.transparent,
      builder: (c) {
        return child;
      },
    );
  }

  static showLoader(BuildContext context) {
    simpleDialog(
      context: context,
      barrierDismissible: false,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 40.0,
              width: 40.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation(
                      AppColor.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static showDatePicker({
    required BuildContext context,
    required ValueChanged<DateTime> onDatePick,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          gapH12,
          Center(
            child: Container(
              height: 5,
              width: 80.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: AppColor.greyColor,
              ),
            ),
          ),
          gapH12,
          SizedBox(
            height: 160,
            child: CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              mode: CupertinoDatePickerMode.date,
              minimumDate: DateTime(1930, 01, 01),
              maximumDate: DateTime.now(),
              dateOrder: DatePickerDateOrder.dmy,
              onDateTimeChanged: onDatePick,
            ),
          ),
        ],
      ),
    );
  }
}
