import 'package:dio/dio.dart';

import 'paymob_card_token_result.dart';

class PaymobPaymentService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://accept.paymob.com/api',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // ================== CONFIG ==================
  static const String _apiKey =
      'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2T1RZNU9EUTFMQ0p1WVcxbElqb2lhVzVwZEdsaGJDSjkuMll5a1lLb2JGaEdkWU1TNERtS3JBb1NSOS1oenNYc1dadm1LajhTRlBrN0plQW1lNTFqOGRpM1ctWUNhVURHNEFNam1qdGdfY3RsbEhxcllMYUNtU1E=';

  static const int _integrationId = 4553227;
  static const String _currency = 'EGP';

  // ============================================

  // ================== DEBUG HELPER ==================
  void _log(String title, dynamic data) {
    // ignore: avoid_print
    print('🟢 PAYMOB DEBUG | $title');
    // ignore: avoid_print
    print(data);
    // ignore: avoid_print
    print('----------------------------------------');
  }

  // =================================================

  // ================== BILLING DATA ==================
  Map<String, dynamic> _billingData() {
    return {
      "apartment": "803",
      "email": "test@example.com",
      "floor": "42",
      "first_name": "Test",
      "street": "Example Street",
      "building": "8028",
      "phone_number": "+201234567890",
      "shipping_method": "PKG",
      "postal_code": "01898",
      "city": "Cairo",
      "country": "EG",
      "last_name": "User",
      "state": "Cairo"
    };
  }

  // =================================================

  /// 1️⃣ AUTH TOKEN
  Future<String> _getAuthToken() async {
    try {
      final response = await _dio.post(
        '/auth/tokens',
        data: {
          "api_key": _apiKey,
        },
      );

      _log('AUTH RESPONSE', response.data);
      return response.data['token'];
    } catch (e) {
      _log('AUTH ERROR', e.toString());
      rethrow;
    }
  }

  /// 2️⃣ CREATE DUMMY ORDER (مطلوب إجباري)
  Future<String> _createDummyOrder({
    required int amountCents,
  }) async {
    try {
      final authToken = await _getAuthToken();

      final body = {
        "amount_cents": amountCents,
        "currency": _currency,
        "items": [],
      };

      _log('CREATE ORDER REQUEST', body);

      final response = await _dio.post(
        '/ecommerce/orders',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
        data: body,
      );

      _log('CREATE ORDER RESPONSE', response.data);
      return response.data['id'].toString();
    } catch (e) {
      _log('CREATE ORDER ERROR', e.toString());
      rethrow;
    }
  }

  /// 3️⃣ CREATE PAYMENT KEY
  Future<String> _createPaymentKey({
    required int amountCents,
  }) async {
    try {
      final authToken = await _getAuthToken();
      final orderId = await _createDummyOrder(amountCents: amountCents);

      final body = {
        "amount_cents": amountCents,
        "expiration": 3600,
        "order_id": orderId,
        "currency": _currency,
        "integration_id": _integrationId,
        "billing_data": _billingData(),
        "lock_order_when_paid": false,
      };

      _log('PAYMENT KEY REQUEST', body);

      final response = await _dio.post(
        '/acceptance/payment_keys',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
        data: body,
      );

      _log('PAYMENT KEY RESPONSE', response.data);
      return response.data['token'];
    } catch (e) {
      _log('PAYMENT KEY ERROR', e.toString());
      rethrow;
    }
  }

  /// 4️⃣ TOKENIZE CARD (SAVE CARD)
  Future<PaymobCardTokenResult> tokenizeCard({
    required String cardNumber,
    required String expMonth,
    required String expYear,
    required String cvv,
    required String holderName,
  }) async {
    try {
      // Dummy amount = 1 جنيه
      final paymentKey = await _createPaymentKey(amountCents: 100);

      final body = {
        "source": {
          "identifier": "CARD",
          "subtype": "CARD",
        },
        "payment_token": paymentKey,
        "card": {
          "number": cardNumber,
          "exp_month": expMonth,
          "exp_year": expYear,
          "cvv": cvv,
          "card_holdername": holderName,
        },
        "save_card": true,
        "integration_id": _integrationId
      };

      _log('TOKENIZE CARD REQUEST', body);

      final response = await _dio.post(
        '/acceptance/payments/pay',
        data: body,
      );

      _log('TOKENIZE CARD RESPONSE', response.data);

      return PaymobCardTokenResult.fromJson(response.data);
    } on DioException catch (e) {
      _log('TOKENIZE CARD DIO ERROR', e.response?.data);
      rethrow;
    }
  }
}
