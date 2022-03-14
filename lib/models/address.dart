import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  Address({
    required this.id,
    required this.name,
    required this.addrress1,
    required this.addrress2,
    required this.city,
    required this.state,
    required this.phone,
    this.user,
    required this.userId,
  });

  String id;
  String name;
  String addrress1;
  String addrress2;
  String state;
  String city;
  String phone;
  UserAddress? user;
  String userId;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["_id"],
        name: json["name"],
        addrress1: json["addrress1"],
        addrress2: json["addrress2"],
        city: json["city"],
        state: json["state"],
        phone: json["phone"],
        user: UserAddress.fromJson(json["userId"]),
        userId: UserAddress.fromJson(json["userId"]).id,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "addrress1": addrress1,
        "addrress2": addrress2,
        "city": city,
        "state": state,
        "phone": phone,
        "userId": userId,
      };
}

class UserAddress {
  UserAddress({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.userName,
    required this.email,
  });

  String id;
  String firstName;
  String lastName;
  String bio;
  String userName;
  String email;

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        bio: json["bio"],
        userName: json["userName"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "bio": bio,
        "userName": userName,
        "email": email,
      };
}
