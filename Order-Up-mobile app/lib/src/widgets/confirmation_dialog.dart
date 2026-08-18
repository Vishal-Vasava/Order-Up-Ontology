import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.height,
    required this.width,
    this.swapButtons = false,
    this.onCancel,
    this.cancelButton,
  });
  final double height;
  final double width;
  final String title;
  final String message;
  final bool swapButtons;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final Widget? cancelButton;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: height,
      // width: width,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                IconButton(
                  onPressed: context.pop,
                  icon: const Icon(
                    kIsWeb ? Icons.close : Iconsax.close_square,
                  ),
                ),
              ],
            ),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            gapH12,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: swapButtons
                      ? () {
                          if (onCancel == null) {
                            context.pop();
                          } else {
                            onCancel!.call();
                          }
                        }
                      : onConfirm,
                  child: Container(
                    color: Colors.transparent,
                    height: 30.0,
                    width: 40.0,
                    alignment: Alignment.center,
                    child: Text(
                      swapButtons ? 'NO' : 'YES',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                gapW32,
                GestureDetector(
                  onTap: swapButtons
                      ? onConfirm
                      : () {
                          if (onCancel == null) {
                            context.pop();
                          } else {
                            onCancel!.call();
                          }
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        swapButtons ? 'YES' : 'NO',
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                gapW12,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
