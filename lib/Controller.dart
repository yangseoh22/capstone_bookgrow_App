import 'package:get/get.dart';

class Controller extends GetxController {
  RxInt userId = 0.obs;
  RxInt bookId = 0.obs;
  RxString recognizedEmotion = ''.obs;

  void setUserId(int id) {
    userId.value = id;
  }

  void setBookId(int id) {
    bookId.value = id;
  }

  void setEmotion(String emotion) {
    recognizedEmotion.value = emotion;
  }
}
