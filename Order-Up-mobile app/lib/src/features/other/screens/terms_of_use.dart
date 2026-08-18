import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:url_launcher/url_launcher.dart';

class TermsOfUseScreen extends StatefulWidget {
  const TermsOfUseScreen({super.key});

  @override
  _TermsOfUseScreenState createState() => _TermsOfUseScreenState();
}

class _TermsOfUseScreenState extends State<TermsOfUseScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  String loadUrl = '';

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        WebView.platform = SurfaceAndroidWebView();
      }
      // webViewController = WebViewController()
      //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
      //   ..setBackgroundColor(const Color(0x00000000))
      //   ..setNavigationDelegate(
      //     NavigationDelegate(
      //       onProgress: (int progress) {
      //         // Update loading bar.
      //       },
      //       onPageStarted: (String url) {},
      //       onPageFinished: (String url) {},
      //       onWebResourceError: (WebResourceError error) {},
      //       onNavigationRequest: (NavigationRequest request) {
      //         if (request.url.startsWith('https://www.youtube.com/')) {
      //           return NavigationDecision.prevent;
      //         }
      //         return NavigationDecision.navigate;
      //       },
      //     ),
      //   )
      //   ..loadRequest(Uri.parse(loadUrl));
    }
  }

  Future<String> callPrivacyApi() async {
    try {
      final response =
          await inject.get<NetworkAdapter>().get(Endpoints.termsCondition);
      if (response.statusCode == 200) {
        if (response.data['statusCode'] == 200) {
          return response.data['data']['url'];
        } else {
          return '';
        }
      } else {
        return '';
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderlyAppBar(
        title: AppLocalizations.of(context)!.terms_of_use,
      ),
      body: FutureBuilder<String>(
        future: callPrivacyApi(),
        builder: (c, s) {
          if (s.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (s.hasError) {
            return const Text(
              'Something went wrong',
            );
          }
          if (s.hasData) {
            if (kIsWeb) {
              url_launcher.launchUrl(
                Uri.parse(s.data!),
                mode: LaunchMode.inAppWebView,
              );
              return const Center();
            }
            return WebView(
              initialUrl: s.data!,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onProgress: (int progress) {
                log('WebView is loading (progress : $progress%)');
              },
              javascriptChannels: const <JavascriptChannel>{},
              gestureNavigationEnabled: true,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
