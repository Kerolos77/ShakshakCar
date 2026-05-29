part of 'contact_us_cubit.dart';

@immutable
sealed class ContactUsState {}

final class ContactUsInitial extends ContactUsState {}

final class ContactUsLoading extends ContactUsState {}

final class ContactUsSuccess extends ContactUsState {
  final ContactUsEntity contactUsEntity;

  ContactUsSuccess({required this.contactUsEntity});
}

final class ContactUsFailure extends ContactUsState {
  final String errorMessage;

  ContactUsFailure({required this.errorMessage});
}

final class WriteUsLoading extends ContactUsState {}

final class WriteUsSuccess extends ContactUsState {
  final WriteUsEntity writeUsEntity;

  WriteUsSuccess({required this.writeUsEntity});
}

final class WriteUsFailure extends ContactUsState {
  final String errorMessage;

  WriteUsFailure({required this.errorMessage});
}
