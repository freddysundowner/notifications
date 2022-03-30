import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/models/room_images_model.dart';
import 'package:fluttergistshop/models/room_model.dart';
import 'package:fluttergistshop/models/user_model.dart';
import 'package:fluttergistshop/screens/home/home_page.dart';
import 'package:fluttergistshop/screens/room/room_page.dart';
import 'package:fluttergistshop/services/firestore_files_access_service.dart';
import 'package:fluttergistshop/services/product_api.dart';
import 'package:fluttergistshop/services/room_api.dart';
import 'package:fluttergistshop/services/user_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:fluttergistshop/utils/utils.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:permission_handler/permission_handler.dart';

import 'auth_controller.dart';

class RoomController extends GetxController {
  RtcEngineContext context = RtcEngineContext(agoraAppID);
  late RtcEngine engine;

  var currentProfile = "".obs;
  var profileLoading = false.obs;
  var isLoading = false.obs;
  var allUsersLoading = false.obs;
  var allUsers = [].obs;
  var searchedUsers = [].obs;
  var isCurrentRoomLoading = false.obs;
  var roomsList = [].obs;
  var currentRoom = RoomModel().obs;
  var isCreatingRoom = false.obs;
  var newRoom = RoomModel().obs;
  var toInviteUsers = [].obs;
  var audioMuted = true.obs;

  var newRoomTitle = " ".obs;
  var newRoomType = "public".obs;
  var agoraToken = "".obs;

  var roomPickedProduct = Product().obs;

  var roomHosts = <UserModel>[].obs;
  var roomShopId = "".obs;
  var roomProductImages = [].obs;

  var userProducts = [].obs;
  var userProductsLoading = false.obs;
  var userJoinedRoom = false.obs;

  var roomPickedImages = [].obs;

  final TextEditingController searchChatUsersController =
      TextEditingController();
  TextEditingController roomTitleController = TextEditingController();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onInit() {
    getRooms();
    super.onInit();
  }

  getRooms() async {
    await fetchRooms();
    printOut(roomsList.length);
  }

  Future<void> createRoom() async {
    try {
      isCreatingRoom.value = true;

      Get.defaultDialog(
          title: "We are creating your room",
          content: const CircularProgressIndicator(),
          barrierDismissible: false);

      var hosts = [];
      for (var element in roomHosts) {
        hosts.add(element.id);
      }

      printOut("Room title ${roomTitleController.text}");

      String roomTitle =
          roomTitleController.text.isEmpty ? " " : roomTitleController.text;

      var roomData = {
        "title": roomTitle,
        "roomType": newRoomType.value,
        "productIds": [roomPickedProduct.value.id],
        "hostIds": hosts,
        "userIds": [],
        "raisedHands": [],
        "speakerIds": [],
        "invitedIds": [],
        "shopId": Get.find<AuthController>().usermodel.value!.shopId!.id,
        "status": true,
        "productPrice": roomPickedProduct.value.price,
        "productImages": roomPickedProduct.value.images,
      };

      var rooms = await RoomAPI().createARoom(roomData);

      printOut("room created $rooms");

      if (rooms != null) {
        var roomId = rooms["_id"];
        var token = await RoomAPI().generateAgoraToken(roomId, "0");
        printOut("room token $token");
        roomTitleController.text = "";

        if (token != null) {
          printOut("room title ${roomData["title"]}");
          await RoomAPI().updateRoomById(
              {"title": roomData["title"], "token": token}, roomId);

          await fetchRoom(roomId);

          leaveAgora();
          initAgora(token, roomId);
          uploadImageToFireStorage(roomId);

          Get.offAll(HomePage());
          Get.to(RoomPage(roomId: roomId));
        } else {
          Get.offAll(HomePage());
          Get.snackbar(
              "", "There was an error creating your room. Try again later");
          await RoomAPI().deleteARoom(roomId);
        }
      } else {
        Get.offAll(HomePage());
        Get.snackbar("", "Error creating your room");
      }

      isCreatingRoom.value = false;

      update();
    } catch (e, s) {
      Get.back();
      printOut("Error creating room in controller $e $s");
      isCreatingRoom.value = false;
    }
  }

