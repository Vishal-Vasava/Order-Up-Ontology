import 'package:hive_flutter/hive_flutter.dart';
import 'package:orderly_ecom/src/services/crashlytics/crash_service.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';

class LocationLocalRepository {
  final String _boxName = 'locationBox';
  static const _latitude = 'latitude';
  static const _longitude = 'longitude';

  static const _guestToken = 'guestToken';

  late Box<dynamic> locationBox;

  Future<void> init() async {
    try {
      locationBox = await Hive.openBox<dynamic>(_boxName);
    } catch (e, stk) {
      inject.get<CrashService>().logError(
            exception: e,
            errorMessage: 'Error in initializing Location Box',
            stack: stk,
          );
    }
  }

  String get latitude => locationBox.get(_latitude) ?? '';
  Future<String> setLatitude(String latitude) async {
    await locationBox.put(_latitude, latitude);
    return latitude;
  }

  /// [GUEST TOKEN]
  /// Because we never clear this box
  String get guestToken => locationBox.get(_guestToken) ?? '';
  Future<String> setGuestToken(String guestToken) async {
    await locationBox.put(_guestToken, guestToken);
    return guestToken;
  }

  String get longitude => locationBox.get(_longitude) ?? '';
  Future<String> setLongitude(String longitude) async {
    await locationBox.put(_longitude, longitude);
    return longitude;
  }
}
