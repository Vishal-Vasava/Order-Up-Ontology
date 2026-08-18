part of 'navigation_cubit.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

class NavigationInitialState extends NavigationState {
  const NavigationInitialState({
    required this.activeIndex,
    required this.deepLinkData,
  });

  final int activeIndex;
  final Map<String, dynamic> deepLinkData;
  NavigationInitialState copyWith({Map<String, dynamic>? deepLinkData}) {
    return NavigationInitialState(
      activeIndex: activeIndex,
      deepLinkData: deepLinkData ?? this.deepLinkData,
    );
  }
}

class NavigationChangeState extends NavigationState {}
