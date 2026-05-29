import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (kDebugMode) {
      print(
          '\x1B[37mSEXonEvent 🚀 {${bloc.runtimeType}}  Event: ${event.runtimeType}\x1B[0m');
    }
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (kDebugMode) {
      print(
          '\x1B[37mSEXonCREATE 🚀 {${bloc.runtimeType} ===> HashCode : ${bloc.hashCode}}\x1B[0m');
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      print(
          '\x1B[33mSEXOnChange ♻ {${bloc.runtimeType}}\n\x1B[33m${change.currentState.runtimeType}  ➡  ${change.nextState.runtimeType}\x1B[0m');
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (kDebugMode) {
      print(
          '\x1B[37mSEXOnTransition bloc: {${bloc.runtimeType}}  Transition: ${transition.currentState.runtimeType}  ➡  ${transition.nextState.runtimeType}\x1B[0m');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      print('\x1B[31SEXmOnError ⛔ {${bloc.runtimeType}}, $error\x1B[0m');
    }
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if (kDebugMode) {
      print(
          '\x1B[31mSEXOnClose  ✖ {${bloc.runtimeType}  ===> HashCode : ${bloc.hashCode}}\x1B[0m');
    }
  }
}
