import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImageUploadFirebase {
  static Future<List<String>> uploadImages(List<File> imageFiles) async {
    List<String> imageUrls = [];
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("User is not authenticated");
      return imageUrls;
    }

    try {
      for (File imageFile in imageFiles) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('users/${user.uid}/images/$fileName.jpg');

        UploadTask uploadTask = storageReference.putFile(imageFile);
        await uploadTask.whenComplete(() async {
          String imageUrl = await storageReference.getDownloadURL();
          imageUrls.add(imageUrl);
        });
      }
    } catch (error) {
      print("Error uploading images: $error");
    }

    return imageUrls;
  }
}
