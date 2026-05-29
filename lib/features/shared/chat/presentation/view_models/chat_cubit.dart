import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:shakshak/features/shared/chat/domain/usecases/send_message_usecase.dart';
import 'package:shakshak/features/shared/chat/domain/entities/send_message_entity.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this.sendMessageUseCase) : super(ChatInitial());

  final SendMessageUseCase sendMessageUseCase;

  Future<void> sendMessage({
    required int tripId,
    required String message,
  }) async {
    emit(SendMessageLoading());
    var result = await sendMessageUseCase(
        SendMessageParams(tripId: tripId, message: message));
    result.fold((error) {
      debugPrint("error while send message ${error.message}");
      return emit(SendMessageFailure(errorMessage: error.message));
    }, (success) {
      return emit(SendMessageSuccess(sendMessageEntity: success));
    });
  }
}
