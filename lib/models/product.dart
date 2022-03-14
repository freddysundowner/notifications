import 'dart:convert';

import 'package:fluttergistshop/utils/constants.dart';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  List<String> images;
  String? id;
  String name;
  int? price;
  int? quantity;
  int? discountPrice;
  String? shopId;
  String? ownerId;
  String? description;

  Product({
    required this.images,
    this.id,
    required this.name,
    this.price,
    this.discountPrice,
    this.quantity,
    this.shopId,
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
        discountPrice: json["discountPrice"],
        shopId: json["shopId"],
        ownerId: json["ownerId"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "images": List<String>.from(images.map((x) => x)),
        "_id": id,
        "name": name,
        "price": price,
        "quantity": quantity,
        "discountPrice": discountPrice,
        "shopId": shopId,
        "ownerId": ownerId,
        "description": description,
      };
}

List<Product> getProducts() {
  List<Product> product = [];

  Product productone = new Product(name: "title", images: [
    "https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/d5f168f9-f953-4419-ac7a-f0def128176e/renew-run-2-mens-road-running-shoe-8WSLZf.png"
  ]);
  productone.id = "1";
  productone.price = 1;
  productone.discountPrice = 1;
  productone.shopId = "62093827e3b4167368b575a7";
  productone.ownerId = "61fb9094d59efb5046a99946";
  productone.quantity = 3;

  productone.description = "this is the descrription";
  product.add(productone);

  Product producttwo = new Product(name: "test two", images: [
    "https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/d5f168f9-f953-4419-ac7a-f0def128176e/renew-run-2-mens-road-running-shoe-8WSLZf.png"
  ]);
  producttwo.id = "2";
  producttwo.discountPrice = 1;
  producttwo.price = 1;
  productone.shopId = "62093827e3b4167368b575a7";
  producttwo.quantity = 1;
  producttwo.description = "this is the descrription 2";
  producttwo.ownerId = "61fb9094d59efb5046a99946";
  product.add(producttwo);

  Product productthree = new Product(name: "test three", images: [
    "https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/d5f168f9-f953-4419-ac7a-f0def128176e/renew-run-2-mens-road-running-shoe-8WSLZf.png"
  ]);
  productthree.id = "3";
  productthree.discountPrice = 1;
  productthree.price = 1;
  productone.shopId = "62093827e3b4167368b575a7";
  productthree.quantity = 1;
  productthree.ownerId = "61fb9094d59efb5046a99946";

  productthree.description = "this is the descrription 3";
  product.add(productthree);

  return product;
}
