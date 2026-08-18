import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/config/config.dart';
import 'package:orderly_ecom/src/constants/app_assets.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/theme/colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.backgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Image(
                  image: AssetImage(AppAssets.appLogo),
                  width: 300,
                  height: 300,
                ),
                gapH12,
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    backgroundColor: AppColor.accentColor,
                  ),
                ),
              ],
            ),
          ),
          if (!kIsWeb)
            Positioned(
              bottom: 15.0,
              child: Text(
                Config.appVersion,
                // '${AppLocalizations.of(context)!.version} ${Config.appVersion}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
        ],
      ),
    );
  }
}
