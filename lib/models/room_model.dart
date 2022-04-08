// To parse this JSON data, do
//
//     final roomModel = roomModelFromJson(jsonString);

import 'dart:convert';

import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/models/user_model.dart';

import 'shop.dart';

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
    this.v,
    this.token,
    this.roomType,
    this.invitedhostIds,
    this.activeTime,
    this.resourceId,
    this.recordingsid,
    this.recordingUid,
  });

  List<Product>? productIds;
  List<OwnerId>? hostIds = [];
  List<String>? invitedhostIds = [];
  List<OwnerId>? userIds = [];
  List<OwnerId>? raisedHands = [];
  List<OwnerId>? speakerIds = [];
  List<OwnerId>? invitedIds = [];
  bool? status;
  List<dynamic>? productImages = [];
  String? id;
  int? activeTime;
  UserModel? ownerId;
  String? title = "";
  String? recordingUid = "";
  String? resourceId = "";
  String? recordingsid = "";
  Shop? shopId;
  int? productPrice;
  int? v;
  String? roomType;
  dynamic? token;

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
        productIds: json["productIds"] == null
            ? []
            : List<Product>.from(
                json["productIds"].map((x) => Product.fromJson(x))),
        hostIds: json["hostIds"] == null
            ? []
            : List<OwnerId>.from(
                json["hostIds"].map((x) => OwnerId.fromJson(x))),
        userIds: json["userIds"] == null
            ? []
            : List<OwnerId>.from(
                json["userIds"].map((x) => OwnerId.fromJson(x))),
        raisedHands: json["raisedHands"] == null
            ? []
            : List<OwnerId>.from(
                json["raisedHands"].map((x) => OwnerId.fromJson(x))),
        speakerIds: json["speakerIds"] == null
            ? []
            : List<OwnerId>.from(
                json["speakerIds"].map((x) => OwnerId.fromJson(x))),
        invitedIds: json["invitedIds"] == null
            ? []
            : List<OwnerId>.from(
                json["invitedIds"].map((x) => OwnerId.fromJson(x))),
        status: json["status"],
        productImages: json["productImages"] == null
            ? []
            : List<dynamic>.from(json["productImages"].map((x) => x)),
        id: json["_id"] ?? "",
        ownerId: json["ownerId"] == null
            ? null
            : UserModel.fromJson(json["ownerId"]),
        title: json["title"] ?? "",
        shopId: json["ownerId"] == null
            ? null
            : UserModel.fromJson(json["ownerId"]).shopId,
        invitedhostIds: json["invitedhostIds"] == null
            ? []
            : List<String>.from(json["invitedhostIds"].map((x) => x)),
        productPrice: json["productPrice"],
        v: json["__v"],
        token: json["token"],
        recordingsid: json["recordingsid"] ?? "",
        recordingUid: json["recordingUid"] ?? "",
        resourceId: json["resourceId"] ?? "",
        activeTime: json["activeTime"] ?? DateTime.now().microsecondsSinceEpoch,
        roomType: json["roomType"],
      );

  Map<String, dynamic> toJson() => {
        "productIds": productIds == []
            ? []
            : List<dynamic>.from(productIds!.map((x) => x.toJson())),
        "hostIds": hostIds == null
            ? []
            : List<dynamic>.from(hostIds!.map((x) => x.toJson())),
        "userIds": userIds == null
            ? []
            : List<dynamic>.from(userIds!.map((x) => x.toJson())),
        "raisedHands": raisedHands == []
            ? []
            : List<dynamic>.from(raisedHands!.map((x) => x.toJson())),
        "speakerIds": speakerIds == []
            ? []
            : List<dynamic>.from(speakerIds!.map((x) => x)),
        "invitedIds": invitedIds == []
            ? []
            : List<dynamic>.from(invitedIds!.map((x) => x)),
        "status": status,
        "productImages": productImages == []
            ? []
            : List<dynamic>.from(productImages!.map((x) => x)),
        "_id": id,
        "ownerId": ownerId == null ? null : ownerId!.toJson(),
        "title": title,
        "shopId": shopId == null ? null : shopId!.toJson(),
        "productPrice": productPrice,
        "__v": v,
        "token": token,
        "roomType": roomType,
        "recordingsid": recordingsid,
        "recordingUid": recordingUid,
        "resourceId": resourceId,
      };
}

class OwnerId {
  OwnerId({
    this.followers,
    this.following,
    this.wallet,
    this.currentRoom,
    this.facebook,
    this.instagram,
    this.linkedIn,
    this.twitter,
    this.id,
    this.firstName,
    this.lastName,
    this.bio,
    this.userName,
    this.email,
    this.password,
    this.phonenumber,
    this.createdAt,
    this.shopId,
    this.updatedAt,
    this.profilePhoto,
    this.memberShip,
    this.upgradedDate,
    this.followersCount,
    this.followingCount,
  });

  List<String>? followers;
  List<String>? following;
  int? followersCount;
  int? followingCount;
  int? wallet;
  String? currentRoom;
  String? facebook;
  String? instagram;
  String? linkedIn;
  String? twitter;
  String? id;
  String? firstName;
  String? lastName;
  String? bio;
  String? userName;
  String? email;
  String? password;
  String? phonenumber;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? profilePhoto;
  String? shopId;
  int? memberShip;
  int? upgradedDate;

  factory OwnerId.fromJson(Map<String, dynamic> json) => OwnerId(
        followers: json["followers"] != null
            ? List<String>.from(json["followers"].map((x) => x))
            : [],
        following: json["following"] != null
            ? List<String>.from(json["following"].map((x) => x))
            : [],
        wallet: json["wallet"],
        currentRoom: json["currentRoom"] ?? "",
        facebook: json["facebook"],
        instagram: json["instagram"],
        linkedIn: json["linkedIn"],
        twitter: json["twitter"],
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        bio: json["bio"],
        userName: json["userName"],
        email: json["email"],
        password: json["password"],
        shopId: json["shopId"].toString().length > 40
            ? Shop.fromJson(json["shopId"]).id
            : json["shopId"],
        phonenumber: json["phonenumber"],
        profilePhoto: json["profilePhoto"],
        memberShip: json["memberShip"],
        upgradedDate: json["upgradedDate"],
        followersCount: json["followersCount"],
        followingCount: json["followingCount"],
      );

  Map<String, dynamic> toJson() => {
        // "followers": List<dynamic>.from(followers!.map((x) => x)),
        // "following": List<dynamic>.from(following!.map((x) => x)),
        "wallet": wallet,
        "currentRoom": currentRoom,
        "facebook": facebook,
        "instagram": instagram,
        "linkedIn": linkedIn,
        "twitter": twitter,
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "bio": bio,
        "shopId": shopId,
        "userName": userName,
        "email": email,
        "password": password,
        "phonenumber": phonenumber,
        "profilePhoto": profilePhoto,
        "memberShip": memberShip,
        "upgradedDate": upgradedDate,
      };
}
