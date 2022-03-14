// To parse this JSON data, do
//
//     final shop = shopFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Shop shopFromJson(String str) => Shop.fromJson(json.decode(str));

String shopToJson(Shop data) => json.encode(data.toJson());

class Shop {
  Shop({
    required this.open,
    this.id,
    required this.name,
    required this.email,
    required this.location,
    required this.phoneNumber,
    this.image,
    required this.description,
  });

  bool open;
  String? id;
  String name;
  String email;
  String location;
  String phoneNumber;
  String? image;
  String description;

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        open: json["open"],
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        location: json["location"],
        phoneNumber: json["phoneNumber"],
        image: json["image"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "open": open,
        "_id": id,
        "name": name,
        "email": email,
        "location": location,
        "phoneNumber": phoneNumber,
        "image": image,
        "description": description,
      };
}
