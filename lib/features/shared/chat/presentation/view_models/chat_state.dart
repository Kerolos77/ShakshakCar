part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class SendMessageLoading extends ChatState {}

final class SendMessageSuccess extends ChatState {
  final SendMessageEntity sendMessageEntity;

  SendMessageSuccess({required this.sendMessageEntity});
}

final class SendMessageFailure extends ChatState {
  final String errorMessage;

  SendMessageFailure({required this.errorMessage});
}
