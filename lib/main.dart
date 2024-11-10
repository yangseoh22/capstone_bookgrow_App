import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Controller.dart';
import 'login/login.dart'; // 로그인 페이지

void main() {
  Get.put(Controller()); // UserController를 전역으로 등록
  Get.put(Controller()); // UserController 인스턴스를 GetX에 등록
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
      theme: ThemeData(
        // 글꼴을 전체적으로 적용
        fontFamily: 'MyFont', // 적용할 글꼴 이름
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontFamily: 'MyFont'),  // bodyLarge 사용
          bodyMedium: TextStyle(fontFamily: 'MyFont'),  // bodyMedium 사용
        ),
      ),
    );
  }
}
