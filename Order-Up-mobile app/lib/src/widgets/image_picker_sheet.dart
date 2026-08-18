import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';

class ImagePickerSheet extends StatelessWidget {
  const ImagePickerSheet({
    super.key,
    required this.onCameraClick,
    required this.onGalleryClick,
    this.onSkuGalleryClick,
    this.showSku = false,
  });
  final VoidCallback onCameraClick;
  final VoidCallback onGalleryClick;
  final VoidCallback? onSkuGalleryClick;
  final bool showSku;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kBorderRadius),
      margin: EdgeInsets.fromLTRB(
        kDefaultPadding,
        kDefaultPadding,
        kDefaultPadding,
        MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                kIsWeb ? Icons.history : Iconsax.receipt,
                color: Colors.transparent,
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  width: 60.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: AppColor.greyColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.pop();
                },
                child: Icon(
                  kIsWeb ? Icons.close : Iconsax.close_square,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: kBorderRadius),
            child: Text(
              'Pick Image'.hardcoded,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          gapH12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!kIsWeb)
                InkWell(
                  onTap: onCameraClick,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30.0,
                        backgroundColor: AppColor.accentColor.withOpacity(0.1),
                        child: const Icon(
                          kIsWeb ? Icons.camera_alt : Iconsax.camera,
                          color: AppColor.accentColor,
                          size: 25.0,
                        ),
                      ),
                      gapH12,
                      Text(
                        'Open\nCamera'.hardcoded,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              InkWell(
                onTap: onGalleryClick,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30.0,
                      backgroundColor: AppColor.accentColor.withOpacity(0.1),
                      child: const Icon(
                        kIsWeb ? Icons.photo : Iconsax.gallery,
                        color: AppColor.accentColor,
                        size: 25.0,
                      ),
                    ),
                    gapH12,
                    Text(
                      'Open\nGallery'.hardcoded,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              if (showSku)
                InkWell(
                  onTap: onSkuGalleryClick,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30.0,
                        backgroundColor: AppColor.primaryColor.withOpacity(0.1),
                        child: const Icon(
                          kIsWeb ? Icons.photo : Iconsax.image,
                          color: AppColor.primaryColor,
                          size: 25.0,
                        ),
                      ),
                      gapH12,
                      Text(
                        'SKU\nGallery'.hardcoded,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
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
