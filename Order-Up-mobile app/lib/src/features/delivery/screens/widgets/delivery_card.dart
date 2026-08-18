import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/delivery/domain/delivery.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';

class DeliveryCard extends StatelessWidget {
  const DeliveryCard({
    super.key,
    required this.modelData,
    required this.onPressed,
  });
  final Delivery modelData;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kBorderRadius),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 17),
              blurRadius: 12.0,
              spreadRadius: -12.0,
              color: AppColor.kShadowColor,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              modelData.status!.normalize,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        Wrap(
                          children: [
                            Text(
                              modelData.orderNumber!,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(width: 16.0),
                            Text(
                              modelData.producer?.name ?? '',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "On ${DateFormat('EEEE, d MMM, yyyy').format(
                            modelData.createdAt!,
                          )}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CachedNetworkImage(
                    imageUrl: modelData.producer?.iconUrl ?? '',
                    height: 70.0,
                    // fitType: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  color: AppColor.bgColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  minSize: 26.0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8,
                  ),
                  child: Text(
                    'View Details',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onPressed.call();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
