import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login/login.dart'; // 로그인 페이지

// fork test code

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/login', // 초기 경로를 /login으로 설정
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()), // 로그인 페이지
      ],
    );
  }
}
