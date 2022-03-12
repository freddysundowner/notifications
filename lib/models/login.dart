import 'package:meta/meta.dart';
import 'dart:convert';

Authenticate loginFromJson(String str) =>
    Authenticate.fromJson(json.decode(str));

String loginToJson(Authenticate data) => json.encode(data.toJson());

class Authenticate {
  Authenticate({
    required this.email,
    required this.password,
  });

  String email;
  String password;

  factory Authenticate.fromJson(Map<String, dynamic> json) => Authenticate(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
