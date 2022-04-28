import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttergistshop/exceptions/local_files_handling/image_picking_exceptions.dart';
import 'package:fluttergistshop/exceptions/local_files_handling/local_file_handling_exception.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> choseImageFromLocalFiles(BuildContext context,
    {CropAspectRatio aspectRatio = const CropAspectRatio(ratioX: 1, ratioY: 1),
    int maxSizeInKB = 1024,
    int minSizeInKB = 5}) async {
  final PermissionStatus photoPermissionStatus =
      await Permission.photos.request();

  print("photoPermissionStatus.isGranted ${photoPermissionStatus.isGranted}");
  if (!photoPermissionStatus.isGranted) {
    throw LocalFileHandlingStorageReadPermissionDeniedException(
        message: "Permission required to read storage, please give permission");
  }

  final imgSource = await showDialog(
    builder: (context) {
      return AlertDialog(
        title: const Text("Chose image source"),
        actions: [
          FlatButton(
            child: const Text("Camera"),
            onPressed: () {
              Navigator.pop(context, ImageSource.camera);
            },
          ),
          FlatButton(
            child: const Text("Gallery"),
            onPressed: () {
              Navigator.pop(context, ImageSource.gallery);
            },
          ),
        ],
      );
    },
    context: context,
  );


  var imgPicker = ImagePicker();
  if (imgSource == null) {
    throw LocalImagePickingInvalidImageException(
        message: "No image source selected");
  }
  XFile? imagePicked =
      await imgPicker.pickImage(source: imgSource, imageQuality: 40);

  // PickedFile newimagePicked = PickedFile(imagePicked!.path);

  PickedFile newimagePicked = PickedFile((await ImageCropper().cropImage(
          sourcePath: imagePicked!.path,
          aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 2),
          cropStyle: CropStyle.circle))!
      .path);

  if (newimagePicked == null) {
    throw LocalImagePickingInvalidImageException();
  } else {
    final fileLength = await File(newimagePicked.path).length();
    if (fileLength > (maxSizeInKB * 1024) ||
        fileLength < (minSizeInKB * 1024)) {
      throw LocalImagePickingFileSizeOutOfBoundsException(
          message: "Image size should not exceed 1MB");
    } else {
      return newimagePicked.path;
    }
  }
}
