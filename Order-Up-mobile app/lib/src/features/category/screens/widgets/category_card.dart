import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/category/domain/category.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:shimmer/shimmer.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.modelData,
    required this.onTap,
  });
  final Category modelData;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: kBorderRadius,
        horizontal: kBorderRadius,
      ),
      decoration: BoxDecoration(
        color: AppColor.primaryColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
          BoxShadow(
            color: AppColor.scaleGreyColor,
            spreadRadius: 2,
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: CachedNetworkImage(
              imageUrl: modelData.bannerUrl!,
              memCacheHeight: 200,
              imageBuilder: (context, imageProvider) {
                return Container(
                  height: isDesktop(context)
                      ? MediaQuery.of(context).size.height * 0.45
                      : MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.zero,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
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
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.zero,
                      color: Colors.white,
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
                    height: 180,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.zero,
                    ),
                    child: const Icon(Icons.error),
                  ),
                );
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 15.0, top: 20.0),
          //   child: Stack(
          //     alignment: Alignment.bottomCenter,
          //     fit: StackFit.loose,
          //     children: [

          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  modelData.name!,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(
                  height: 5.0,
                ),
                // ReadMoreText(
                //   modelData.name!,
                //   style: Theme.of(context).textTheme.bodySmall,
                //   trimLines: 4,
                //   trimMode: TrimMode.Line,
                //   trimCollapsedText: AppLocalizations.of(context)!.more,
                //   trimExpandedText: AppLocalizations.of(context)!.view_less,
                // ),
              ],
            ),
          ),
          if (onTap != null)
            Positioned(
              bottom: 15.0,
              left: 15,
              child: CupertinoButton(
                color: AppColor.primaryColor.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(
                  horizontal: kBorderRadius,
                ),
                minSize: 35.0,
                onPressed: onTap,
                child: Text(
                  AppLocalizations.of(context)!.view_all,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
