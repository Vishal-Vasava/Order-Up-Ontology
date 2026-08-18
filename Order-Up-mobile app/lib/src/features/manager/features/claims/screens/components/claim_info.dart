import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ClaimInfo extends StatelessWidget {
  const ClaimInfo({
    super.key,
    required this.paidAmount,
    required this.pendingAmount,
  });
  final double paidAmount;
  final double pendingAmount;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 20,
            spreadRadius: -13,
            color: AppColor.kShadowColor,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '\u{20B9}${(paidAmount + pendingAmount).toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                'Total Earnings',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          const Icon(
            PhosphorIcons.equals,
            size: 14.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '\u{20B9}${paidAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                'Paid',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          const Icon(
            kIsWeb ? Icons.add : Iconsax.add,
            size: 14.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '\u{20B9}${pendingAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                'Pending',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
