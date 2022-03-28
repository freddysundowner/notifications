import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttergistshop/models/user_model.dart';

class AllChatsModel {
  String id;
  String lastMessage;
  String lastMessageTime;
  String lastSender;
  List<dynamic> userIds;
  List<dynamic> users;
  int unread;

  AllChatsModel(this.id, this.lastMessage,
      this.lastMessageTime, this.lastSender, this.userIds, this.users, this.unread);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'lastSender': lastSender,
      'userIds': userIds,
      'users': users,
    };
  }

  factory AllChatsModel.fromMap(Map<String, dynamic> map) {
    return AllChatsModel(
      map['id'] as String,
      map['chatTitle'] as String,
      map['imageUrl'] as String,
      map['lastMessage'] as String,
      map['userIds'] as List<dynamic>,
      map['users'] as List<UserModel>,
      map[FirebaseAuth.instance.currentUser!.uid] as int
    );
  }
}