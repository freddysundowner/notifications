

import 'package:flutter/foundation.dart';

printOut(data) {
  if (kDebugMode) {
    print(data);
  }
}

String convertTime(String time) {
  var convertedTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
  var timeDifference ="${convertedTime.day}/${convertedTime.month}/${convertedTime.year}";

  var diff = DateTime.now().difference(convertedTime);

  if (diff.inMinutes < 1) {
    timeDifference = "now";
  } else if (diff.inHours < 1) {
    timeDifference = "${diff.inMinutes} minutes ago";
  } else if (diff.inHours <= 24) {
    timeDifference = "${diff.inHours} hours ago";
  } else if (diff.inHours <= 47) {
    timeDifference = "${diff.inDays} day ago";
  } else if (diff.inHours > 48) {
    timeDifference = "${diff.inDays} days ago";
  }

  return timeDifference;
}

String showActualTime(String time) {
  var convertedTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
  var timeDifference ="${convertedTime.hour}:${convertedTime.minute}  "
      "${convertedTime.day}/${convertedTime.month}/${convertedTime.year}";

  return timeDifference;
}
