import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/features/orders/domain/order.dart';
import 'package:orderly_ecom/src/features/orders/screens/widgets/order_card.dart';

class OrderExpandedCard extends StatelessWidget {
  const OrderExpandedCard({super.key, required this.modelData});
  final Order modelData;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor.accentColor.withOpacity(0.4),
        ),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: RichText(
          text: TextSpan(
            text: 'Order No : ',
            style: Theme.of(context).textTheme.titleMedium,
            children: [
              TextSpan(
                text: modelData.orderNumber.toString(),
                style: Theme.of(context).textTheme.titleSmall,
              )
            ],
          ),
        ),
        children: [
          OrderCard(
            modelData: modelData,
          ),
        ],
      ),
    );
  }
}
