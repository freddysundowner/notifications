import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttergistshop/models/all_chats_model.dart';
import 'package:fluttergistshop/models/chat_room_model.dart';
import 'package:fluttergistshop/models/user_model.dart';
import 'package:fluttergistshop/services/notification_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

import 'auth_controller.dart';

class ChatController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  var allUserChats = [].obs;
  var gettingChats = false.obs;
  var currentChatLoading = false.obs;
  var currentChat = [].obs;
  var currentChatUsers = [].obs;
  var currentChatId = "".obs;
  var sendingMessage = false.obs;

  @override
  void onInit() {
    getUserChats();
    super.onInit();
  }

  Future<void> getUserChats() async {
    gettingChats.value = true;
    var newChats = [];

    db
        .collection("chats")
        .where("userIds", arrayContains: userId)
        .get()
        .then((querySnapshot) {
      gettingChats.value = false;

      printOut("Chats loaded ${querySnapshot.docs.length}");
      allUserChats.value = [];
      for (var i = 0; i < querySnapshot.docs.length; i++) {
        var snapshot = querySnapshot.docs.elementAt(i);

        AllChatsModel allChatsModel = AllChatsModel(
            snapshot.id,
            snapshot.get("lastMessage"),
            snapshot.get("lastMessageTime"),
            snapshot.get("lastSender"),
            snapshot.get("userIds"),
            snapshot.get("users"),
            snapshot.get(userId) ?? 0);

        newChats.add(allChatsModel);
      }

      newChats.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

      allUserChats.value = newChats;
    }).onError((error, stackTrace) {
      gettingChats.value = false;
      printOut("Error getting all chats $error $stackTrace");
    });
  }

  Future<void> getChatById(String id) async {
    currentChatLoading.value = true;
    currentChat.value = [];

    printOut("PAth $id");

    db.collection("chats/$id/messages").get().then((snapshot) {
      var chats = [];

      for (var i = 0; i < snapshot.docs.length; i++) {
        var documentSnapshot = snapshot.docs.elementAt(i);

        ChatRoomModel chatRoomModel = ChatRoomModel(
            documentSnapshot.get("date"),
            documentSnapshot.id,
            documentSnapshot.get("message"),
            documentSnapshot.get("seen"),
            documentSnapshot.get("sender"));

        chats.add(chatRoomModel);
      }
      chats.sort((a, b) => a.date.compareTo(b.date));

      currentChat.value = chats;
    });
    currentChatLoading.value = false;
  }

  getPreviousChat(UserModel otherUser) {
    currentChatLoading.value = true;
    currentChatUsers.add(otherUser.id);
    currentChatUsers.add(Get.find<AuthController>().usermodel.value!.id);

    String chatId = "";
    for (var i = 0; i < allUserChats.length; i++) {
      AllChatsModel chatsModel = allUserChats.elementAt(i);

      for (String user in chatsModel.userIds) {
        if (user == otherUser.id) {
          printOut("Other user Id " + user);
          chatId = chatsModel.id;
        }
      }
    }

    if (chatId != "") {
      currentChatId.value = chatId;
      getChatById(chatId);
    } else {
      currentChatLoading.value = false;
    }
  }

  readChats() async {
    if (currentChatId.value != "") {
      await db
          .collection("chats")
          .doc(currentChatId.value)
          .set({userId: 0}, SetOptions(merge: true));

      printOut("Chat messages read");
    }
  }

  sendMessage(String message, UserModel otherUser) {
    sendingMessage.value = true;

    if (currentChatId.value == "") {
      String genId = db.collection("chats").doc().id;
      currentChatId.value = genId;

      //Create a new chat
      createChat(message, otherUser, genId);

      printOut("Auto generated Firestore id $genId");
    }

    ChatRoomModel newChat = ChatRoomModel(
        DateTime.now().millisecondsSinceEpoch.toString(),
        currentChatId.value,
        message,
        false,
        Get.find<AuthController>().usermodel.value!.id!);

    db
        .collection("chats/${currentChatId.value}/messages")
        .add(newChat.toMap())
        .then((value) async {
      currentChat.add(newChat);
      sendingMessage.value = false;

      db.collection("chats").doc(currentChatId.value).set({
        "lastMessage": message,
        "lastMessageTime": DateTime.now().millisecondsSinceEpoch.toString(),
        "lastSender": Get.find<AuthController>().usermodel.value!.id,
        otherUser.id!: FieldValue.increment(1)
      }, SetOptions(merge: true));
      await NotificationApi().sendNotification([
        otherUser.id
      ], "${Get.find<AuthController>().usermodel.value!.firstName}"
          " ${Get.find<AuthController>().usermodel.value!.firstName}",
          message, "ChatScreen", currentChatId.value);
      printOut("Chat message saved");
    });
  }

  void createChat(String message, UserModel otherUser, chatId) {
    UserModel currentUser = Get.find<AuthController>().usermodel.value!;
    //Create a new chat
    var data = {
      "id": chatId,
      "lastMessage": message,
      "lastMessageTime": DateTime.now().millisecondsSinceEpoch.toString(),
      "lastSender": userId,
      "userIds": [userId, otherUser.id],
      userId: 0,
      otherUser.id!: 0,
      "users": [
        {
          "id": currentUser.id,
          "firstName": currentUser.firstName,
          "lastName": currentUser.lastName,
          "userName": currentUser.userName,
          "profilePhoto": currentUser.profilePhoto
        },
        {
          "id": otherUser.id,
          "firstName": otherUser.firstName,
          "lastName": otherUser.lastName,
          "userName": otherUser.userName,
          "profilePhoto": otherUser.profilePhoto
        }
      ]
    };

    printOut("New being saved $data");
    db
        .collection("chats")
        .doc(currentChatId.value)
        .set(data, SetOptions(merge: true))
        .then((value) {
      AllChatsModel allChatsModel = AllChatsModel(
          chatId,
          message,
          DateTime.now().millisecondsSinceEpoch.toString(),
          userId,
          [userId, otherUser.id],
          [
            {
              "id": currentUser.id,
              "firstName": currentUser.firstName,
              "lastName": currentUser.lastName,
              "userName": currentUser.userName,
              "profilePhoto": currentUser.profilePhoto
            },
            {
              "id": otherUser.id,
              "firstName": otherUser.firstName,
              "lastName": otherUser.lastName,
              "userName": otherUser.userName,
              "profilePhoto": otherUser.profilePhoto
            }
          ],
          0);
      allUserChats.add(allChatsModel);

      allUserChats
          .sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

      printOut("Chat saved successfully ");
    });
  }
}
