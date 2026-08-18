import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/cart/domain/cart.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/widgets/image_builder.dart';
import 'package:readmore/readmore.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    super.key,
    required this.modelData,
    required this.onDelete,
    required this.fromCheckout,
  });
  final CartItem modelData;
  final VoidCallback onDelete;
  final bool fromCheckout;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: fromCheckout
          ? const EdgeInsets.all(2.0)
          : const EdgeInsets.all(kDefaultPadding),
      // padding:
      //     fromCheckout ? EdgeInsets.zero : const EdgeInsets.all(kBorderRadius),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: fromCheckout
            ? null
            : const [
                BoxShadow(
                  spreadRadius: 3.0,
                  blurRadius: 3.0,
                  color: AppColor.kShadowColor,
                ),
              ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ImageBuilder(
                imageUrl: modelData.product.imageUrl ?? '',
                height: fromCheckout ? 60 : 120.0,
                borderColor: Colors.transparent,
              ),
              gapW12,
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Text(
                            modelData.product.name ?? '',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            onDelete.call();
                          },
                          icon: const Icon(
                            kIsWeb ? Icons.delete : Iconsax.trash,
                            color: AppColor.accentColor,
                          ),
                        ),
                      ],
                    ),
                    ReadMoreText(
                      modelData.product.desc ?? '',
                      style: Theme.of(context).textTheme.bodySmall,
                      trimLines: 3,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Show more',
                      trimExpandedText: 'Show less',
                    ),
                    if (fromCheckout)
                      Text(
                        'Quantity : ${modelData.qty}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       '${modelData.product.currency?.locale!.getCurrencyPerLocale}  ${modelData.product.price}',
                    //       style: Theme.of(context)
                    //           .textTheme
                    //           .labelLarge!
                    //           .copyWith(
                    //             fontWeight: FontWeight.w600,
                    //             color: modelData.product.offerPrice != null
                    //                 ? Colors.red
                    //                 : AppColor.accentColor,
                    //             decoration: modelData.product.offerPrice != null
                    //                 ? TextDecoration.lineThrough
                    //                 : TextDecoration.none,
                    //           ),
                    //     ),
                    //     if (modelData.product.offerPrice != null)
                    //       Text(
                    //         // '${modelData.currency!.getCurrencyPerLocale}
                    //         '${modelData.product.currency?.locale!.getCurrencyPerLocale} ${modelData.product.offerPrice}',
                    //         style: Theme.of(context)
                    //             .textTheme
                    //             .titleSmall!
                    //             .copyWith(
                    //               color: AppColor.accentColor,
                    //             ),
                    //       ),
                    //     fromCheckout
                    //         ? const Center()
                    //         : CartStepper(
                    //             topMargin: 5.0,
                    //             quantity: modelData.qty,
                    //             maxQuantity: modelData.product.qty!,
                    //             onChange: (int value) async {
                    //               if (value <= 0) {
                    //                 await context.read<CartCubit>().deleteCart(
                    //                       productId: modelData.product.id!,
                    //                     );
                    //               } else {
                    //                 await context.read<CartCubit>().updateCart(
                    //                       productId: modelData.product.id!,
                    //                       quantity: value.toString(),
                    //                     );
                    //               }
                    //             },
                    //           ),
                    //   ],
                    // ),
                    gapH4,
                    Visibility(
                      visible: !modelData.isAvailable,
                      child: Text(
                        AppLocalizations.of(context)!.cart_address_error,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: AppColor.errorColor,
                            ),
                      ),
                    ),
                    gapH4,
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
