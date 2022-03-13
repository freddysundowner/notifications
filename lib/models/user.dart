import 'dart:convert';

import 'package:meta/meta.dart';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  List<String>? followers;
  List<String>? following;
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
  int? memberShip;
  int? upgradedDate;
  UserModel({
    @required this.followers,
    @required this.following,
    @required this.wallet,
    @required this.currentRoom,
    @required this.facebook,
    @required this.instagram,
    @required this.linkedIn,
    @required this.twitter,
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.bio,
    @required this.userName,
    @required this.email,
    @required this.password,
    @required this.phonenumber,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.profilePhoto,
    @required this.memberShip,
    @required this.upgradedDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        followers: List<String>.from(json["followers"].map((x) => x)),
        following: List<String>.from(json["following"].map((x) => x)),
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
        phonenumber: json["phonenumber"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        profilePhoto: json["profilePhoto"],
        memberShip: json["memberShip"],
        upgradedDate: json["upgradedDate"],
      );

  Map<String, dynamic> toJson() => {
        "followers": List<dynamic>.from(followers!.map((x) => x)),
        "following": List<dynamic>.from(following!.map((x) => x)),
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
        "userName": userName,
        "email": email,
        "password": password,
        "phonenumber": phonenumber,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "profilePhoto": profilePhoto,
        "memberShip": memberShip,
        "upgradedDate": upgradedDate,
      };
}
