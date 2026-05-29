class StaticPagesEntity {
  final bool? success;
  final String? message;
  final StaticPagesDataEntity? data;

  const StaticPagesEntity({
    this.success,
    this.message,
    this.data,
  });
}

class StaticPagesDataEntity {
  final int? id;
  final String? slug;
  final String? name;
  final String? content;

  const StaticPagesDataEntity({
    this.id,
    this.slug,
    this.name,
    this.content,
  });
}
