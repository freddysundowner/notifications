import 'dart:convert';

import 'client.dart';
import 'end_points.dart';

class ActivitiesAPI {
  getAllUserActivities(String uid) async {
    var activities = await DbBase()
        .databaseRequest(userActivities + uid, DbBase().getRequestType);

    return jsonDecode(activities);
  }
}
