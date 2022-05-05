import 'client.dart';

class ApiCalls {
  static saveUserData(data) async {
    var response =
        await DbBase().databaseRequest(DbBase().postRequestType, body: data);
    return response;
  }
}
