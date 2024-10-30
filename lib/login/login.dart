import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Controller/UserController.dart';
import '../mybooks/mybooks.dart'; // 나의 도서 페이지
import 'signup.dart'; // 회원가입 페이지
import '../serverConfig.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _loginUser() async {
    final id = _idController.text.trim();
    final password = _passwordController.text.trim();

    print("로그인 시도: ID=$id, Password=$password");

    // 필드 유효성 검사 로그
    if (id.isEmpty || password.isEmpty) {
      print("유효성 검사 실패: ID 또는 비밀번호가 비어 있음");
      Get.snackbar("오류", "ID와 비밀번호를 입력해주세요.");
      return;
    }

    // 쿼리 파라미터로 아이디와 비밀번호를 포함한 URL
    final url = Uri.parse("$SERVER_URL/user/login?registerId=$id&password=$password");
    print("로그인 요청 URL: $url");

    try {
      // 쿼리 파라미터 방식으로 요청 보내기
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
      );

      print("서버 응답 코드: ${response.statusCode}");
      print("서버 응답 본문: ${utf8.decode(response.bodyBytes)}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("서버 응답 데이터 (파싱 완료): $responseData");

        if (responseData['success'] == true) {
          final userId = responseData['user']['id'];
          print("로그인 성공 - userId: $userId");

          // UserController에 userId 저장
          final userController = Get.find<UserController>();
          userController.setUserId(userId);
          print("UserController에 userId 설정 완료");

          Get.snackbar("성공", "로그인 성공!");
          Get.to(() => MyBooks());
        } else {
          print("로그인 실패 - ID 또는 비밀번호 불일치");
          Get.snackbar("오류", "ID 또는 비밀번호가 일치하지 않습니다.");
        }
      } else {
        print("로그인 실패 - 서버 에러 발생");
        Get.snackbar("오류", "로그인 실패. 다시 시도해주세요.");
      }
    } catch (error) {
      print("로그인 요청 중 오류 발생: $error");
      Get.snackbar("오류", "네트워크 요청 실패: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("LoginPage 위젯 빌드 시작");
    return Scaffold(
      backgroundColor: Color(0xFFF0E3C0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Book Grow',
                style: TextStyle(
                  color: Color(0xFF789C49),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'ID',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (text) {
                  print("ID 입력 변경: $text"); // ID 입력 시 실시간 로그
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (text) {
                  print("Password 입력 변경: $text"); // Password 입력 시 실시간 로그
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  print("로그인 버튼 클릭됨");
                  _loginUser(); // 로그인 버튼 클릭 시 로그인 함수 호출
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF789C49),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  '로그인',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  print("회원가입 버튼 클릭됨");
                  Get.to(() => SignUpPage()); // 회원가입 페이지로 이동
                },
                child: Text(
                  '회원가입',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
