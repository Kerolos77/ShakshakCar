import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/shared/chat/domain/entities/send_message_entity.dart';

abstract class ChatRepo {
  Future<Either<Failure, SendMessageEntity>> sendMessage({
    required int tripId,
    required String message,
  });
}
