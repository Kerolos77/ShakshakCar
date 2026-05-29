class CardEntity {
  final String? id;
  final String? cardNumber;
  final String? holderName;
  final String? expiryDate;
  final String? cvv;
  final String? type;
  final String? token;

  const CardEntity({
    this.id,
    this.cardNumber,
    this.holderName,
    this.expiryDate,
    this.cvv,
    this.type,
    this.token,
  });
}
