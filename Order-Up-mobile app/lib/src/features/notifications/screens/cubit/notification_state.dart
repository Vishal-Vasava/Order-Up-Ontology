part of 'notification_cubit.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitialState extends NotificationState {}

class NotificationLoadingState extends NotificationState {}

class NotificationLoadedState extends NotificationState {
  const NotificationLoadedState({required this.notificationList});

  final List<NotificationModel> notificationList;
}

class NotificationDeleteState extends NotificationState {}

class NotificationFailedState extends NotificationState {
  const NotificationFailedState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}
