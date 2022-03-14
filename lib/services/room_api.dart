import 'dart:convert';
import 'dart:io';

import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/utils/Functions.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';

import 'client.dart';
import 'end_points.dart';

class RoomAPI {
  getAllRooms() async {
    var rooms =
        await DbBase().databaseRequest(allRooms, DbBase().getRequestType);

    return jsonDecode(rooms);
  }

  getRoomById(String roomId) async {
    var room = await DbBase()
        .databaseRequest(roomById + roomId, DbBase().getRequestType);
    return jsonDecode(room);
  }

  createARoom(Map<String, dynamic> roomData) async {
    try {
      printOut("create $roomData");
      var room = await DbBase().databaseRequest(
          createRoom + Get.find<AuthController>().usermodel.value!.id!,
          DbBase().postRequestType,
          body: roomData);

      printOut("created room $room");
      return jsonDecode(room);
    } catch (e) {
      printOut("Error creating room $e");
    }
  }

  generateAgoraToken(String channel, String uid) async {
    try {
      final ioc = new HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = new IOClient(ioc);
      var url = Uri.parse('$tokenPath?channel=$channel&uid=$uid');
      printOut("Gen token $url");
      final response = await http.get(url);
      printOut("response $response");
      if (response.statusCode == 200) {
        return jsonDecode(response.body)["token"];
      } else {
        throw Exception('Failed to load token');
      }
    } catch (e) {
      printOut("Error creating room $e");
    }
  }


  updateRoomById(Map<String, dynamic> body, String id) async {
    try {
      await DbBase().databaseRequest(updateRoom + id, DbBase().patchRequestType,
          body: body);
    } catch (e) {
      printOut("Error updating room $e");
    }
  }

  removeUserFromAudienceInRoom(Map<String, dynamic> body, String id) async {
    try {
      await DbBase().databaseRequest(
          removeUserFromAudience + id, DbBase().patchRequestType,
          body: body);
    } catch (e) {
      printOut("Error removeUserFromAudience  room $e");
    }
  }

  removeUserFromSpeakerInRoom(Map<String, dynamic> body, String id) async {
    try {
      await DbBase().databaseRequest(
          removeSpeaker + id, DbBase().patchRequestType,
          body: body);
    } catch (e) {
      printOut("Error removeUserFromAudience  room $e");
    }
  }

  removeUserFromRaisedHandsInRoom(Map<String, dynamic> body, String id) async {
    try {
      await DbBase().databaseRequest(
          removeUserFromRaisedHands + id, DbBase().patchRequestType,
          body: body);
    } catch (e) {
      printOut("Error removeUserFromAudience  room $e");
    }
  }

  removeAUserFromRoom(Map<String, dynamic> body, String id) async {
    try {
      await DbBase().databaseRequest(
          removeUserFromRoom + id, DbBase().patchRequestType,
          body: body);
    } catch (e) {
      printOut("Error removeAUserFromRoom  room $e");
    }
  }

  deleteARoom(String id) async {
    try {
      await DbBase()
          .databaseRequest(deleteRoom + id, DbBase().deleteRequestType);
    } catch (e) {
      printOut("Error deleteARoom  room $e");
    }
  }
}
