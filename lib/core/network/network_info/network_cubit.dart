import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  NetworkCubit() : super(NetworkInitial()) {
    _startMonitoring();
  }

  StreamSubscription<InternetStatus>? _subscription;

  void _startMonitoring() {
    _subscription = InternetConnection().onStatusChange.listen((status) {
      if (status == InternetStatus.connected) {
        emit(NetworkConnected());
      } else {
        emit(NetworkDisconnected());
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
