import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/theme/colors.dart';

class OrderlyAppBar extends PreferredSize {
  OrderlyAppBar({
    super.key,
    required this.title,
    this.leadingWidget,
    this.showWidgetOnTitle = false,
    this.titleWidget,
    this.toolbarHeight = 70.0,
    this.action,
    this.centerTitle,
    this.backgroundColor = AppColor.whiteColor,
    this.elevation = 6.0,
    this.bottomWidget,
    this.showBackButton = true,
  })  : assert(showWidgetOnTitle ? titleWidget != null : true),
        super(
          preferredSize: Size.fromHeight(toolbarHeight),
          child: const Center(),
        );
  final double toolbarHeight;
  final String title;
  final Widget? titleWidget;
  final bool showBackButton;

  /// WHEN THIS IS SET TO `true` YOU MUST PROVIDE `titleWidget`
  /// OR IT WILL THROW AN ERROR.
  final bool showWidgetOnTitle;
  final List<Widget>? action;
  final bool? centerTitle;
  final Color? backgroundColor;
  final double? elevation;
  final Widget? leadingWidget;
  final PreferredSize? bottomWidget;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: toolbarHeight,
      backgroundColor: backgroundColor,
      shadowColor: AppColor.whiteColor50,
      centerTitle: centerTitle ??
          (kIsWeb
              ? false
              : Platform.isIOS
                  ? true
                  : false),
      elevation: elevation,
      leading: showBackButton
          ? leadingWidget ??
              InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  if (context.canPop()) {
                    context.pop();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 12, right: 6.0),
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 5),
                        color: AppColor.kShadowColor,
                      ),
                    ],
                  ),
                  child: const Icon(
                    kIsWeb
                        ? Icons.arrow_circle_left_outlined
                        : Iconsax.arrow_left,
                    size: 20.0,
                  ),
                ),
              )
          : null,
      title: showWidgetOnTitle
          ? titleWidget
          : Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
      actions: action,
      automaticallyImplyLeading: false,
      bottom: bottomWidget,
    );
  }
}
