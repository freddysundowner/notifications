import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:fluttergistshop/utils/constants.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';

import '../controllers/room_controller.dart';

class DynamicLinkService {

  final RoomController _homeController = Get.find<RoomController>();
  /*
    generate sharing dynamic link
   */
  Future<String> createGroupJoinLink(String groupId, [type]) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: deepLinkUriPrefix,
      link: Uri.parse(_createLink(groupId, type)),
      androidParameters: const AndroidParameters(
        packageName: packagename,
      ),
      // NOT ALL ARE REQUIRED ===== HERE AS AN EXAMPLE =====
      iosParameters: const IOSParameters(
        bundleId: packagename,
        minimumVersion: '3.3',
        appStoreId: '1529768550',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: "GistShop",
      ),
    );
    final ShortDynamicLink dynamicUrl =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    return dynamicUrl.shortUrl.toString();
  }

  /*
      when link is clicked, this function handles the link and redirects user to the app if its installed
      or if its not installed its redirected to the website link attached to firebase dynamic links
   */
  Future handleDynamicLinks() async {

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (data != null) {
      _handleDeepLink(data);
    }


    FirebaseDynamicLinks.instance.onLink.listen(
            (PendingDynamicLinkData dynamicLink) async {
          _handleDeepLink(dynamicLink);
        },
        onError: (error) async {
              printOut("Error FirebaseDynamicLinks.instance.onLink $error");
        });
  }

  /*
      handle dynamic link redirection logic
   */
  Future<void> _handleDeepLink(PendingDynamicLinkData data) async {
    final Uri? deepLink = data.link;
    print("deep link " + deepLink!.queryParameters.toString());
    if (FirebaseAuth.instance.currentUser == null &&
        deepLink.queryParameters['type'] == "room") {
      var groupId = deepLink.queryParameters['groupid'];
      _homeController.joinRoom(groupId!);

    }
  }

  _createLink(String groupId, String type) {
    String link;

      link = '$deepLinkUriPrefix/?groupid=$groupId&type=$type';

    return link;
  }
}
