import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log('${bloc.runtimeType}', name: 'Bloc Created');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('Emit on ${bloc.runtimeType}', name: 'Bloc Change');
    log('CurrentState -- ${change.currentState}', name: 'Bloc Change');
    log('NextState -- ${change.nextState}', name: 'Bloc Change');
  }

  ///We can even react to transitions
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log('There was a transition from ${transition.currentState} to ${transition.nextState}',
        name: 'Bloc Transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log('Bloc -- ${bloc.runtimeType}, $error', name: 'Bloc Error');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log('-- ${bloc.runtimeType}', name: 'Bloc Destroyed');
  }
}
