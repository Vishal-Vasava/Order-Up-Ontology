import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PaddingWebWidget extends StatelessWidget {
  const PaddingWebWidget({
    super.key,
    this.padding,
    required this.child,
  });
  final double? padding;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: padding ?? MediaQuery.of(context).size.width * 0.2,
        ),
        child: child,
      );
    }
    return child;
  }
}
