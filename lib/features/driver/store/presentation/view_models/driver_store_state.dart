import 'package:flutter/foundation.dart';

abstract class DriverStoreState {}

class DriverStoreInitial extends DriverStoreState {}

class DriverStoreLoading extends DriverStoreState {}

class DriverStoreLoaded extends DriverStoreState {
  final List<dynamic> packages;

  DriverStoreLoaded({required this.packages});
}

class DriverStoreError extends DriverStoreState {
  final String message;

  DriverStoreError({required this.message});
}

class DriverStoreBuyLoading extends DriverStoreState {
  final int packageId;
  DriverStoreBuyLoading({required this.packageId});
}

class DriverStoreBuySuccess extends DriverStoreState {
  final String message;
  DriverStoreBuySuccess({required this.message});
}

class DriverStoreBuyError extends DriverStoreState {
  final String message;
  DriverStoreBuyError({required this.message});
}