  Future<void> uploadImageToFireStorage(String roomId) async {
    String snackBarMessage = "";

    try {
      List<String> uploadedImages = [];

      for (var i = 0; i < roomPickedImages.length; i++) {
        RoomImagesModel roomImagesModel = roomPickedImages.elementAt(i);

        if (roomImagesModel.isPath) {
          final downloadUrl = await FirestoreFilesAccess().uploadFileToPath(
              File(roomImagesModel.imageUrl), "rooms/$roomId");

          printOut(downloadUrl);
          uploadedImages.add(downloadUrl);
          currentRoom.value.productImages!.add(downloadUrl);
          currentRoom.refresh();
        }
      }

      await RoomAPI().updateRoomById({
        "title": currentRoom.value.title ?? " ",
        "token": currentRoom.value.token,
        "productImages": uploadedImages
      }, roomId);

      roomPickedImages.value = [];
    } on FirebaseException catch (e) {
      snackBarMessage = "Something went wrong ${e.toString()}";
    } catch (e) {
      snackBarMessage = "Something went wrong ${e.toString()}";
    } finally {
      GetSnackBar(title: "", message: snackBarMessage);
    }
  }

  Future<void> fetchRooms() async {
    try {
      isLoading.value = true;

      var rooms = await RoomAPI().getAllRooms();

      if (rooms != null) {
        roomsList.value = rooms;
      } else {
        roomsList.value = [];
      }
      roomsList.refresh();
      isLoading.value = false;

      update();
    } catch (e) {
      printOut(e);
      isLoading.value = false;
    }
  }

