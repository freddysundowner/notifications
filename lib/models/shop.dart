// To parse this JSON data, do
//
//     final shop = shopFromJson(jsonString);

import 'dart:convert';

Shop shopFromJson(String str) => Shop.fromJson(json.decode(str));

String shopToJson(Shop data) => json.encode(data.toJson());

class Shop {
  Shop({
    this.open,
    this.id,
    this.name,
    this.email,
    this.location,
    this.phoneNumber,
    this.image,
    this.description,
  });

  bool? open;
  String? id;
  String? name;
  String? email;
  String? location;
  String? phoneNumber;
  String? image;
  String? description;

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        open: json["open"] ?? true,
        id: json["_id"] ?? "",
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        location: json["location"] ?? "",
        phoneNumber: json["phoneNumber"] ?? "",
        image: json["image"] ?? "",
        description: json["description"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "location": location,
        "phoneNumber": phoneNumber,
        "image": image ?? "",
        "description": description,
      };
}
