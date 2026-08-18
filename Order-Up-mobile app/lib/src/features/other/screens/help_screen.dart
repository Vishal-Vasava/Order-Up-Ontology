import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderlyAppBar(
        title: AppLocalizations.of(context)!.help,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: AppLocalizations.of(context)!.help_center_wip,
              style: Theme.of(context).textTheme.titleMedium,
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  await url_launcher.launchUrl(
                    Uri.parse('mailto://help@order-up.in'),
                  );
                },
              children: [
                TextSpan(
                  text: ' help@order-up.in',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      await url_launcher.launchUrl(
                        Uri.parse('mailto://help@order-up.in'),
                      );
                    },
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
