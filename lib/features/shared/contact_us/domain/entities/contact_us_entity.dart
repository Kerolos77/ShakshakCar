class ContactUsDataEntity {
  final dynamic phone;
  final dynamic email1;

  const ContactUsDataEntity({
    this.phone,
    this.email1,
  });
}

class ContactUsEntity {
  final bool? success;
  final ContactUsDataEntity? data;
  final String? message;

  const ContactUsEntity({
    this.success,
    this.data,
    this.message,
  });
}
