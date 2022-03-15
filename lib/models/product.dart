import 'dart:convert';

import 'package:fluttergistshop/utils/constants.dart';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  List<String> images;
  List<String> variations;
  String? id;
  String name;
  int price;
  int quantity;
  int? discountPrice;
  String? shopId;
  String? ownerId;
  String? description;

  Product({
    this.images = const [],
    this.id,
    required this.name,
    required this.price,
    this.discountPrice,
    required this.quantity,
    this.shopId,
    required this.variations,
    this.ownerId,
    this.description,
  });

  htmlPrice(price) {
    return currencySymbol + this.price.toString();
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        images: List<String>.from(json["images"].map((x) => x)),
        id: json["_id"],
        name: json["name"],
        price: json["price"],
        quantity: json["quantity"],
        variations: json["variations"] == null
            ? []
            : List<String>.from(json["variations"].map((x) => x)),
        shopId: json["shopId"],
        ownerId: json["ownerId"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        // "images": List<String>.from(images.map((x) => x)),
        "name": name,
        "price": price,
        "quantity": quantity,
        "variations": variations,
        "shopId": shopId,
        "ownerId": ownerId,
        "description": description,
      };
}

List<Product> getProducts() {
  List<Product> product = [];

  return product;
}
