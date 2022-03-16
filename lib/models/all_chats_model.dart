class AllChatsModel {
  String id;
  String? sender;
  String message;
  String date;
  String userName;
  bool seen;

  AllChatsModel(
      this.id, this.sender, this.message, this.date, this.userName, this.seen);
}