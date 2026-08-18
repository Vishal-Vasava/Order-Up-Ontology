import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';

class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // If our width is more than 900 then we consider it a desktop
    if (size.width >= webBreapoint) {
      return desktop;
    }
    // If width it less then 900 and more then 600 we consider it as tablet
    else if (size.width >= tabletBreakpoint && tablet != null) {
      return tablet!;
    }
    // Or less then that we called it mobile
    else {
      return mobile;
    }
  }
}
