class SavedCardEntity {
  final int id;
  final String cardSubtype;
  final String maskedPan;
  final bool isDefault;
  final String expiryMonth;
  final String expiryYear;
  final String cardHolderName; // Add cardHolderName

  SavedCardEntity({
    required this.id,
    required this.cardSubtype,
    required this.maskedPan,
    required this.isDefault,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cardHolderName,
  });
}
