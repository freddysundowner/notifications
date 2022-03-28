import 'dart:convert';

import 'package:meta/meta.dart';

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
    @required this.bio,
  });

  String email;
  String password;
  String? userName;
  String? lastName;
  String? firstName;
  String? bio;

  factory Authenticate.fromJson(Map<String, dynamic> json) => Authenticate(
        email: json["email"],
        password: json["password"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        userName: json["username"],
        bio: json["bio"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "userName": userName ?? "",
        "firstName": firstName ?? "",
        "lastName": lastName ?? "",
        "bio": bio ?? ""
      };
}
