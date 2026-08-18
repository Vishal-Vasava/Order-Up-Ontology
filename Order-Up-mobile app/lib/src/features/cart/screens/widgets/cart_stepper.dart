import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/theme/colors.dart';

class CartStepper extends StatefulWidget {
  const CartStepper({
    super.key,
    required this.maxQuantity,
    required this.quantity,
    required this.onChange,
    this.topMargin = 50.0,
  });
  final int maxQuantity;
  final int quantity;
  final Function(int) onChange;
  final double topMargin;

  @override
  State<CartStepper> createState() => _CartStepperState();
}

class _CartStepperState extends State<CartStepper> {
  ValueNotifier<int> quantity = ValueNotifier<int>(1);
  late int maxValue;
  @override
  void initState() {
    super.initState();
    maxValue = widget.maxQuantity;
    quantity.value = widget.quantity;
  }

  @override
  void dispose() {
    quantity.value = 1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: widget.topMargin),
      padding: const EdgeInsets.all(12.0),
      child: ValueListenableBuilder(
        valueListenable: quantity,
        builder: (BuildContext context, int value, Widget? child) {
          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: CupertinoButton(
                  onPressed: () {
                    // if (value != 1) {
                    quantity.value -= 1;
                    // }
                    _updateValue(quantity.value);
                  },
                  borderRadius: BorderRadius.circular(8.0),
                  padding: EdgeInsets.zero,
                  minSize: 20.0,
                  color: AppColor.primaryColor.withOpacity(0.1),
                  child: const Center(
                    child: Icon(
                      kIsWeb ? Icons.remove : Iconsax.minus,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
              ),
              Text(
                '$value',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: CupertinoButton(
                  onPressed: value + 1 > maxValue
                      ? null
                      : () {
                          quantity.value += 1;
                          _updateValue(quantity.value);
                        },
                  borderRadius: BorderRadius.circular(8.0),
                  padding: EdgeInsets.zero,
                  minSize: 20.0,
                  color: AppColor.primaryColor,
                  child: const Icon(
                    kIsWeb ? Icons.add : Iconsax.add,
                    color: AppColor.whiteColor,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _updateValue(int value) {
    HapticFeedback.lightImpact();
    widget.onChange(value);
  }
}