  Future<void> fetchUserCurrentRoom() async {
    try {
      isLoading.value = true;

      var room = await RoomAPI()
          .getRoomById(Get.find<AuthController>().usermodel.value!.id!);

      if (room != null) {
        currentRoom.value = RoomModel.fromJson(room);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRoom(String roomId) async {
    printOut("RoomId $roomId");

    try {
      isCurrentRoomLoading.value = true;

      var roomResponse = await RoomAPI().getRoomById(roomId);

      if (roomResponse != null) {
        RoomModel room = RoomModel.fromJson(roomResponse);
        printOut("currentRoom token ${room.token}");
        if (room.token != null) {
          currentRoom.value = room;
        }
      } else {
        Get.snackbar('', "Room has ended");
      }
      isCurrentRoomLoading.value = false;

      printOut("Room $roomResponse");
    } catch (e, s) {
      printOut("Error getting individual room $e $s");
      isCurrentRoomLoading.value = false;
    }
  }

  Future<void> addUserToRoom(OwnerId user) async {
    printOut(
        "current user being added to room token ${currentRoom.value.token}");

    if (currentRoom.value.token != null) {
      initAgora(currentRoom.value.token, currentRoom.value.id!);

      printOut("current user being added to room ${user.id}");

      if ((currentRoom.value.hostIds!
                  .indexWhere((element) => element.id == user.id) ==
              -1) &&
          (currentRoom.value.speakerIds!
                  .indexWhere((element) => element.id == user.id) ==
              -1) &&
          (currentRoom.value.userIds!
                  .indexWhere((element) => element.id == user.id) ==
              -1)) {
        currentRoom.value.userIds!.add(user);

        currentRoom.refresh();

        //Add user to room
        await RoomAPI().updateRoomById({
          "title": currentRoom.value.title ?? " ",
          "userIds": [user.id],
          "token": currentRoom.value.token
        }, currentRoom.value.id!);
      }
    }
  }

  Future<void> addUserToSpeaker(OwnerId user) async {
    currentRoom.value.userIds!.remove(user);

    if ((currentRoom.value.speakerIds!
            .indexWhere((element) => element.id == user.id) ==
        -1)) {
      currentRoom.value.speakerIds!.add(user);

      currentRoom.refresh();

      //Add user to speakers
      await RoomAPI().updateRoomById({
        "title": currentRoom.value.title ?? " ",
        "speakerIds": [user.id],
        "token": currentRoom.value.token
      }, currentRoom.value.id!);

      //Remove user from audience
      await RoomAPI().removeUserFromAudienceInRoom({
        "users": [user.id]
      }, currentRoom.value.id!);
    }
    //Remove user from RaisedHand
    await RoomAPI().removeUserFromRaisedHandsInRoom({
      "users": [user.id],
      "token": currentRoom.value.token
    }, currentRoom.value.id!);
  }

  Future<void> addUserToRaisedHands(OwnerId user) async {
    currentRoom.value.raisedHands!.add(user);

    Get.snackbar('', "You have raised your hand");

    currentRoom.refresh();

    //Add user to raisedHands
    await RoomAPI().updateRoomById({
      "title": currentRoom.value.title ?? " ",
      "raisedHands": [user.id],
      "token": currentRoom.value.token
    }, currentRoom.value.id!);
  }

  Future<void> removeUserFromSpeaker(OwnerId user) async {
    currentRoom.value.speakerIds!.remove(user);
    currentRoom.value.userIds!.add(user);

    currentRoom.refresh();

    //Add user to speakers
    await RoomAPI().updateRoomById({
      "title": currentRoom.value.title ?? " ",
      "userIds": [user.id],
      "token": currentRoom.value.token
    }, currentRoom.value.id!);
    //Remove user from audience
    await RoomAPI().removeUserFromSpeakerInRoom({
      "users": [user.id]
    }, currentRoom.value.id!);
  }

  Future<void> removeUserFromRaisedHands(OwnerId user) async {
    currentRoom.value.raisedHands!.remove(user);

    if ((currentRoom.value.speakerIds!
            .indexWhere((element) => element.id == user.id) ==
        -1)) {
      currentRoom.value.speakerIds!.add(user);

      currentRoom.refresh();

      //Add user to speakers
      await RoomAPI().updateRoomById({
        "title": currentRoom.value.title ?? " ",
        "speakerIds": [user.id],
        "token": currentRoom.value.token
      }, currentRoom.value.id!);

      //Remove user from RaisedHand
      await RoomAPI().removeUserFromRaisedHandsInRoom({
        "users": [user.id],
        "token": currentRoom.value.token
      }, currentRoom.value.id!);
    }
    //Remove user from RaisedHand
    await RoomAPI().removeUserFromAudienceInRoom({
      "users": [user.id],
      "token": currentRoom.value.token
    }, currentRoom.value.id!);
  }

  Future<void> leaveRoom(OwnerId user) async {
    currentRoom.value.speakerIds!.remove(user);
    currentRoom.value.userIds!.remove(user);
    currentRoom.value.raisedHands!.remove(user);

    currentRoom.refresh();
    if (currentRoom.value.hostIds!.length == 1 &&
        currentRoom.value.hostIds!
                .indexWhere((element) => element.id == user.id) ==
            0) {
      await RoomAPI().deleteARoom(currentRoom.value.id!);
    } else {
      if (currentRoom.value.userIds!
              .indexWhere((element) => element.id == user.id) >
          -1) {
        await RoomAPI().removeAUserFromRoom({
          "users": [user.id]
        }, currentRoom.value.id!);
      } else if (currentRoom.value.speakerIds!
              .indexWhere((element) => element.id == user.id) >
          -1) {
        await RoomAPI().removeUserFromSpeakerInRoom({
          "users": [user.id]
        }, currentRoom.value.id!);
      } else if (currentRoom.value.raisedHands!
              .indexWhere((element) => element.id == user.id) >
          -1) {
        await RoomAPI().removeUserFromRaisedHandsInRoom({
          "users": [user.id]
        }, currentRoom.value.id!);
      } else if (currentRoom.value.hostIds!
              .indexWhere((element) => element.id == user.id) >
          -1) {
        await RoomAPI().removeUserFromHostInRoom({
          "users": [user.id]
        }, currentRoom.value.id!);
      }
    }

    currentRoom.value = RoomModel();
  }

  Future<void> joinRoom(String roomId) async {
    await fetchRoom(roomId);

    if (currentRoom.value.id != null) {
      OwnerId currentUser = OwnerId(
          id: Get.find<AuthController>().usermodel.value!.id,
          bio: Get.find<AuthController>().usermodel.value!.bio,
          email: Get.find<AuthController>().usermodel.value!.email,
          firstName: Get.find<AuthController>().usermodel.value!.firstName,
          lastName: Get.find<AuthController>().usermodel.value!.lastName,
          userName: Get.find<AuthController>().usermodel.value!.userName,
          profilePhoto:
              Get.find<AuthController>().usermodel.value!.profilePhoto);
      await addUserToRoom(currentUser);
      if (currentRoom.value.token != null) {
        Get.to(RoomPage(
          roomId: roomId,
        ));
      } else {
        roomsList.removeWhere((element) => element.id == roomId);
        Get.snackbar(
            '', "There was an error adding you to the room, Try again later");
      }
    } else {
      await fetchRooms();
    }
  }

  @override
  void dispose() {
    leaveAgora();
    super.dispose();
  }

  Future<void> leaveAgora() async {
    await engine.leaveChannel();
    await engine.muteLocalAudioStream(true);
    await engine.destroy();
  }

  Future<void> fetchAllUsers() async {
    if (allUsers.isEmpty) {
      try {
        allUsersLoading.value = true;

        var users = await UserAPI().getAllUsers();
        var list = [];

        if (users != null) {
          for (var i = 0; i < users.length; i++) {
            if (users.elementAt(i)["_id"] !=
                FirebaseAuth.instance.currentUser!.uid) {
              list.add(users.elementAt(i));
            }
          }
          allUsers.value = list;
        } else {
          allUsers.value = [];
        }
        searchedUsers.value = allUsers;

        allUsers.refresh();
        allUsersLoading.value = false;

        update();
      } catch (e) {
        printOut(e);
        allUsersLoading.value = false;
      }
    }
  }

  searchUsers() async {
    if (searchChatUsersController.text.trim().isNotEmpty) {
      try {
        allUsersLoading.value = true;

        var users =
            await UserAPI().searchUser(searchChatUsersController.text.trim());

        var list = [];

        if (users != null) {
          for (var i = 0; i < users.length; i++) {
            if (users.elementAt(i)["_id"] !=
                FirebaseAuth.instance.currentUser!.uid) {
              list.add(users.elementAt(i));
            }
          }
          searchedUsers.value = list;
        } else {
          searchedUsers.value = [];
        }
        searchedUsers.refresh();
        allUsersLoading.value = false;

        update();
      } catch (e) {
        printOut(e);
        allUsersLoading.value = false;
      }
    }
  }

  Future<void> fetchUserProducts() async {
    try {
      userProductsLoading.value = true;
      userProducts.value = [];
      var products = await ProductPI()
          .getUserProducts(FirebaseAuth.instance.currentUser!.uid);

      if (products != null) {
        printOut(products.length);

        //if a product has images, add it to the user products list
        for (var i = 0; i < products.length; i++) {
          Product product = Product.fromJson(products.elementAt(i));
          printOut(product.images);
          userProducts.add(products.elementAt(i));

          /*   if (product.images != null && product.images!.isNotEmpty) {
            userProducts.add(products.elementAt(i));
          }*/
        }
        printOut(userProducts.length);
      } else {
        userProducts.value = [];
      }
      userProducts.refresh();
      userProductsLoading.value = false;

      update();
    } catch (e) {
      printOut(e);
      userProductsLoading.value = false;
    }
  }

  void initAgora(String token, String roomId) async {
    try {
      printOut("Joining agora room");

      try {
        await leaveAgora();
      } catch (e, s) {
        printOut("Error leaving agora $e $s");
      }

      // Get microphone permission
      await [Permission.microphone].request();

      // Create RTC client instance
      engine = await RtcEngine.createWithContext(context);

      // Define event handling logic
      agoraListeners();

      // Join channel

      await engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
      await engine.enableAudioVolumeIndication(500, 3, true);
      await engine.enableAudio();
      await engine.muteLocalAudioStream(true);
      await engine.setDefaultAudioRoutetoSpeakerphone(true);

      await engine.setClientRole(ClientRole.Broadcaster);
      await engine.joinChannel(token, roomId, null, 0);
    } catch (e, s) {
      printOut('error joining room $e $s');
    }
  }

  void agoraListeners() {
    // Define event handling logic
    engine.setEventHandler(RtcEngineEventHandler(error: (error) async {
      printOut("Error in agora ${error.name}");
      if (error.name == "InvalidToken" || error.name == "TokenExpired") {
        Get.back();
        roomsList
            .removeWhere((element) => element["_id"] == currentRoom.value.id);
        Get.snackbar('', "Room has ended");

        await RoomAPI().deleteARoom(currentRoom.value.id!);
        currentRoom.value = RoomModel();

        leaveAgora();
      }
    }, joinChannelSuccess: (String channel, int uid, int elapsed) {
      printOut('joinChannelSuccess $channel $uid');
      userJoinedRoom.value = true;
    }, userJoined: (int uid, int elapsed) {
      printOut('userJoined $uid');
    }, userOffline: (int uid, UserOfflineReason reason) {
      printOut('userOffline $uid');
    }));
  }

  getUserProfile(String userId) async {
    try {
      profileLoading.value = true;
      var user = await UserAPI().getUserProfile(userId);

      if (user == null) {
        currentProfile.value = "";
      } else {
        currentProfile.value = user;
      }

      profileLoading.value = false;
    } catch (e, s) {
      printOut("Error getting user $userId profile $e $s");
    }
  }
}
