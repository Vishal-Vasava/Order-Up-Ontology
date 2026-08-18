import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/features/cart/screens/cubit/cart_cubit.dart';
import 'package:orderly_ecom/src/features/product/domain/product.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:orderly_ecom/src/widgets/image_builder.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.modelData,
    required this.onTap,
  });
  final ProductData modelData;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: modelData.qty! == 0 ? null : onTap,
      child: Container(
        margin: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: List.generate(
                modelData.filters?.length ?? 0,
                (index) => ImageBuilder(
                  imageUrl: modelData.filters?[index].iconUrl! ?? '',
                  height: 30,
                  width: 30,
                  fitType: BoxFit.contain,
                  borderColor: Colors.transparent,
                  imgBgColor: Colors.transparent,
                ),
              ),
            ),
            Center(
              child: ImageBuilder(
                imageUrl: modelData.imageUrl ?? '',
                height: 140,
                width: 160,
                fitType: BoxFit.contain,
                borderColor: Colors.transparent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(
                modelData.name!,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 6, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // '${modelData.currency!.getCurrencyPerLocale}
                    '${modelData.currency?.locale!.getCurrencyPerLocale} ${modelData.price}',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: modelData.offerPrice != null
                              ? Colors.red
                              : AppColor.accentColor,
                          decoration: modelData.offerPrice != null
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                  ),
                  if (modelData.offerPrice != null)
                    Text(
                      '${modelData.currency?.locale!.getCurrencyPerLocale} ${modelData.offerPrice!.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: AppColor.accentColor,
                          ),
                    ),
                  BlocBuilder<CartCubit, CartState>(
                    // buildWhen: (_, newState) {
                    //   return newState is CartLoadingState;
                    // },
                    builder: (context, state) {
                      String productId = '';
                      if (state is CartLoadingState) {
                        productId = state.productId;
                      }
                      return CupertinoButton(
                        color: Theme.of(context).primaryColor,
                        minSize: 35.0,
                        borderRadius: BorderRadius.circular(12.0),
                        padding: EdgeInsets.zero,
                        onPressed: modelData.qty! == 0
                            ? null
                            : modelData.productId!.toString() == productId
                                ? null
                                : () async {
                                    await context.read<CartCubit>().addToCart(
                                          productId:
                                              modelData.productId!.toString(),
                                          quantity: 1,
                                        );
                                  },
                        child: modelData.productId!.toString() == productId
                            ? const Center(child: CircularProgressIndicator())
                            : const Icon(
                                kIsWeb ? Icons.add : Iconsax.add,
                                color: Colors.white,
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Visibility(
              visible: modelData.qty! == 0,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Out of Stock'.hardcoded,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColor.greyColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
