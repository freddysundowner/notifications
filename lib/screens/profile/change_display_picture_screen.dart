import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/exceptions/local_files_handling/image_picking_exceptions.dart';
import 'package:fluttergistshop/services/firestore_files_access_service.dart';
import 'package:fluttergistshop/services/local_files_access_service.dart';
import 'package:fluttergistshop/services/user_api.dart';
import 'package:fluttergistshop/utils/constants.dart';
import 'package:fluttergistshop/widgets/async_progress_dialog.dart';
import 'package:fluttergistshop/widgets/default_button.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';

class ChageProfileImage extends StatelessWidget {
  AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: Obx(() => Column(
                    children: [
                      Text(
                        "Change Profile Image",
                        style: TextStyle(fontSize: 17),
                      ),
                      SizedBox(height: 40.h),
                      GestureDetector(
                        child: buildDisplayPictureAvatar(context),
                        onTap: () {
                          getImageFromUser(context);
                        },
                      ),
                      SizedBox(height: 80.h),
                      buildChosePictureButton(context),
                      if (authController.chosenImage != null &&
                          authController.chosenImage.path != "")
                        Column(
                          children: [
                            SizedBox(height: 20.h),
                            buildUploadPictureButton(context),
                          ],
                        ),
                      SizedBox(height: 20.h),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );

    // return ChangeNotifierProvider(
    //   create: (context) => ChosenImage(),
    //   child: SafeArea(
    //     child: SingleChildScrollView(
    //       physics: BouncingScrollPhysics(),
    //       child: Padding(
    //         padding: EdgeInsets.symmetric(
    //             horizontal: getProportionateScreenWidth(screenPadding)),
    //         child: SizedBox(
    //           width: double.infinity,
    //           child: Consumer<ChosenImage>(
    //             builder: (context, bodyState, child) {
    //               return Column(
    //                 children: [
    //                   Text(
    //                     "Change Avatar",
    //                     style: headingStyle,
    //                   ),
    //                   SizedBox(height: getProportionateScreenHeight(40)),
    //                   GestureDetector(
    //                     child: buildDisplayPictureAvatar(context, bodyState),
    //                     onTap: () {
    //                       getImageFromUser(context, bodyState);
    //                     },
    //                   ),
    //                   SizedBox(height: getProportionateScreenHeight(80)),
    //                   buildChosePictureButton(context, bodyState),
    //                   SizedBox(height: getProportionateScreenHeight(20)),
    //                   buildUploadPictureButton(context, bodyState),
    //                   SizedBox(height: getProportionateScreenHeight(20)),
    //                   buildRemovePictureButton(context, bodyState),
    //                   SizedBox(height: getProportionateScreenHeight(80)),
    //                 ],
    //               );
    //             },
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget buildDisplayPictureAvatar(BuildContext context) {
    ImageProvider? backImage;
    if (authController.chosenImage != null &&
        authController.chosenImage.path != "") {
      backImage = MemoryImage(authController.chosenImage.readAsBytesSync());
    } else if (authController.currentuser!.profilePhoto != "") {
      final String? url = authController.currentuser!.profilePhoto;
      if (url != null) backImage = NetworkImage(url);
    }
    return backImage == null
        ? Image.asset("assets/icons/profile_placeholder.png",
            width: 0.35.sw, height: 0.16.sh)
        : CircleAvatar(
            radius: 100,
            backgroundColor: Colors.grey,
            backgroundImage: backImage,
          );
    return CircleAvatar(
      radius: 100,
      backgroundColor: Colors.grey,
      backgroundImage: backImage ?? null,
    );
  }

  void getImageFromUser(BuildContext context) async {
    try {
      String path;
      String snackbarMessage = "Image picked";
      path = await choseImageFromLocalFiles(context,
          aspectration: CropAspectRatio(ratioX: 3, ratioY: 2));
      if (path == null) {
        throw LocalImagePickingUnknownReasonFailureException();
      }
      if (path == null) {
        return;
      }
      authController.setChosenImage = File(path);
      if (snackbarMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
    } catch (e) {
    } finally {}
    // bodyState.setChosenImage = File(path);
  }

  Widget buildChosePictureButton(BuildContext context) {
    return DefaultButton(
      text: "Choose Picture",
      press: () {
        getImageFromUser(context);
      },
    );
  }

  Widget buildUploadPictureButton(BuildContext context) {
    return DefaultButton(
      text: "Upload Picture",
      press: () {
        final Future uploadFuture = uploadImageToFirestorage(context);
        showDialog(
          context: context,
          builder: (context) {
            return AsyncProgressDialog(
              uploadFuture,
              message: Text("Updating Display Picture"),
            );
          },
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Display Picture updated")));
      },
    );
  }

  Future<void> uploadImageToFirestorage(BuildContext context) async {
    bool uploadDisplayPictureStatus = false;
    String snackbarMessage = "";
    try {
      final downloadUrl = await FirestoreFilesAccess().uploadFileToPath(
          authController.chosenImage,
          UserAPI().getPathForCurrentUserDisplayPicture());

      print(downloadUrl);

      uploadDisplayPictureStatus =
          await UserAPI.uploadDisplayPictureForCurrentUser(downloadUrl);
      if (uploadDisplayPictureStatus == true) {
        authController.currentuser!.profilePhoto = downloadUrl;
        snackbarMessage = "Display Picture updated successfully";
      } else {
        throw "Coulnd't update display picture due to unknown reason";
      }
    } on FirebaseException catch (e) {
      snackbarMessage = "Something went wrong ${e.toString()}";
    } catch (e) {
      snackbarMessage = "Something went wrong ${e.toString()}";
    } finally {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackbarMessage),
        ),
      );
    }
  }

  Future<void> removeImageFromFirestore(BuildContext context) async {
    bool status = false;
    String snackbarMessage = "";
    try {
      bool fileDeletedFromFirestore = false;
      fileDeletedFromFirestore = await FirestoreFilesAccess()
          .deleteFileFromPath(UserAPI().getPathForCurrentUserDisplayPicture());
      if (fileDeletedFromFirestore == false) {
        throw "Couldn't delete file from Storage, please retry";
      }
      status = await UserAPI.removeDisplayPictureForCurrentUser();
      if (status == true) {
        snackbarMessage = "Picture removed successfully";
      } else {
        throw "Coulnd't removed due to unknown reason";
      }
    } on FirebaseException catch (e) {
      snackbarMessage = "Something went wrong";
    } catch (e) {
      snackbarMessage = "Something went wrong";
    } finally {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackbarMessage),
        ),
      );
    }
  }
}
