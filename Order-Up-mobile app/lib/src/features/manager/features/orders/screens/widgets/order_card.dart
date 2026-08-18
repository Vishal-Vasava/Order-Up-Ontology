import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/constants/static_text.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/domain/manager_order.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/widgets/image_builder.dart';
import 'package:orderly_ecom/src/utils/clippers.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.modelData,
    required this.onTap,
  });
  final ManagerOrder modelData;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // padding: const EdgeInsets.all(kDefaultPadding),
        margin: const EdgeInsets.symmetric(vertical: kBorderRadius),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: const [
            BoxShadow(
              color: AppColor.scaleGreyColor,
              spreadRadius: 4.5,
              blurRadius: 4.5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        modelData.status.normalize,
                      ),
                      gapH8,
                      Text(
                        modelData.orderNumber,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      gapH8,
                      RichText(
                        text: TextSpan(
                          text:
                              '${AppLocalizations.of(context)!.total} - ${modelData.currency.locale!.getCurrencyPerLocale} ',
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                          children: [
                            TextSpan(
                              text:
                                  modelData.orderItemsAmount.toStringAsFixed(2),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      gapH8,
                      RichText(
                        text: TextSpan(
                          text: '${AppLocalizations.of(context)!.items} - ',
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                          children: [
                            TextSpan(
                              text: modelData.orderItemsCount.toString(),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      gapH8,
                    ],
                  ),
                  ImageBuilder(
                    imageUrl: modelData.producer.iconUrl ?? '',
                    height: 80.0,
                    width: 80.0,
                    fitType: BoxFit.cover,
                  ),
                ],
              ),
            ),
            CustomPaint(
              painter: DashedLinePainter(dashSpace: 1.5),
              size: const Size(double.infinity, 4),
            ),
            gapH8,
            Padding(
              padding: const EdgeInsets.all(kBorderRadius),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'On ${DateFormat(StaticText.dateFormat).format(
                      modelData.createdAt,
                    )}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  CupertinoButton(
                    color: AppColor.bgColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    minSize: 22.0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.view_detail,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onTap.call();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
