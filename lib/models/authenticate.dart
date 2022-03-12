import 'package:meta/meta.dart';
import 'dart:convert';

Authenticate loginFromJson(String str) =>
    Authenticate.fromJson(json.decode(str));

String loginToJson(Authenticate data) => json.encode(data.toJson());

class Authenticate {
  Authenticate({
    required this.email,
    required this.password,
    @required this.userName,
    @required this.firstName,
    @required this.lastName,
  });

  String email;
  String password;
  String? userName;
  String? lastName;
  String? firstName;

  factory Authenticate.fromJson(Map<String, dynamic> json) => Authenticate(
        email: json["email"],
        password: json["password"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        userName: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "userName": userName,
        "firstName": firstName,
        "lastName": lastName,
      };
}
