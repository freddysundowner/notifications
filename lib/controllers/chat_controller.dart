import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttergistshop/models/all_chats_model.dart';
import 'package:fluttergistshop/models/chat.dart';
import 'package:fluttergistshop/models/user_model.dart';
import 'package:fluttergistshop/services/notification_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';

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
  late Stream<QuerySnapshot> allChatStream;
  late Stream<QuerySnapshot> chatStream;
  var unReadChats = 0.obs;

  @override
  void onInit() {
    getUserChats();
    super.onInit();
  }

  Future<void> getUserChats() async {
    gettingChats.value = true;
   // allUserChats.value = [];
    allUserChats.bindStream(allUserChatsStream());
  //  allChatStream.drain();
    gettingChats.value = false;
  }

  Stream<List> allUserChatsStream() {
    allChatStream = FirebaseFirestore.instance
        .collection("chats")
        .where("userIds", arrayContains: userId)
        .snapshots();



    return allChatStream.map((event) {
      var unread = 0;
      var chatty = event.docs.map((e) {
        Map<String, dynamic> data = e.data()! as Map<String, dynamic>;

        Inbox allChatsModel = Inbox(
            data["id"],
            data["lastMessage"],
            data["lastMessageTime"],
            data["lastSender"],
            data["userIds"],
            data["users"],
            data[userId] ?? 0);
        unread = unread + allChatsModel.unread;

        return allChatsModel;
      }).toList();
      chatty.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
      unReadChats.value = unread;
      return chatty;
    });
  }

  Future<void> getChatById(String id) async {
    currentChatLoading.value = true;
    currentChat.value = [];

    printOut("PAth $id");

    currentChat.bindStream(singleChatStream(id));

    currentChatLoading.value = false;
  }

  Stream<List> singleChatStream(String id) {
    chatStream =
        FirebaseFirestore.instance.collection("chats/$id/messages").snapshots();

    var chat = chatStream.map((event) {
      var chatty = event.docs.map((e) {
        print("chat ${e.data().toString()}");
        Map<String, dynamic> data = e.data()! as Map<String, dynamic>;

        Chat chatRoomModel = Chat(data['date'], data["id"], data['message'],
            data['seen'], data['sender']);

        return chatRoomModel;
      }).toList();
      chatty.sort((a, b) => a.date.compareTo(b.date));
      return chatty;
    });

    return chat;
  }

  getPreviousChat(UserModel otherUser) {
    currentChatLoading.value = true;
    currentChatUsers.add(otherUser.id);
    currentChatUsers.add(Get.find<AuthController>().usermodel.value!.id);

    String chatId = "";
    for (var i = 0; i < allUserChats.length; i++) {
      Inbox chatsModel = allUserChats.elementAt(i);

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

      Inbox inbox = allUserChats[allUserChats.indexWhere((element) => element['id'] == currentChatId)];
      unReadChats.value = unReadChats.value - inbox.unread;
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

    Chat newChat = Chat(
        DateTime.now().millisecondsSinceEpoch.toString(),
        currentChatId.value,
        message,
        false,
        Get.find<AuthController>().usermodel.value!.id!);

    db
        .collection("chats/${currentChatId.value}/messages")
        .add(newChat.toMap())
        .then((value) async {
      // currentChat.add(newChat);
      sendingMessage.value = false;

      db.collection("chats").doc(currentChatId.value).set({
        "lastMessage": message,
        "lastMessageTime": DateTime.now().millisecondsSinceEpoch.toString(),
        "lastSender": Get.find<AuthController>().usermodel.value!.id,
        otherUser.id!: FieldValue.increment(1)
      }, SetOptions(merge: true));
      await NotificationApi().sendNotification(
          [otherUser.id],
          "${Get.find<AuthController>().usermodel.value!.firstName}"
              " ${Get.find<AuthController>().usermodel.value!.firstName}",
          message,
          "ChatScreen",
          currentChatId.value);
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
      Inbox allChatsModel = Inbox(
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
