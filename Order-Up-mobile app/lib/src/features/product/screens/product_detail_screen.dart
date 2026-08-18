import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/cart/screens/cubit/cart_cubit.dart';
import 'package:orderly_ecom/src/features/cart/screens/widgets/cart_stepper.dart';
import 'package:orderly_ecom/src/features/product/screens/cubit/product_cubit.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/clippers.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:orderly_ecom/src/widgets/app_button.dart';
import 'package:orderly_ecom/src/widgets/default_error_screen.dart';
import 'package:orderly_ecom/src/widgets/image_builder.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.productId,
    required this.productName,
  });
  final String productId;
  final String productName;
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context
          .read<ProductCubit>()
          .getProductDetail(productId: widget.productId);
    });
  }

  int _selectedQuantity = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderlyAppBar(
        title: widget.productName,
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        buildWhen: (_, newState) {
          return newState is ProductDetailFailedState ||
              newState is ProductDetailLoadedState ||
              newState is ProductDetailLoadingState;
        },
        builder: (context, state) {
          if (state is ProductDetailLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ProductDetailFailedState) {
            return DefaultErrorScreen(message: state.message);
          }
          if (state is ProductDetailLoadedState) {
            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                gapH24,
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width - 40.0,
                  child: CachedNetworkImage(
                    imageUrl: state.product.imageUrl!,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                    placeholder: (context, url) {
                      return Shimmer.fromColors(
                        baseColor: Theme.of(context).hoverColor,
                        highlightColor: Theme.of(context).highlightColor,
                        enabled: true,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Shimmer.fromColors(
                        baseColor: Theme.of(context).hoverColor,
                        highlightColor: Theme.of(context).highlightColor,
                        enabled: true,
                        child: const Icon(
                          Icons.error,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.product.name!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Row(
                      children: [
                        Text(
                          '${state.product.currency?.locale!.getCurrencyPerLocale} ${state.product.price}',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: state.product.offerPrice != null
                                        ? Colors.red
                                        : AppColor.accentColor,
                                    decoration: state.product.offerPrice != null
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                        ),
                        gapW12,
                        if (state.product.offerPrice != null)
                          Text(
                            '${state.product.currency?.locale!.getCurrencyPerLocale} ${state.product.offerPrice}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: AppColor.accentColor,
                                ),
                          ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.description,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      CartStepper(
                        quantity: 1,
                        topMargin: 0,
                        maxQuantity: state.product.qty!,
                        onChange: (int qty) {
                          _selectedQuantity = qty;
                        },
                      ),
                    ],
                  ),
                ),
                Text(
                  state.product.desc!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                gapH24,
                if (state.product.returnPolicy?.title != null)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: AppColor.scaleGreyColor,
                              spreadRadius: 2,
                              blurRadius: 20,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.find_replace,
                              size: 30,
                            ),
                            Text(
                              state.product.returnPolicy?.title ?? '',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                state.product.returnPolicy?.title != null ? gapH24 : gapH4,
                CustomPaint(
                  size: const Size(double.infinity, 8),
                  painter: DashedLinePainter(
                    lineColor: AppColor.blackColor20,
                  ),
                ),
                state.product.returnPolicy?.title != null ? gapH24 : gapH4,
                if ((state.product.averageRatings != null &&
                    state.product.averageRatings! != 0))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ratings',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      ...List.generate(
                        state.product.averageRatings ?? 0,
                        (index) => const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Iconsax.star,
                            color: AppColor.accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                gapH12,
                CustomPaint(
                  size: const Size(double.infinity, 8),
                  painter: DashedLinePainter(
                    lineColor: AppColor.blackColor10,
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Reviews',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        gapW12,
                        CircleAvatar(
                          radius: 15,
                          backgroundColor:
                              AppColor.accentColor.withOpacity(0.1),
                          child: Text(
                            state.product.reviews?.length.toString() ?? '0',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: AppColor.accentColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                    ...List.generate(
                      state.product.reviews?.length ?? 0,
                      (index) => ListTile(
                        leading: DottedBorder(
                          borderType: BorderType.Circle,
                          dashPattern: const [1, 0],
                          strokeWidth: 1,
                          color: AppColor.primaryColor.withOpacity(0.4),
                          child: CircleAvatar(
                            child: ImageBuilder(
                              imageUrl: state.product.reviews![index].customer
                                      ?.imageUrl ??
                                  '',
                              height: 40,
                              borderRadius: 40,
                              fitType: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          '${state.product.reviews![index].customer!.firstName} ${state.product.reviews![index].customer!.lastName}',
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: AppColor.accentColor,
                                  ),
                        ),
                        subtitle: Text(
                          state.product.reviews![index].review ?? '',
                          style: Theme.of(context).textTheme.titleSmall!,
                        ),
                        trailing: CircleAvatar(
                          radius: 15.0,
                          backgroundColor:
                              AppColor.accentColor.withOpacity(0.1),
                          child: Text(
                            state.product.reviews![index].rating?.toString() ??
                                '0',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: AppColor.accentColor,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return SizedBox.fromSize();
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
          right: kBorderRadius,
          left: kBorderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<ProductCubit, ProductState>(
              buildWhen: (_, newState) {
                return newState is ProductDetailFailedState ||
                    newState is ProductDetailLoadedState ||
                    newState is ProductDetailLoadingState;
              },
              builder: (context, state) {
                if (state is ProductDetailLoadedState) {
                  return BlocConsumer<CartCubit, CartState>(
                    listenWhen: (_, newState) {
                      return newState is CartLoadingState ||
                          newState is CartAddFailedState;
                    },
                    listener: (context, state) {
                      if (state is CartAddFailedState) {
                        showSnackBar(
                          context: context,
                          title: 'Oops',
                          message:
                              state.message.replaceAll('Exception:', '').trim(),
                          snackbarType: SnackbarType.error,
                        );
                      }
                    },
                    builder: (context, cartState) {
                      return AppButton(
                        isLoading: cartState is CartLoadingState,
                        onPressed: () async {
                          HapticFeedback.lightImpact();
                          await context.read<CartCubit>().addToCart(
                                productId: state.product.productId!.toString(),
                                quantity: _selectedQuantity,
                              );
                        },
                        buttonText: AppLocalizations.of(context)!.add_to_cart,
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
