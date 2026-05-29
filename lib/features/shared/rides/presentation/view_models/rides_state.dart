part of 'rides_cubit.dart';

@immutable
sealed class RidesState {}

final class RidesInitial extends RidesState {}

final class RidesLoading extends RidesState {}

final class RidesSuccess extends RidesState {
  final RidesEntity ridesEntity;

  RidesSuccess({required this.ridesEntity});
}

final class RidesFailure extends RidesState {
  final String errorMessage;

  RidesFailure({required this.errorMessage});
}
