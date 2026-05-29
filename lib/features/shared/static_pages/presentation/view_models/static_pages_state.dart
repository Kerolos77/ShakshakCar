part of 'static_pages_cubit.dart';

@immutable
sealed class StaticPagesState {}

final class StaticPagesInitial extends StaticPagesState {}

final class StaticPagesLoading extends StaticPagesState {}

final class StaticPagesSuccess extends StaticPagesState {
  final StaticPagesEntity staticPagesModel;

  StaticPagesSuccess({required this.staticPagesModel});
}

final class StaticPagesFailure extends StaticPagesState {
  final String errorMessage;

  StaticPagesFailure({required this.errorMessage});
}
