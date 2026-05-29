import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/chat/domain/entities/send_message_entity.dart';
import 'package:shakshak/features/shared/chat/domain/repositories/chat_repo.dart';

class SendMessageUseCase
    extends BaseUseCase<SendMessageEntity, SendMessageParams> {
  final ChatRepo chatRepo;

  SendMessageUseCase(this.chatRepo);

  @override
  Future<Either<Failure, SendMessageEntity>> call(
      SendMessageParams parameters) async {
    return await chatRepo.sendMessage(
      tripId: parameters.tripId,
      message: parameters.message,
    );
  }
}

class SendMessageParams {
  final int tripId;
  final String message;

  const SendMessageParams({required this.tripId, required this.message});
}
