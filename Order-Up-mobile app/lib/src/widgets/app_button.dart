import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.isLoading,
    required this.buttonText,
    required this.onPressed,
    this.leadingWidget,
  });
  final Widget? leadingWidget;
  final bool isLoading;
  final String buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(kDefaultPadding),
          backgroundColor: Theme.of(context).primaryColor,
          minimumSize: const Size(double.infinity, 64),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(kBorderRadius - 4)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leadingWidget ?? const SizedBox(),
            gapW12,
            Text(
              buttonText,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            gapW12,
            if (isLoading)
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                width: 14,
                height: 14,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
          ],
        ),
      );
    } else if (Platform.isIOS || Platform.isAndroid) {
      return CupertinoButton(
        onPressed: isLoading ? null : onPressed,
        color: Theme.of(context)
            .elevatedButtonTheme
            .style!
            .backgroundColor!
            .resolve(
          {},
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonText,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            gapW12,
            if (isLoading)
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                width: 14,
                height: 14,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
