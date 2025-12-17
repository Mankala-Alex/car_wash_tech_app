import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CarStatusController extends GetxController {
  final ImagePicker picker = ImagePicker();

  var beforePhotos = <File>[].obs;
  var afterPhotos = <File>[].obs;

  Future<void> pickBeforeImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      beforePhotos.add(File(image.path));
    }
  }

  Future<void> pickAfterImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      afterPhotos.add(File(image.path));
    }
  }

  void removeBefore(int index) {
    beforePhotos.removeAt(index);
  }

  void removeAfter(int index) {
    afterPhotos.removeAt(index);
  }
}
