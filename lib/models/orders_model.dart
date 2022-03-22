// To parse this JSON data, do
//
//     final ordersModel = ordersModelFromJson(jsonString);

import 'dart:convert';

OrdersModel ordersModelFromJson(String str) => OrdersModel.fromJson(json.decode(str));

String ordersModelToJson(OrdersModel data) => json.encode(data.toJson());

class OrdersModel {
  OrdersModel({
    this.status,
    this.id,
    this.customerId,
    this.shippingId,
    this.shopId,
    this.subTotal,
    this.tax,
    this.shippingFee,
    this.itemId,
    this.totalCost
  });

  String? status;
  String? id;
  CustomerId? customerId;
  String? shippingId;
  String? shopId;
  int? subTotal;
  int? tax;
  int? shippingFee;
  String? itemId;
  int? totalCost;

  factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
    status: json["status"] == null ? null : json["status"],
    id: json["_id"] == null ? null : json["_id"],
    customerId: CustomerId.fromJson(json["customerId"] ?? {}),
    shippingId: json["shippingId"] == null ? null : json["shippingId"],
    shopId: json["shopId"] == null ? null : json["shopId"],
    subTotal: json["subTotal"] == null ? null : json["subTotal"],
    tax: json["tax"] == null ? null : json["tax"],
    shippingFee: json["shippingFee"] == null ? null : json["shippingFee"],
    itemId: json["itemId"] == null ? null : json["itemId"],
    totalCost: json["totalCost"] == null ? null : json["totalCost"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "_id": id == null ? null : id,
    "customerId": customerId == null ? null : customerId?.toJson(),
    "shippingId": shippingId == null ? null : shippingId,
    "shopId": shopId == null ? null : shopId,
    "subTotal": subTotal == null ? null : subTotal,
    "tax": tax == null ? null : tax,
    "shippingFee": shippingFee == null ? null : shippingFee,
    "itemId": itemId == null ? null : itemId,
    "totalCost": totalCost == null ? null : totalCost,
  };
}

class CustomerId {
  CustomerId({
    this.bio,
    this.id,
    this.firstName,
    this.lastName,
    this.userName,
    this.email,
  });

  String? bio;
  String? id;
  String? firstName;
  String? lastName;
  String? userName;
  String? email;

  factory CustomerId.fromJson(Map<String, dynamic> json) => CustomerId(
    bio: json["bio"] == null ? null : json["bio"],
    id: json["_id"] == null ? null : json["_id"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    userName: json["userName"] == null ? null : json["userName"],
    email: json["email"] == null ? null : json["email"],
  );

  Map<String, dynamic> toJson() => {
    "bio": bio == null ? null : bio,
    "_id": id == null ? null : id,
    "firstName": firstName == null ? null : firstName,
    "lastName": lastName == null ? null : lastName,
    "userName": userName == null ? null : userName,
    "email": email == null ? null : email,
  };
}
