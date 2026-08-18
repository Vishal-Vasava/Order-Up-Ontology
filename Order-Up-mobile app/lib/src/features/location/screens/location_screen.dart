import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:orderly_ecom/src/constants/app_assets.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/constants/static_text.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/authentication/screens/cubit/auth_cubit.dart';
import 'package:orderly_ecom/src/features/location/data/location_repository.dart';
import 'package:orderly_ecom/src/features/location/screens/country_picker_dialog.dart';
import 'package:orderly_ecom/src/features/location/screens/cubit/location_cubit.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/widgets/app_dialog.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => LocationRepository(
        networkAdapter: inject.get<NetworkAdapter>(),
        authLocalRepository: inject.get<AuthLocalRepository>(),
      ),
      child: BlocProvider(
        create: (context) => LocationCubit(
          locationRepository: context.read<LocationRepository>(),
        ),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            toolbarHeight: 3.0,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(
                      AppAssets.appLogo,
                    ),
                    height: 150.0,
                  ),
                  Image(
                    image: AssetImage(
                      AppAssets.locationImage,
                    ),
                    height: MediaQuery.of(context).size.height / 3,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'GPS Permission',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${StaticText.appName} need access to your device location.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocConsumer<LocationCubit, LocationState>(
                        listener: (context, state) async {
                          if (state is LocationLoadedState) {
                            if (kIsWeb) {
                              AppDialog.viewDialog(
                                context: context,
                                content: BlocProvider.value(
                                  value: context.read<LocationCubit>(),
                                  child: const CountryPickerDialog(),
                                ),
                              );
                            } else {
                              await context.read<AuthCubit>().authCheck();
                            }
                          }
                        },
                        builder: (context, state) {
                          if (state is LocationFailedState) {
                            if (state.message == 'openLocationSettings') {
                              Geolocator.openLocationSettings();
                            }
                          }
                          return CupertinoButton(
                            onPressed: state is LocationLoadingState
                                ? null
                                : () async {
                                    HapticFeedback.lightImpact();
                                    await context
                                        .read<LocationCubit>()
                                        .requestLocationPermission();
                                  },
                            color: AppColor.primaryColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  kIsWeb
                                      ? 'Continue in Browser'
                                      : 'Allow GPS Permission',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                if (state is LocationLoadingState)
                                  const Center(
                                    child: SizedBox(
                                      height: 25.0,
                                      width: 25.0,
                                      child: CircularProgressIndicator(
                                        color: AppColor.accentColor,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  BlocBuilder<LocationCubit, LocationState>(
                    builder: (context, state) {
                      if (state is LocationFailedState) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  gapH48,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
