import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/location/data/location_local_repository.dart';
import 'package:orderly_ecom/src/features/notifications/data/notification_service.dart';
import 'package:orderly_ecom/src/services/crashlytics/crash_service.dart';
import 'package:orderly_ecom/src/services/network/dio_client.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';

final GetIt inject = GetIt.instance;

Future<void> setupInjection() async {
  inject.registerSingleton<CrashService>(CrashService());

  inject.registerSingletonAsync<LocationLocalRepository>(() async {
    final obj = LocationLocalRepository();
    await obj.init();
    return obj;
  });

  inject.registerSingletonAsync<AuthLocalRepository>(() async {
    final obj = AuthLocalRepository();
    await obj.init();
    return obj;
  });

  inject.registerSingletonAsync<NotificationService>(() async {
    final obj = NotificationService();
    await obj.init();
    return obj;
  });

  /// THIS WILL MAKE SURE THAT DI IS INITIALIZED BEFORE
  /// WE START USING ANY OF ABOVE INSTANCE.
  await inject.allReady();

  inject.registerSingleton<NetworkAdapter>(DioClient());

  inject.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
}


/// MAKE EXTENSION FOR EASY ACCESSING THESE DATA