import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/inventory.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:orderly_ecom/src/widgets/image_builder.dart';
import 'package:readmore/readmore.dart';

class InventoryCard extends StatelessWidget {
  const InventoryCard({
    super.key,
    required this.modelData,
    required this.onRemove,
    required this.onEdit,
  });
  final InventoryItem modelData;
  final VoidCallback onRemove;
  final VoidCallback onEdit;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      margin: const EdgeInsets.all(kBorderRadius),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(kBorderRadius - 4),
        boxShadow: const [
          BoxShadow(
            color: AppColor.scaleGreyColor,
            spreadRadius: 4.5,
            blurRadius: 4.5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageBuilder(
                  imageUrl: modelData.imageUrl ?? '',
                  height: 70.0,
                  width: 70.0,
                  fitType: BoxFit.contain,
                ),
                gapW12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              modelData.name!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.textColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      ReadMoreText(
                        modelData.desc ?? '',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontSize: 12.0,
                              color: AppColor.textColor,
                              fontWeight: FontWeight.w400,
                            ),
                        trimLines: 2,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: 'Show less',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            gapH12,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rate', style: Theme.of(context).textTheme.bodyLarge!),
                    Text(
                      '${modelData.currency!.locale!.getCurrencyPerLocale} ${modelData.price}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: AppColor.primaryColor,
                          ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Quantity',
                      style: Theme.of(context).textTheme.bodyLarge!,
                    ),
                    Text(
                      modelData.qty.toString(),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: AppColor.primaryColor,
                          ),
                    ),
                  ],
                ),
                //producer name
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category',
                        style: Theme.of(context).textTheme.bodyLarge!),
                    Text(
                      modelData.producer?.name ?? '',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: AppColor.primaryColor,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            gapH12,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                            color: Theme.of(context).primaryColor, width: 1),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(kBorderRadius),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                      ),
                      onPressed: onEdit,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Edit',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                gapW12,
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                            color: Theme.of(context).primaryColor, width: 1),
                        foregroundColor: AppColor.whiteColor,
                        padding: const EdgeInsets.all(kBorderRadius),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                      ),
                      onPressed: onRemove,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Remove',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: AppColor.whiteColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
