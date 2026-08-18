import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/constants/app_assets.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:shimmer/shimmer.dart';

class ImageBuilder extends StatelessWidget {
  const ImageBuilder({
    super.key,
    required this.imageUrl,
    required this.height,
    this.width = 100.0,
    this.borderColor = AppColor.greyColor,
    this.imgBgColor = AppColor.whiteColor,
    this.fitType,
    this.borderRadius = kBorderRadius,
  });
  final String imageUrl;
  final double height;
  final double? width;
  final BoxFit? fitType;
  final Color borderColor;
  final Color imgBgColor;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image(
          height: height,
          width: width,
          fit: fitType,
          image: AssetImage(
            AppAssets.customerIcon,
          ),
        ),
      );
    }
    return CachedNetworkImage(
      memCacheHeight: 300,
      imageUrl: imageUrl.isEmpty
          ? 'https://order-up.in/images/logo_light.jpg'
          : imageUrl,
      placeholder: (context, url) {
        return Shimmer.fromColors(
          baseColor: Theme.of(context).hoverColor,
          highlightColor: Theme.of(context).highlightColor,
          enabled: true,
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: imgBgColor,
            border: Border.all(
              color: borderColor,
            ),
          ),
          height: height,
          width: width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: fitType,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Shimmer.fromColors(
          baseColor: Theme.of(context).hoverColor,
          highlightColor: Theme.of(context).highlightColor,
          enabled: true,
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.error),
          ),
        );
      },
    );
  }
}
