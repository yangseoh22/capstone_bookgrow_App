import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../mybooks/mybooks.dart'; // 나의 도서 페이지
import 'signup.dart'; // 회원가입 페이지
import '../serverConfig.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _loginUser() async {
    final id = _idController.text.trim();
    final password = _passwordController.text.trim();

    // ID와 비밀번호가 입력되었는지 확인
    if (id.isEmpty || password.isEmpty) {
      Get.snackbar("오류", "ID와 비밀번호를 입력해주세요.");
      return;
    }

    // URL에 쿼리 파라미터로 ID와 비밀번호 추가
    final url = Uri.parse("$SERVER_URL/user/login?registerId=$id&password=$password");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
      );

      print("로그인 응답 상태 코드: ${response.statusCode}");
      print("로그인 응답 본문: ${utf8.decode(response.bodyBytes)}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          Get.snackbar("성공", "로그인 성공. 환영합니다!");
          Get.to(() => MyBooks()); // 로그인 성공 시 '나의 도서' 페이지로 이동
        } else {
          Get.snackbar("오류", "ID 또는 비밀번호가 일치하지 않습니다.");
        }
      } else {
        Get.snackbar("오류", "로그인 실패. 다시 시도해주세요.");
      }
    } catch (error) {
      print("로그인 요청 오류 발생: $error");
      Get.snackbar("오류", "네트워크 요청 실패: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
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
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _loginUser, // 로그인 버튼 클릭 시 _loginUser 호출
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
