class WriteUsDataEntity {
  final String? email;
  final String? description;
  final String? message;
  final String? updatedAt;
  final String? createdAt;
  final int? id;

  const WriteUsDataEntity({
    this.email,
    this.description,
    this.message,
    this.updatedAt,
    this.createdAt,
    this.id,
  });
}

class WriteUsEntity {
  final bool? success;
  final String? message;
  final WriteUsDataEntity? data;

  const WriteUsEntity({
    this.success,
    this.message,
    this.data,
  });
}
