import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirestoreFilesAccess {
  Future<String> uploadFileToPath(File file, String path) async {
    final Reference firestorageRef = FirebaseStorage.instance.ref();
    final snapshot = await firestorageRef.child(path).putFile(file);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  //fff

  Future<bool> deleteFileFromPath(String path) async {
    final Reference firestorageRef = FirebaseStorage.instance.ref();
    await firestorageRef.child(path).delete();
    return true;
  }

  Future<String> getDeveloperImage() async {
    const filename = "about_developer/developer";
    List<String> extensions = <String>["jpg", "jpeg", "jpe", "jfif"];
    final Reference firestorageRef = FirebaseStorage.instance.ref();
    for (final ext in extensions) {
      try {
        final url =
            await firestorageRef.child("$filename.$ext").getDownloadURL();
        return url;
      } catch (_) {
        continue;
      }
    }
    throw FirebaseException(
        message: "No JPEG Image found for Developer",
        plugin: 'Firebase Storage');
  }
}
