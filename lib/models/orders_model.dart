// To parse this JSON data, do
//
//     final ordersModel = ordersModelFromJson(jsonString);

import 'dart:convert';

import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/models/user_model.dart';

OrdersModel ordersModelFromJson(String str) =>
    OrdersModel.fromJson(json.decode(str));

String ordersModelToJson(OrdersModel data) => json.encode(data.toJson());

class OrdersModel {
  OrdersModel({
    this.status,
    this.quantity,
    this.date,
    this.id,
    this.customerId,
    this.shippingId,
    this.shopId,
    this.subTotal,
    this.tax,
    this.shippingFee,
    this.itemId,
    this.productId,
    this.totalCost,
  });

  String? status;
  int? quantity;
  int? date;
  String? id;
  UserModel? customerId;
  ShippingId? shippingId;
  String? shopId;
  int? subTotal;
  int? tax;
  int? shippingFee;
  ItemId? itemId;
  String? productId;
  int? totalCost;

  factory OrdersModel.fromJson(Map<String, dynamic> json) {
    return OrdersModel(
      status: json["status"] == null ? null : json["status"],
      quantity: json["quantity"] == null ? null : json["quantity"],
      date: json["date"] == null ? null : json["date"],
      id: json["_id"] == null ? null : json["_id"],
      customerId: UserModel.fromJson(json["customerId"] ?? {}),
      shippingId: ShippingId.fromJson(json["shippingId"] ?? {}),
      shopId: json["shopId"] == null ? null : json["shopId"],
      subTotal: json["subTotal"] == null ? null : json["subTotal"],
      tax: json["tax"] == null ? null : json["tax"],
      shippingFee: json["shippingFee"] ?? null,
      itemId: ItemId.fromJson(json["itemId"] ?? {}),
      productId: json["productId"] ?? null,
      totalCost: json["totalCost"] == null ? null : json["totalCost"],
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "quantity": quantity == null ? null : quantity,
        "date": date == null ? null : date,
        "_id": id == null ? null : id,
        "customerId": customerId == null ? null : customerId,
        "shippingId": shippingId == null ? null : shippingId?.toJson(),
        "shopId": shopId == null ? null : shopId,
        "subTotal": subTotal == null ? null : subTotal,
        "tax": tax == null ? null : tax,
        "shippingFee": shippingFee == null ? null : shippingFee,
        "itemId": itemId == null ? null : itemId?.toJson(),
        "productId": productId == null ? null : productId,
        "totalCost": totalCost == null ? null : totalCost,
      };
}

class ItemId {
  ItemId({
    this.id,
    this.productId,
    this.quantity,
    this.orderId,
  });

  String? id;
  Product? productId;
  int? quantity;
  String? orderId;

  factory ItemId.fromJson(Map<String, dynamic> json) => ItemId(
        id: json["_id"] ?? null,
        productId: json["productId"] == null
            ? null
            : Product.fromJson(json["productId"]),
        quantity: json["quantity"] == null ? null : json["quantity"],
        orderId: json["orderId"] == null ? null : json["orderId"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "productId": productId == null ? null : productId?.toJson(),
        "quantity": quantity == null ? null : quantity,
        "orderId": orderId == null ? null : orderId,
      };
}

class ShippingId {
  ShippingId({
    this.addrress2,
    this.state,
    this.id,
    this.name,
    this.addrress1,
    this.city,
    this.phone,
    this.userId,
  });

  String? addrress2;
  String? state;
  String? id;
  String? name;
  String? addrress1;
  String? city;
  String? phone;
  String? userId;

  factory ShippingId.fromJson(Map<String, dynamic> json) => ShippingId(
        addrress2: json["addrress2"],
        state: json["state"],
        id: json["_id"],
        name: json["name"],
        addrress1: json["addrress1"],
        city: json["city"],
        phone: json["phone"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "addrress2": addrress2,
        "state": state ?? null,
        "_id": id,
        "name": name,
        "addrress1": addrress1,
        "city": city,
        "phone": phone,
        "userId": userId,
      };
}
