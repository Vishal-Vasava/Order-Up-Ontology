import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum SnackbarType {
  success,
  warning,
  error,
}

void showSnackBar({
  required BuildContext context,
  required String title,
  required String? message,
  ValueChanged<Flushbar<dynamic>>? onTap,
  required SnackbarType snackbarType,
  double barBlur = 3.0,
  bool? positionTop,
  int duration = 2,
  Widget? actionButton,
  Color? messageColor,
  double? messageSize,
  Color? titleColor,
  double? titleSize,
}) async {
  await Flushbar(
    title: title,
    titleColor: titleColor,
    titleSize: titleSize,
    message: message,
    messageColor: messageColor,
    messageSize: messageSize,
    animationDuration: defaultDuration,
    duration: Duration(seconds: duration),
    borderRadius: BorderRadius.circular(Sizes.p12),
    margin: const EdgeInsets.symmetric(
      horizontal: kBorderRadius,
      vertical: kBorderRadius - 4,
    ),
    backgroundColor: snackbarType == SnackbarType.success
        ? AppColor.accentColor.withOpacity(0.7)
        : AppColor.darkGreyColor.withOpacity(0.9),
    icon: snackbarType == SnackbarType.success
        ? const Icon(
            kIsWeb ? Icons.check : PhosphorIcons.checks,
            color: AppColor.blackColor,
          )
        : snackbarType == SnackbarType.error
            ? const Icon(
                kIsWeb ? Icons.bug_report : PhosphorIcons.bug,
                color: AppColor.errorColor,
              )
            : snackbarType == SnackbarType.warning
                ? const Icon(
                    kIsWeb
                        ? Icons.warning_amber
                        : PhosphorIcons.circleWavyWarning,
                    color: AppColor.warningColor,
                  )
                : null,
    barBlur: barBlur,
    dismissDirection: snackbarType == SnackbarType.success
        ? FlushbarDismissDirection.HORIZONTAL
        : FlushbarDismissDirection.VERTICAL,
    mainButton: actionButton,
    onTap: onTap,
    flushbarPosition: positionTop != null
        ? FlushbarPosition.TOP
        : snackbarType == SnackbarType.success
            ? FlushbarPosition.TOP
            : FlushbarPosition.BOTTOM,
  ).show(context);
}
