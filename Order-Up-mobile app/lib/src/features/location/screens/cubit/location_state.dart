part of 'location_cubit.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationInitialState extends LocationState {}

class LocationLoadingState extends LocationState {}

class LocationLoadedState extends LocationState {
  const LocationLoadedState({required this.latitude, required this.longitude});

  final String latitude;
  final String longitude;
  @override
  List<Object> get props => [latitude, longitude];
}

class LocationFailedState extends LocationState {
  const LocationFailedState({required this.message});

  final String message;
  @override
  List<Object> get props => [message];
}
