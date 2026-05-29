import 'dart:convert';

class LoginBody {
  final String phone;

  LoginBody({
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phone': phone,
    };
  }

  factory LoginBody.fromMap(Map<String, dynamic> map) {
    return LoginBody(
      phone: map['phone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginBody.fromJson(String source) =>
      LoginBody.fromMap(json.decode(source) as Map<String, dynamic>);
}
