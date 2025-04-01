import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static ImagePicker imagePicker = ImagePicker();

  static Future<File?> choosePhoto(ImageSource source) async {
    try {
      final photo =
          await imagePicker.pickImage(source: source, imageQuality: 100);

      if (photo != null) {
        return File(photo.path);
      }

      return null;
    } on Exception {
      throw const PhotoPickerException();
    }
  }

  static Future<List<File>> choosePhotos() async {
    try {
      final photos = await imagePicker.pickMultiImage(imageQuality: 100);

      if (photos.isNotEmpty) {
        return photos.map((XFile photo) => File(photo.path)).toList();
      }

      return [];
    } on Exception {
      throw const PhotoPickerException();
    }
  }
}

class PhotoPickerException implements Exception {
  const PhotoPickerException();
}
