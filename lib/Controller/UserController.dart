import 'package:get/get.dart';

class UserController extends GetxController {
  var userId = 0.obs; // userId를 Observable로 선언하여 reactive하게 만듦

  void setUserId(int id) {
    userId.value = id; // userId를 설정하는 함수
  }
}
