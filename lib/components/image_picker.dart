import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  final ImagePicker _imagePicker = ImagePicker();

  Future<File?> takePhoto() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }

    return null;
  }

  Future<File?> pickImageFromGallery() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }

    return null;
  }
}
