import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Controller.dart';
import '../custom_bottom_nav.dart';
import '../login/login.dart';
import '../serverConfig.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Controller controller = Get.find<Controller>();

  // 유저 정보 초기값 설정
  String name = '이름을 불러오는 중...';
  String nickname = '닉네임을 불러오는 중...';
  String registerId = '아이디를 불러오는 중...';
  String password = '**********';
  double averagePagesPerDay = 0.0;
  double timePerPage = 0.0;
  int owned = 0;
  int complete = 0;
  int flower = 0;
  int domination = 0;
  int cumulativeHours = 0;
  int cumulativeMinutes = 0;
  int cumulativeSeconds = 0;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchHabitData();
  }

  // 서버에서 유저 데이터를 가져오는 함수
  Future<void> fetchUserData() async {
    final userId = controller.userId.value;
    final url = Uri.parse('$SERVER_URL/user/get?id=$userId');
    print("유저 데이터 요청 URL: $url");

    try {
      final response = await http.get(url);
      print("응답 상태 코드: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          name = data['name'] ?? '이름 없음';
          nickname = data['nickname'] ?? '닉네임 없음';
          registerId = data['registerId'] ?? '아이디 없음';
          owned = data['owned'] ?? 0;
          complete = data['complete'] ?? 0;
          flower = data['flower'] ?? 0;
          domination = data['domination'] ?? 0;
          cumulativeHours = data['cumulativeHours'] ?? 0;
          cumulativeMinutes = data['cumulativeMinutes'] ?? 0;
          cumulativeSeconds = data['cumulativeSeconds'] ?? 0;

          // Log each value for debugging
          print("User data fetched successfully:");
          print("Name: $name");
          print("Nickname: $nickname");
          print("Register ID: $registerId");
          print("Owned Books: $owned");
          print("Completed Books: $complete");
          print("Flowers: $flower");
          print("Domination Count: $domination");
          print("Cumulative Time: ${cumulativeHours}H ${cumulativeMinutes}M ${cumulativeSeconds}S");
        });
      } else {
        Get.snackbar("오류", "유저 데이터를 불러올 수 없습니다.");
      }
    } catch (error) {
      print("유저 데이터 요청 오류: $error");
      Get.snackbar("오류", "네트워크 요청 실패: $error");
    }
  }

  // 서버에서 유저의 독서 습관 데이터를 가져오는 함수
  Future<void> fetchHabitData() async {
    final userId = controller.userId.value;
    final url = Uri.parse('$SERVER_URL/habit/get?userId=$userId');
    print("독서 습관 요청 URL: $url");

    try {
      final response = await http.get(url);
      print("독서 습관 응답 상태 코드: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          averagePagesPerDay = data['averagePagesPerDay'] ?? 0.0;
          timePerPage = data['timePerPage'] ?? 0.0;

          print("Habit data fetched successfully:");
          print("Average Pages Per Day: $averagePagesPerDay");
          print("Time Per Page: $timePerPage seconds");
        });
      } else {
        Get.snackbar("오류", "독서 습관 데이터를 불러올 수 없습니다.");
      }
    } catch (error) {
      print("독서 습관 요청 오류: $error");
      Get.snackbar("오류", "네트워크 요청 실패: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text(
              '마이페이지',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF789C49),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              width: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF789C49)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('회원정보', style: TextStyle(color: Color(0xFF789C49), fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('이름: $name'),
                  Text('닉네임: $nickname'),
                  Text('아이디: $registerId'),
                  Text('비밀번호: $password'),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // 로그아웃 버튼 눌렀을 때 로그인 페이지로 이동
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF789C49),
                      ),
                      child: Text('로그아웃', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              width: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF789C49)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('나의 독서 습관', style: TextStyle(color: Color(0xFF789C49), fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('누적 독서 시간: $cumulativeHours H $cumulativeMinutes M $cumulativeSeconds S'),
                  Text('일별 평균 독서 쪽 수: ${averagePagesPerDay.toStringAsFixed(1)}쪽'),
                  Text('쪽별 독서 소요 시간: ${timePerPage.toStringAsFixed(2)}초'),
                  Text('소지 도서 수: $owned권'),
                  Text('완독 도서 수: $complete권'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              width: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF789C49)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('나의 꽃', style: TextStyle(color: Color(0xFF789C49), fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text('획득한 꽃: $flower송이'),
                        Text('기부 횟수: $domination번'),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.help_outline, color: Colors.grey),
                    onPressed: () {
                      _showInfoDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 3),
    );
  }

  // 알림창 표시 함수
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('기부 프로젝트'),
          content: Text('획득한 꽃의 수가 3의 배수가 될 때마다 지역 도서관에 기부가 진행됩니다. 자세한 기부 상황을 보려면, http://doseagwan.giboo를 참고하세요.'),
          actions: [
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
