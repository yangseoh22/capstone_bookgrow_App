import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../serverConfig.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  bool registerIdAvailable = false; // 중복 확인 결과를 저장하는 변수
  bool registerButtonEnabled = false; // 회원가입 버튼 활성화 여부

  @override
  void initState() {
    super.initState();
    _idController.addListener(_checkFieldsFilled);
    _passwordController.addListener(_checkFieldsFilled);
    _passwordConfirmController.addListener(_checkFieldsFilled);
    _nameController.addListener(_checkFieldsFilled);
    _nicknameController.addListener(_checkFieldsFilled);
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nameController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  // 모든 필드가 입력되었는지 확인
  void _checkFieldsFilled() {
    setState(() {
      registerButtonEnabled = _idController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _passwordConfirmController.text.isNotEmpty &&
          _nameController.text.isNotEmpty &&
          _nicknameController.text.isNotEmpty &&
          registerIdAvailable;
    });
  }

  // 유효성 검사 함수
  bool _validateFields() {
    if (_idController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _passwordConfirmController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _nicknameController.text.isEmpty) {
      Get.snackbar("오류", "모든 필드를 입력해주세요.");
      return false;
    }
    if (_passwordController.text != _passwordConfirmController.text) {
      Get.snackbar("오류", "비밀번호와 비밀번호 확인이 일치하지 않습니다.");
      return false;
    }
    return true;
  }

  // 서버로 회원가입 요청
  Future<void> _registerUser() async {
    if (!registerButtonEnabled) {
      Get.snackbar("오류", "아이디 중복 확인을 완료해주세요.");
      return;
    }
    if (!_validateFields()) {
      return; // 유효성 검사에 실패하면 회원가입 요청 중단
    }

    final registerId = _idController.text;
    final password = _passwordController.text;
    final name = _nameController.text;
    final nickname = _nicknameController.text;

    print("회원가입 요청 데이터: $registerId, $password, $name, $nickname");

    final url = Uri.parse(
        "$SERVER_URL/user/signup?register_id=$registerId&password=$password&name=$name&nickname=$nickname");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
      );

      print("응답 상태 코드: ${response.statusCode}");
      print("응답 본문: ${utf8.decode(response.bodyBytes)}");

      if (response.statusCode == 200) {
        Get.snackbar("성공", "회원가입이 완료되었습니다!");
        Get.offNamed('/login');
      } else {
        Get.snackbar("오류", "회원가입 실패. 다시 시도해주세요.");
      }
    } catch (error) {
      print("오류 발생: $error");
      Get.snackbar("오류", "네트워크 요청 실패: $error");
    }
  }

  // 중복 확인 요청
  Future<void> _checkDuplicateId() async {
    final registerId = _idController.text;

    if (registerId.isEmpty) {
      Get.snackbar("오류", "아이디를 입력해주세요.");
      return;
    }

    final url = Uri.parse("$SERVER_URL/user/checkId?register_id=$registerId");

    try {
      final response = await http.get(url);

      print("중복확인 응답 상태 코드: ${response.statusCode}");
      print("중복확인 응답 본문: ${utf8.decode(response.bodyBytes)}");

      if (response.statusCode == 200) {
        final isAvailable = response.body == 'false';
        setState(() {
          registerIdAvailable = isAvailable;
          _checkFieldsFilled(); // 중복 확인 후 필드 상태 다시 확인
        });

        if (isAvailable) {
          Get.snackbar("확인", "사용 가능한 아이디입니다.");
        } else {
          Get.snackbar("오류", "이미 사용 중인 아이디입니다.");
        }
      } else {
        Get.snackbar("오류", "중복 확인 실패. 다시 시도해주세요.");
      }
    } catch (error) {
      print("중복 확인 요청 오류 발생: $error");
      Get.snackbar("오류", "네트워크 요청 실패: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF0E3C0),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              'Book Grow',
              style: TextStyle(
                color: Color(0xFF789C49),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '회원가입',
              style: TextStyle(
                color: Color(0xFF789C49),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                      labelText: '아이디',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _checkDuplicateId, // 중복 확인 로직 추가
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF789C49),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    '중복확인',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordConfirmController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호 확인',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '이름',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                labelText: '닉네임',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: registerButtonEnabled ? _registerUser : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: registerButtonEnabled ? Color(0xFF789C49) : Colors.grey,
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                '회원가입',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                '취소',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
