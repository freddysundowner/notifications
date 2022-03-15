// To parse this JSON data, do
//
//     final activityModel = activityModelFromJson(jsonString);

import 'dart:convert';

import 'package:fluttergistshop/utils/Functions.dart';

ActivityModel activityModelFromJson(String str) => ActivityModel.fromJson(json.decode(str));

String activityModelToJson(ActivityModel data) => json.encode(data.toJson());

class ActivityModel {
  ActivityModel({
    this.from,
    this.id,
    this.imageurl,
    this.name,
    this.type,
    this.actionkey,
    this.actioned,
    this.to,
    this.message,
    this.time,
  });

  String? from;
  String? id;
  String? imageurl;
  String? name;
  String? type;
  String? actionkey;
  bool? actioned;
  String? to;
  String? message;
  String? time;

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
    from: json["from"],
    id: json["_id"],
    imageurl: json["imageurl"],
    name: json["name"],
    type: json["type"],
    actionkey: json["actionkey"],
    actioned: json["actioned"],
    to: json["to"],
    message: json["message"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "from": from,
    "_id": id,
    "imageurl": imageurl,
    "name": name,
    "type": type,
    "actionkey": actionkey,
    "actioned": actioned,
    "to": to,
    "message": message,
    "time": time,
  };

  getTime() {
    try {
      return convertTime(time!);
    } catch(e) {
      printOut("error converting time $e");
      return time;
    }
  }

}
