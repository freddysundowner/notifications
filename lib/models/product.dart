import 'dart:convert';

import 'package:fluttergistshop/models/shop.dart';
import 'package:fluttergistshop/models/user_model.dart';
import 'package:fluttergistshop/utils/constants.dart';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  List<String>? images;
  List<String>? variations;
  String? id;
  String? name;
  int? price;
  int? quantity;
  int? discountPrice;
  Shop? shopId;
  UserModel? ownerId;
  String? description;
  bool? available;
  bool? deleted;

  Product({
    this.images = const [],
    this.id,
    this.name,
    this.price,
    this.discountPrice,
    this.quantity,
    this.shopId,
    this.variations,
    this.ownerId,
    this.description,
    this.deleted,
    this.available,
  });

  htmlPrice(price) {
    return currencySymbol + this.price.toString();
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        images: List<String>.from(json["images"] ?? [].map((x) => x)),
        id: json["_id"],
        name: json["name"] ?? "",
        deleted: json["deleted"] ?? false,
        price: json["price"],
        quantity: json["quantity"],
        variations: json["variations"] == null
            ? []
            : List<String>.from(json["variations"].map((x) => x)),
        shopId: json["shopId"].toString().length > 40
            ? Shop.fromJson(json["shopId"])
            : Shop.fromJson(json["ownerId"]["shopId"] ?? {}),
        ownerId: UserModel.fromJson(json["ownerId"] ?? {}),
        description: json["description"],
        available: json["available"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "quantity": quantity,
        "variations": variations,
        "shopId": shopId?.toJson(),
        "ownerId": ownerId?.toJson(),
        "description": description,
      };
}

List<Product> getProducts() {
  List<Product> product = [];

  return product;
}
