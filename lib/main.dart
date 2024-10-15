import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login.dart'; // 로그인 페이지

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: LoginPage(), // 시작 페이지를 로그인 페이지로 설정
    );
  }
}
