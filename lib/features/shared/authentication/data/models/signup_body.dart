import 'dart:convert';

class SignupBody {
  final String userName;
  final String email;
  final String phoneNumber;
  final String countryCode;
  final String referralCode;
  final String gender;

  SignupBody({
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.countryCode,
    required this.referralCode,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': userName,
      'email': email,
      'phone_number': phoneNumber,
      'country_code': countryCode,
      'referral_code': referralCode,
      'gender': gender,
    };
  }

  factory SignupBody.fromMap(Map<String, dynamic> map) {
    return SignupBody(
      userName: map['name'] as String,
      email: map['email'] as String,
      phoneNumber: map['phone_number'] as String,
      countryCode: map['country_code'] as String,
      referralCode: map['referral_code'] as String,
      gender: map['gender'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SignupBody.fromJson(String source) =>
      SignupBody.fromMap(json.decode(source) as Map<String, dynamic>);
}
