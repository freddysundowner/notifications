import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/models/room_images_model.dart';
import 'package:fluttergistshop/models/room_model.dart';
import 'package:fluttergistshop/models/user_model.dart';
import 'package:fluttergistshop/screens/home/main_page.dart';
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

class RoomController extends FullLifeCycleController with FullLifeCycleMixin {
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

  final TextEditingController searchUsersController = TextEditingController();
  TextEditingController roomTitleController = TextEditingController();

  // Mandatory
  @override
  void onDetached() {
    print('HomeController - onDetached called');
  }

  // Mandatory
  @override
  void onInactive() {
    print('HomeController - onInative called');
  }

  // Mandatory
  @override
  void onPaused() {
    print('HomeController - onPaused called');
  }

  // Mandatory
  @override
  void onResumed() {
    print('HomeController - onResumed called');
  }

  // Optional
  @override
  Future<bool> didPushRoute(String route) {
    print('HomeController - the route $route will be open');
    return super.didPushRoute(route);
  }

  // Optional
  @override
  Future<bool> didPopRoute() {
    print('HomeController - the current route will be closed');
    return super.didPopRoute();
  }

  // Optional
  @override
  void didChangeMetrics() {
    print('HomeController - the window size did change');
    super.didChangeMetrics();
  }

  // Optional
  @override
  void didChangePlatformBrightness() {
    print('HomeController - platform change ThemeMode');
    super.didChangePlatformBrightness();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onInit() {
    _initAgora();
    getRooms();

    super.onInit();
    printOut("room controller");
  }

  _initAgora() async {
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
    await engine.muteLocalAudioStream(audioMuted.value);
    await engine.setDefaultAudioRoutetoSpeakerphone(true);

    await engine.setClientRole(ClientRole.Broadcaster);
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
        "activeTime": DateTime.now().microsecondsSinceEpoch
      };

      leaveRoom(OwnerId(id: Get.find<AuthController>().usermodel.value!.id));

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
              {"title": roomData["title"], "token": token,
                "activeTime" : DateTime.now().microsecondsSinceEpoch}, roomId);

          await fetchRoom(roomId);

          initAgora(token, roomId);
          uploadImageToFireStorage(roomId);

