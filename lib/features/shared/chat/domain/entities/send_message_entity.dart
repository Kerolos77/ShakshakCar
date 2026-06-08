class SendMessageDataEntity {
  final String? email;
  final String? description;
  final String? updatedAt;
  final String? createdAt;
  final dynamic id;

  const SendMessageDataEntity({
    this.email,
    this.description,
    this.updatedAt,
    this.createdAt,
    this.id,
  });
}

class SendMessageEntity {
  final bool? success;
  final String? message;
  final SendMessageDataEntity? data;

  const SendMessageEntity({
    this.success,
    this.message,
    this.data,
  });
}
