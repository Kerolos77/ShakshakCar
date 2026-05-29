class PaymobCardTokenResult {
  final String transactionId;
  final String cardToken;
  final String last4;
  final String cardType;

  PaymobCardTokenResult({
    required this.transactionId,
    required this.cardToken,
    required this.last4,
    required this.cardType,
  });

  factory PaymobCardTokenResult.fromJson(Map<String, dynamic> json) {
    return PaymobCardTokenResult(
      transactionId: json['id'].toString(),
      cardToken: json['token'],
      last4: json['source_data']['pan'] ?? '',
      cardType: json['source_data']['sub_type'] ?? '',
    );
  }
}
