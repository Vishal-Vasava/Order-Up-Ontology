import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orderly_ecom/src/constants/static_text.dart';
import 'package:orderly_ecom/src/features/manager/features/claims/domain/claim.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';

class ClaimCard extends StatelessWidget {
  const ClaimCard({super.key, required this.modelData});
  final ClaimData modelData;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 24.0, 12.0),
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
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  modelData.orderId,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  DateFormat(StaticText.dateFormat).format(modelData.createdAt),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  'No of items',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  modelData.qty.toString(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12.0),
          if (modelData.paidStatus)
            Expanded(
              flex: 0,
              child: Text(
                '${modelData.currency.locale?.getCurrencyPerLocale} ${modelData.price}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            )
          else
            Expanded(
              flex: 1,
              child: Text(
                '${modelData.currency.locale?.getCurrencyPerLocale} ${modelData.price}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
        ],
      ),
    );
  }
}