          Get.offAll(MainPage());
          Get.to(RoomPage(roomId: roomId));
        } else {
          Get.offAll(MainPage());
          Get.snackbar(
              "", "There was an error creating your room. Try again later");

          endRoom(roomId);
        }
      } else {
        Get.offAll(MainPage());
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
        } else {
          Get.snackbar(
            '',
            "There was an error adding you to the room, Try again later",
          ).show();
          endRoom(roomId);
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
        currentRoom.refresh();
        leaveRoomWhenKilled();
        emitRoom(currentUser: user.toJson(), action: "join");
        //Add user to room

        if (currentRoom.value.invitedhostIds!
                .indexWhere((element) => element == user.id) !=
            -1) {
          currentRoom.value.hostIds!.add(user);
          await RoomAPI().updateRoomById({
            "token": currentRoom.value.token,
            "hostIds": [user.id]
          }, currentRoom.value.id!);
        } else {
          currentRoom.value.userIds!.add(user);
          await RoomAPI().addUserrToRoom({
            "users": [user.id]
          }, currentRoom.value.id!);
        }
      }
    } else {
      roomsList.removeWhere((element) => element.id == currentRoom.value.id);
      Get.snackbar(
          '', "There was an error adding you to the room, Try again later");
    }
  }

  void leaveRoomWhenKilled() {
    print("leaveRommWhenKilled");
    if (Get.find<AuthController>().currentuser!.currentRoom! != "") {
      emitRoom(
          action: "leave",
          roomId: Get.find<AuthController>().currentuser!.currentRoom!,
          currentUser: Get.find<AuthController>().currentuser!.toJson());
      Get.find<AuthController>().currentuser!.currentRoom = "";
    }
  }

  Future<void> addUserToSpeaker(OwnerId user) async {
    currentRoom.value.userIds!.removeWhere((element) => element.id == user.id);
    currentRoom.value.raisedHands!
        .removeWhere((element) => element.id == user.id);

    if ((currentRoom.value.speakerIds!
            .indexWhere((element) => element.id == user.id) ==
        -1)) {
      currentRoom.value.speakerIds!.add(user);

      currentRoom.refresh();

      emitRoom(currentUser: user.toJson(), action: "add_speaker");
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

    emitRoom(currentUser: user.toJson(), action: "added_raised_hands");

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

    emitRoom(currentUser: user.toJson(), action: "remove_speaker");
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
    currentRoom.value.raisedHands!
        .removeWhere((element) => element.id == user.id);
    currentRoom.value.userIds!.removeWhere((element) => element.id == user.id);

    if ((currentRoom.value.speakerIds!
            .indexWhere((element) => element.id == user.id) ==
        -1)) {
      currentRoom.value.speakerIds!.add(user);

      currentRoom.refresh();

      emitRoom(currentUser: user.toJson(), action: "add_speaker");
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

  Future<void> leaveRoom(OwnerId user, {String? idRoom}) async {
    if (currentRoom.value.hostIds!.length == 1 &&
        currentRoom.value.hostIds!
                .indexWhere((element) => element.id == user.id) !=
            -1) {
      currentRoom.value = RoomModel();
      endRoom(idRoom ?? currentRoom.value.id!);
    } else {
      if (currentRoom.value.userIds!
              .indexWhere((element) => element.id == user.id) >
          -1) {
        await RoomAPI().removeAUserFromRoom({
          "users": [user.id]
        }, idRoom ?? currentRoom.value.id!);
      } else if (currentRoom.value.speakerIds!
              .indexWhere((element) => element.id == user.id) >
          -1) {
        await RoomAPI().removeUserFromSpeakerInRoom({
          "users": [user.id]
        }, idRoom ?? currentRoom.value.id!);
      } else if (currentRoom.value.raisedHands!
              .indexWhere((element) => element.id == user.id) >
          -1) {
        await RoomAPI().removeUserFromRaisedHandsInRoom({
          "users": [user.id]
        }, idRoom ?? currentRoom.value.id!);
      } else if (currentRoom.value.hostIds!
              .indexWhere((element) => element.id == user.id) >
          -1) {
        await RoomAPI().removeUserFromHostInRoom({
          "users": [user.id]
        }, idRoom ?? currentRoom.value.id!);
      }
    }

    var roomId = idRoom ?? currentRoom.value.id!;

    emitRoom(currentUser: user.toJson(), action: "leave", roomId: roomId);
    currentRoom.value = RoomModel();

    try {
      leaveAgora();
    } catch (e) {
      printOut("Error leaving agora");
    }
  }

  endRoom(String roomId) async {
    try {
      currentRoom.value = RoomModel();
      currentRoom.refresh();
      emitRoom(action: "room_ended", roomId: roomId);
      await RoomAPI().deleteARoom(roomId);
      leaveAgora();
    } catch (e, s) {
      printOut("Error ending room $e $s");
    }
  }

  Future<void> joinRoom(String roomId) async {
    OwnerId currentUser = OwnerId(
        id: Get.find<AuthController>().usermodel.value!.id,
        bio: Get.find<AuthController>().usermodel.value!.bio,
        email: Get.find<AuthController>().usermodel.value!.email,
        firstName: Get.find<AuthController>().usermodel.value!.firstName,
        lastName: Get.find<AuthController>().usermodel.value!.lastName,
        userName: Get.find<AuthController>().usermodel.value!.userName,
        profilePhoto: Get.find<AuthController>().usermodel.value!.profilePhoto);

    if (currentRoom.value.id != null && currentRoom.value.id != roomId) {
      var prevRoom = currentRoom.value.id;
      currentRoom.value.id = null;
      await leaveRoom(currentUser, idRoom: prevRoom);

      currentRoom.value = RoomModel();
      currentRoom.refresh();
    }

    await fetchRoom(roomId);

    if (currentRoom.value.id != null) {
      await addUserToRoom(currentUser);

      if (currentRoom.value.token != null) {
        //If user is not a speaker or a host, disable their audio
        if (currentRoom.value.userIds!
                .indexWhere((e) => e.id == currentUser.id) ==
            -1) {
          try {
            engine.enableAudio();
            engine.enableLocalAudio(true);

            engine.muteLocalAudioStream(audioMuted.value);
            currentRoom.refresh();
          } catch (e, s) {
            printOut("Error disabling audio $e $s");
          }
        } else {
          engine.enableLocalAudio(false);
        }
        Get.to(RoomPage(
          roomId: roomId,
        ));
      } else {
        roomsList.removeWhere((element) => element.id == roomId);
      }
    } else {
      await fetchRooms();
    }
  }

  void emitRoom(
      {Map? currentUser, required String action, String roomId = ""}) {
    customSocketIO.socketIO.emit("room_changes", {
      "action": action,
      "userData": currentUser == null ? {} : currentUser,
      "roomId": currentRoom.value.id ?? roomId
    });
  }

  @override
  void onClose() {
    print("onClose");
    leaveRoomWhenKilled();
    leaveAgora();
    super.onClose();
  }

  Future<void> leaveAgora() async {
    // if (engine != null) {

    await engine.leaveChannel();
    await engine.muteLocalAudioStream(true);
    // await engine.destroy();
    // }
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
    } else {
      searchedUsers.value = allUsers;
    }
  }

  searchUsers() async {
    if (searchUsersController.text.trim().isNotEmpty) {
      try {
        allUsersLoading.value = true;

        var users =
            await UserAPI().searchUser(searchUsersController.text.trim());

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

      await leaveAgora();
      await engine.joinChannel(token, roomId, null, 0);
      await engine.enableAudioVolumeIndication(500, 3, true);
    } catch (e, s) {
      printOut('error joining room $e $s');
    }
  }

  void agoraListeners() {
    // Define event handling logic
    engine.setEventHandler(
      RtcEngineEventHandler(error: (error) async {
        printOut("Error in agora ${error.name}");
        if (error.name == "InvalidToken" || error.name == "TokenExpired") {
          Get.back();
          roomsList
              .removeWhere((element) => element["_id"] == currentRoom.value.id);

          endRoom(currentRoom.value.id!);

          leaveAgora();
        }
      }, joinChannelSuccess: (String channel, int uid, int elapsed) {
        printOut('joinChannelSuccess $channel $uid');

        userJoinedRoom.value = true;
      }, userJoined: (int uid, int elapsed) async {
        printOut('userJoined $uid');
      }, userOffline: (int uid, UserOfflineReason reason) {
        printOut('userOffline $uid');
      }, audioVolumeIndication:
          (List<AudioVolumeInfo> speakers, int totalVolume) async {
        if (totalVolume > 2) {
          writeToDbRoomActive();
        }
      }),
    );
  }

  //If the last time the activeTime field was updated was more or equal to 10 mins ago, then update it
  writeToDbRoomActive() async {
    var now = DateTime.now();

    if (currentRoom.value.activeTime != null) {
      var lastUpdated =
          DateTime.fromMicrosecondsSinceEpoch(currentRoom.value.activeTime!);
      var duration = now.difference(lastUpdated);

      if (duration.inMinutes > activeRoomUpdatePeriod) {
        updateActiveTime(now);
      }
    } else {
      updateActiveTime(now);
    }
  }

  updateActiveTime(DateTime now) async {
    currentRoom.value.activeTime = now.microsecondsSinceEpoch;
    if (currentRoom.value.id != null &&
        currentRoom.value.hostIds!.indexWhere((element) =>
                element.id == FirebaseAuth.instance.currentUser!.uid) !=
            -1) {
      await RoomAPI().updateRoomById({
        "activeTime": now.microsecondsSinceEpoch,
        "title": currentRoom.value.title,
        "token": currentRoom.value.token
      }, currentRoom.value.id!);
    }
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
