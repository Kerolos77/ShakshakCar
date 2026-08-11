import 'package:shakshak/features/shared/authentication/domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  const LoginModel({
    super.data,
    super.msg,
    super.status,
    super.statusval,
    super.otp,
  });

  factory LoginModel.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      return const LoginModel();
    }

    String? parsedData;
    String? parsedOtp;

    final rawData = json['data'];
    if (rawData != null) {
      if (rawData is Map) {
        parsedOtp = rawData['otp']?.toString();
        parsedData = parsedOtp ?? rawData.toString();
      } else {
        parsedData = rawData.toString();
        parsedOtp = rawData.toString();
      }
    }

    return LoginModel(
      data: parsedData,
      otp: parsedOtp,
      msg: json['msg']?.toString(),
      status: int.tryParse(json['status']?.toString() ?? ''),
      statusval: json['statusval'] == true || json['statusval'] == 'true',
    );
  }
}
