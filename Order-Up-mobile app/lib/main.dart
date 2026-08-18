// ignore: depend_on_referenced_packages
import 'package:device_preview/device_preview.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta_seo/meta_seo.dart';
import 'package:orderly_ecom/src/bloc_observer.dart';
import 'package:orderly_ecom/src/constants/app_keys.dart';
import 'package:orderly_ecom/src/orderly_app.dart';
import 'package:orderly_ecom/src/services/crashlytics/crash_service.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      if (kIsWeb) {
        MetaSEO().seoMetaConfig();
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: AppKey.fbApiKey,
            appId: AppKey.fbAppId,
            messagingSenderId: AppKey.fbMsgSenderId,
            projectId: AppKey.fbProjectId,
          ),
        );
      } else {
        await Firebase.initializeApp();
      }

      await Hive.initFlutter();
      await setupInjection();

      Bloc.observer = AppBlocObserver();
      usePathUrlStrategy();
      runApp(
        DevicePreview(
          enabled: false,
          builder: (context) => const OrderlyApp(),
        ),
      );
    },
    (error, stack) {
      CrashService().logError(exception: error, errorMessage: error.toString());
    },
  );
  Function originalOnError = FlutterError.onError!;
  FlutterError.onError = (errorDetails) async {
    originalOnError(errorDetails);
    CrashService().logError(exception: 'Error', errorMessage: 'Uncaught error');
  };
}

// /// flutter build web --web-renderer html --release --no-tree-shake-icons
// /// flutter pub run build_runner build --delete-conflicting-outputs
// ///


//  Selecte time slot => Producer name items
// Inside Select Delivery time