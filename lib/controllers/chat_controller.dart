import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttergistshop/models/all_chats_model.dart';
import 'package:fluttergistshop/models/chat_room_model.dart';
import 'package:fluttergistshop/models/room_model.dart';
import 'package:fluttergistshop/models/user.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

import 'auth_controller.dart';

class ChatController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String userId = Get.find<AuthController>().usermodel.value!.id!;
  var allUserChats = [].obs;
  var gettingChats = false.obs;
  var currentChatLoading = false.obs;
  var currentChat = [].obs;
  var currentChatUsers = [].obs;
  var currentChatId = "".obs;

  @override
  void onInit() {
    getUserChats();
    super.onInit();
  }

  getUserChats() {
    gettingChats.value = true;

    db
        .collection("chats")
        .where("userIds", arrayContains: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      gettingChats.value = false;

      printOut("Chats loaded ${querySnapshot.docs.length}");

      for (var i = 0; i < querySnapshot.docs.length; i++) {
        DocumentSnapshot snapshot = querySnapshot.docs.elementAt(i);

        AllChatsModel allChatsModel = AllChatsModel(
            snapshot.id,
            snapshot.get("chatTitle"),
            snapshot.get("imageUrl"),
            snapshot.get("lastMessage"),
            snapshot.get("lastMessageTime"),
            snapshot.get("lastSender"),
            snapshot.get("userIds"),
            snapshot.get("users"));

        allUserChats.add(allChatsModel);
      }
    }).onError((error, stackTrace) {
      gettingChats.value = false;
      printOut("Error getting all chats $error $stackTrace");
    });
  }

  getChatById(String id) {
    currentChatLoading.value = true;

    db.collection("chats/$id/messages").get().then((QuerySnapshot snapshot) {
      for (var i = 0; i < snapshot.docs.length; i++) {
        DocumentSnapshot documentSnapshot = snapshot.docs.elementAt(i);

        ChatRoomModel chatRoomModel = ChatRoomModel(
            documentSnapshot.get("date"),
            documentSnapshot.id,
            documentSnapshot.get("message"),
            documentSnapshot.get("seen"),
            documentSnapshot.get("sender"));
        currentChat.add(chatRoomModel);
      }
    });

    db.collection("chats/$id/users").get().then((QuerySnapshot snapshot) {
      for (var i = 0; i < snapshot.docs.length; i++) {
        DocumentSnapshot documentSnapshot = snapshot.docs.elementAt(i);

        UserModel userModel = UserModel.fromPlayer(
            documentSnapshot.id,
            documentSnapshot.get("firstName"),
            documentSnapshot.get("lastName"),
            documentSnapshot.get("bio"),
            documentSnapshot.get("userName"),
            documentSnapshot.get("phonenumber"),
            documentSnapshot.get("profilePhoto"));

        currentChatUsers.add(userModel);

        currentChatLoading.value = false;
      }
    });
  }

  getPreviousChat(OwnerId otherUser) {
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

  sendMessage(String message, OwnerId otherUser) {
    if (currentChatId.value == "") {
      String genId = db.collection("chats").doc().id;
      currentChatId.value = genId;

      //Create a new chat
      createChat(message, otherUser);

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
        .then((value) {
      currentChat.add(newChat);
      printOut("Chat message saved");
    });
  }

  void createChat(String message, OwnerId otherUser) {
    UserModel currentUser = Get.find<AuthController>().usermodel.value!;
    //Create a new chat
    AllChatsModel allChatsModel = AllChatsModel(currentChatId.value, "", "",
        message, DateTime.now().millisecondsSinceEpoch.toString(), userId,
        [currentUser.id, otherUser.id],
        [
          {
                "id": currentUser.id,
                "firstName": currentUser.firstName,
                "lastName": currentUser.lastName,
                "userName": currentUser.userName,
                "profilePhoto": currentUser.profilePhoto},

        {
                "id": otherUser.id,
                "firstName": otherUser.firstName,
                "lastName": otherUser.lastName,
                "userName": otherUser.userName,
                "profilePhoto": otherUser.profilePhoto}

    ]);

    printOut("New being saved ${allChatsModel.toMap()}");
    db.collection("chats").doc(currentChatId.value).set(allChatsModel.toMap()).then((value) {
      printOut("Chat saved successfully ");
    });
  }
}
