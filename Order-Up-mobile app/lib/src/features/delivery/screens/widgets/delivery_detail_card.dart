import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/delivery/domain/delivery_order_detail.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

class DeliveryDetailCard extends StatelessWidget {
  const DeliveryDetailCard({
    super.key,
    required this.modelData,
    required this.onChanged,
    required this.orderStatus,
  });
  final OrderItem modelData;
  final Function(bool?) onChanged;
  final String orderStatus;

  @override
  Widget build(BuildContext context) {
    final bool isCheckbox = (orderStatus == 'delivered');
    return Visibility(
      visible: !isCheckbox,
      child: CheckboxListTile(
        value: modelData.isChecked,
        // value: modelData.status == 'delivered' ? true : false,
        onChanged: onChanged,
        contentPadding: EdgeInsets.zero,
        title: Container(
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
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      filterQuality: FilterQuality.medium,
                      memCacheHeight: 300,
                      imageUrl: modelData.productImageUrl ?? '',
                      placeholder: (context, url) {
                        return Shimmer.fromColors(
                          baseColor: Theme.of(context).hoverColor,
                          highlightColor: Theme.of(context).highlightColor,
                          enabled: true,
                          child: Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      },
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              // fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Shimmer.fromColors(
                          baseColor: Theme.of(context).hoverColor,
                          highlightColor: Theme.of(context).highlightColor,
                          enabled: true,
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.error),
                          ),
                        );
                      },
                    ),
                    gapW12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                modelData.producer?.name ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.primaryColor,
                                    ),
                              ),
                            ],
                          ),
                          ReadMoreText(
                            modelData.productDesc!,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  fontSize: 14.0,
                                  color: AppColor.textColor,
                                  fontWeight: FontWeight.w400,
                                ),
                            trimLines: 2,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Show more',
                            trimExpandedText: 'Show less',
                          ),
                          Row(
                            children: [
                              Text(
                                'Quantity : ',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontSize: 14.0,
                                      color: AppColor.textColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Text(
                                modelData.qty?.toString() ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontSize: 12.0,
                                      color: AppColor.textColor,
                                      fontWeight: FontWeight.w300,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
