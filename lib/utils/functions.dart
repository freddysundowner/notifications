import 'package:flutter/foundation.dart';

printOut(data) {
  if (kDebugMode) {
    print(data);
  }
}

String convertTime(String time) {
  var convertedTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
  var timeDifference =
      "${convertedTime.day}/${convertedTime.month}/${convertedTime.year}";

  var diff = DateTime.now().difference(convertedTime);

  if (diff.inMinutes < 1) {
    timeDifference = "now";
  } else if (diff.inHours < 1) {
    timeDifference = "${diff.inMinutes} minutes ago";
  } else if (diff.inDays < 1) {
    timeDifference = "${diff.inHours} hours ago";
  } else if (diff.inDays == 2) {
    timeDifference = "${convertedTime.hour}:${convertedTime.minute} yesterday";
  } else if (diff.inDays > 2) {
    timeDifference =
        "${convertedTime.hour}:${convertedTime.minute} "
            "${convertedTime.day}/${convertedTime.month}/${convertedTime.year}";
  }

  return timeDifference;
}
