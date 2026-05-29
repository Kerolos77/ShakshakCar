class FaqEntity {
  final int? id;
  final String? title;
  final String? description;
  final String? createdAt;

  const FaqEntity({
    this.id,
    this.title,
    this.description,
    this.createdAt,
  });
}

class FaqsEntity {
  final bool? success;
  final List<FaqEntity>? data;
  final String? message;

  const FaqsEntity({
    this.success,
    this.data,
    this.message,
  });
}
