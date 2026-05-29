part of 'faqs_cubit.dart';

@immutable
sealed class FaqsState {}

final class FaqsInitial extends FaqsState {}

final class FaqsLoading extends FaqsState {}

final class FaqsSuccess extends FaqsState {
  final FaqsEntity faqsEntity;

  FaqsSuccess({required this.faqsEntity});
}

final class FaqsFailure extends FaqsState {
  final String errorMessage;

  FaqsFailure({required this.errorMessage});
}
