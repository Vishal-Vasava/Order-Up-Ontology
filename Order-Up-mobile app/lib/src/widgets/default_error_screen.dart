import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/constants/app_assets.dart';

class DefaultErrorScreen extends StatelessWidget {
  const DefaultErrorScreen({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.emptyStateImage,
              width: 220.0,
              height: 180.0,
              fit: BoxFit.contain,
            ),
            Text(
              message,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
