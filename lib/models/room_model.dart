// To parse this JSON data, do
//
//     final roomModel = roomModelFromJson(jsonString);

import 'dart:convert';

import 'package:fluttergistshop/models/product.dart';

RoomModel roomModelFromJson(String str) => RoomModel.fromJson(json.decode(str));

String roomModelToJson(RoomModel data) => json.encode(data.toJson());

class RoomModel {
  RoomModel({
    this.productIds,
    this.hostIds,
    this.userIds,
    this.raisedHands,
    this.speakerIds,
    this.invitedIds,
    this.status,
    this.productImages,
    this.id,
    this.ownerId,
    this.title,
    this.shopId,
    this.productPrice,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.token,
  });

  List<Product>? productIds;
  List<OwnerId>? hostIds = [];
  List<OwnerId>? userIds;
  List<OwnerId>? raisedHands;
  List<dynamic>? speakerIds;
  List<dynamic>? invitedIds;
  bool? status;
  List<dynamic>? productImages;
  String? id;
  OwnerId? ownerId;
  String? title;
  ShopId? shopId;
  int? productPrice;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  dynamic? token;

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
    productIds: json["productIds"] == null ? null : List<Product>.from(json["productIds"].map((x) => Product.fromJson(x))),
    hostIds: json["hostIds"] == null ? null : List<OwnerId>.from(json["hostIds"].map((x) => OwnerId.fromJson(x))),
    userIds: json["userIds"] == null ? null : List<OwnerId>.from(json["userIds"].map((x) => OwnerId.fromJson(x))),
    raisedHands: json["raisedHands"] == null ? null : List<OwnerId>.from(json["raisedHands"].map((x) => OwnerId.fromJson(x))),
    speakerIds: json["speakerIds"] == null ? null : List<dynamic>.from(json["speakerIds"].map((x) => x)),
    invitedIds: json["invitedIds"] == null ? null : List<dynamic>.from(json["invitedIds"].map((x) => x)),
    status: json["status"] == null ? null : json["status"],
    productImages: json["productImages"] == null ? null : List<dynamic>.from(json["productImages"].map((x) => x)),
    id: json["_id"] == null ? null : json["_id"],
    ownerId: json["ownerId"] == null ? null : OwnerId.fromJson(json["ownerId"]),
    title: json["title"] ?? " ",
    shopId: json["shopId"] == null ? null : ShopId.fromJson(json["shopId"]),
    productPrice: json["productPrice"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "productIds": productIds == [] ? null : List<dynamic>.from(productIds!.map((x) => x.toJson())),
    "hostIds": hostIds == null ? [] : List<dynamic>.from(hostIds!.map((x) => x.toJson())),
    "userIds": userIds == null ? [] : List<dynamic>.from(userIds!.map((x) => x.toJson())),
    "raisedHands": raisedHands == [] ? null : List<dynamic>.from(raisedHands!.map((x) => x.toJson())),
    "speakerIds": speakerIds == [] ? null : List<dynamic>.from(speakerIds!.map((x) => x)),
    "invitedIds": invitedIds == [] ? null : List<dynamic>.from(invitedIds!.map((x) => x)),
    "status": status,
    "productImages": productImages == [] ? null : List<dynamic>.from(productImages!.map((x) => x)),
    "_id": id,
    "ownerId": ownerId == null ? null : ownerId!.toJson(),
    "title": title,
    "shopId": shopId == null ? null : shopId!.toJson(),
    "productPrice": productPrice,
    "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
    "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "__v": v,
    "token": token,
  };
}

class OwnerId {
  OwnerId({
    this.id,
    this.firstName,
    this.lastName,
    this.bio,
    this.userName,
    this.email,
    this.profilePhoto,
  });

  String? id;
  String? firstName;
  String? lastName;
  String? bio;
  String? userName;
  String? email;
  String? profilePhoto;

  factory OwnerId.fromJson(Map<String, dynamic> json) => OwnerId(
    id: json["_id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    bio: json["bio"],
    userName: json["userName"],
    email: json["email"],
    profilePhoto: json["profilePhoto"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "firstName": firstName == null ? null : firstName,
    "lastName": lastName == null ? null : lastName,
    "bio": bio == null ? null : bio,
    "userName": userName == null ? null : userName,
    "email": email == null ? null : email,
    "profilePhoto": profilePhoto == null ? null : profilePhoto,
  };
}

class ShopId {
  ShopId({
    this.id,
    this.image,
    this.description,
  });

  String? id;
  String? image;
  String? description;

  factory ShopId.fromJson(Map<String, dynamic> json) => ShopId(
    id: json["_id"] == null ? null : json["_id"],
    image: json["image"] == null ? null : json["image"],
    description: json["description"] == null ? null : json["description"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "image": image,
    "description": description == null ? null : description,
  };
}
