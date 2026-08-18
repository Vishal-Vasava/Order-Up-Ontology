import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/features/orders/domain/order.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/widgets/image_builder.dart';
import 'package:readmore/readmore.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.modelData,
    required this.orderItems,
  });
  final Order modelData;
  final OrderItem orderItems;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        border: Border.all(
          width: 0.3,
          color: AppColor.accentColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageBuilder(
            imageUrl: orderItems.productImageUrl == null
                ? 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80'
                : orderItems.productImageUrl!,
            height: 100.0,
            width: 100.0,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderItems.productName!,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                ReadMoreText(
                  orderItems.productName!,
                  style: Theme.of(context).textTheme.labelLarge!,
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: 'Show less',
                ),
                Text(
                  '${AppLocalizations.of(context)!.quantity}: ${orderItems.qty}',
                  style: Theme.of(context).textTheme.labelLarge!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
