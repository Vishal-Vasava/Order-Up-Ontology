import 'dart:async';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:orderly_ecom/src/config/config.dart';
import 'package:orderly_ecom/src/features/location/data/location_local_repository.dart';
import 'package:orderly_ecom/src/features/location/data/location_repository.dart';
import 'package:orderly_ecom/src/services/crashlytics/crash_service.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit({required this.locationRepository})
      : super(LocationInitialState());
  final LocationRepository locationRepository;
  Future<void> requestLocationPermission() async {
    try {
      emit(LocationLoadingState());

      // Browser location permission may already be blocked and cannot always
      // be requested again from inside the Flutter canvas. Let web users pick
      // their service country and continue; native apps still require GPS.
      if (kIsWeb) {
        const latitude = '0.0';
        const longitude = '0.0';
        await inject.get<LocationLocalRepository>().setLatitude(latitude);
        await inject.get<LocationLocalRepository>().setLongitude(longitude);
        emit(const LocationLoadedState(
          latitude: latitude,
          longitude: longitude,
        ));
        return;
      }

      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(const LocationFailedState(message: 'openLocationSettings'));
        // await Geolocator.openLocationSettings();
        // Fluttertoast.showToast(msg: 'Location services are disabled.');
        return;
      }
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(const LocationFailedState(
            message: 'Please enable location to proceed.',
          ));
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        emit(const LocationFailedState(
          message: 'Location permissions are permanently denied.',
        ));
        await Geolocator.openAppSettings();
      }
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        final String latitude = position.latitude.toString();
        final String longitude = position.longitude.toString();
        if (!kIsWeb) {
          final data = await placemarkFromCoordinates(
              position.latitude, position.longitude);
          await bindApiUrl(countryCode: data.first.isoCountryCode!);
        }
        inject.get<LocationLocalRepository>().setLatitude(latitude);
        inject.get<LocationLocalRepository>().setLongitude(longitude);
        // await authCubit.authCheck();
        emit(LocationLoadedState(latitude: latitude, longitude: longitude));
      }
    } on TimeoutException {
      emit(const LocationFailedState(
          message: 'Timeout while fetching Location'));
      inject.get<CrashService>().logError(
          errorMessage: 'Timeout while fetching Location',
          exception: 'Timeout while fetching Location');
    } catch (e) {
      emit(LocationFailedState(message: e.toString()));
      inject
          .get<CrashService>()
          .logError(errorMessage: e.toString(), exception: e);
    }
    return;
  }

  Future<void> bindApiUrl({required String countryCode}) async {
    try {
      if (kIsWeb && Config.isDebug) {
        await locationRepository.authLocalRepository
            .setApiUrl('http://localhost:3001/');
        return;
      }
      await locationRepository.getApiUrl(countryCode: countryCode);
    } catch (e) {
      log(e.toString());
    }
  }
}
