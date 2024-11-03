import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Controller.dart'; // 통합 Controller
import '../serverConfig.dart';
import 'reading_home.dart';

class ReadingTimerPage2 extends StatefulWidget {
  final Duration duration; // 전달된 타이머 값

  ReadingTimerPage2({required this.duration});

  @override
  _ReadingTimerPage2State createState() => _ReadingTimerPage2State();
}

class _ReadingTimerPage2State extends State<ReadingTimerPage2> {
  final Controller controller = Get.find<Controller>();
  final TextEditingController _pageController = TextEditingController();
  final TextEditingController _impressionController = TextEditingController();
  String bookTitle = '도서제목입니다'; // 서버에서 가져올 책 제목
  int cumulativeHours = 0;
  int cumulativeMinutes = 0;
  int cumulativeSeconds = 0;
  bool isCompleted = false; // 완독 여부

  @override
  void initState() {
    super.initState();
    print("ReadingTimerPage2 초기화 - duration: ${widget.duration.inSeconds} seconds");
    getBookTitle();
    getCumulativeReadingTime();
  }

  // 서버에서 도서명을 가져오는 함수
  Future<void> getBookTitle() async {
    final bookId = controller.bookId.value;
    final url = Uri.parse('$SERVER_URL/book/get?id=$bookId');
    print("도서 조회 요청 - URL: $url, bookId: $bookId");

    try {
      final response = await http.get(url);
      print("도서 조회 응답 - 상태 코드: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          bookTitle = data['title'] ?? '도서제목입니다';
        });
        print("도서명 불러오기 성공 - 제목: $bookTitle");
      } else {
        print("서버 오류 - 도서명 불러오기 실패, 상태 코드: ${response.statusCode}");
      }
    } catch (error) {
      print("도서 조회 요청 오류 - $error");
    }
  }

  // 서버에서 누적 독서 시간을 가져오는 함수
  Future<void> getCumulativeReadingTime() async {
    final userId = controller.userId.value;
    final url = Uri.parse('$SERVER_URL/user/get?id=$userId');
    print("누적 독서 시간 조회 요청 - URL: $url, userId: $userId");

    try {
      final response = await http.get(url);
      print("누적 독서 시간 응답 - 상태 코드: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          cumulativeHours = data['cumulativeHours'] ?? 0;
          cumulativeMinutes = data['cumulativeMinutes'] ?? 0;
          cumulativeSeconds = data['cumulativeSeconds'] ?? 0;
        });
        print("누적 독서 시간 불러오기 성공 - $cumulativeHours H $cumulativeMinutes M $cumulativeSeconds S");
      } else {
        print("서버 오류 - 누적 독서 시간 불러오기 실패, 상태 코드: ${response.statusCode}");
      }
    } catch (error) {
      print("누적 독서 시간 요청 오류 - $error");
    }
  }

  // 시간 포맷을 맞추기 위한 함수
  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String formattedTime = "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
    print("타이머 시간 포맷: $formattedTime");
    return formattedTime;
  }

  // 경고창을 띄우는 함수
  void _showAlertDialog() {
    print("경고창 표시 - 필수 필드가 비어 있음");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('\n종료 시점페이지 혹은 독서 후 느낀 점을 입력해주세요.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  // 종료 버튼 눌렀을 때 서버에 데이터를 보내는 함수
  Future<void> _submitReadingData() async {
    final bookId = controller.bookId.value;
    final userId = controller.userId.value;
    final url = Uri.parse('$SERVER_URL/reading/add?bookId=$bookId&userId=$userId&isCompleted=$isCompleted');
    print("리딩 데이터 전송 요청 - URL: $url, bookId: $bookId, userId: $userId, isCompleted: $isCompleted");

    // 읽은 시간 문자열로 변환
    final totalTime = _formatDuration(widget.duration);

    // 서버에 보낼 데이터 구성
    List<String> reviewList = [_impressionController.text];

    Map<String, dynamic> readingData = {
      "total_time": totalTime,
      "end_page": int.parse(_pageController.text),
      "review": reviewList,
    };
    print("전송할 데이터 - $readingData");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(readingData),
      );

      print("리딩 데이터 전송 응답 코드: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("리딩 데이터 저장 성공");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Timer()),
              (route) => false, // 모든 이전 라우트를 제거하여 돌아갈 수 없도록 설정
        );
      } else {
        print("서버 오류 - 리딩 데이터 저장 실패, 상태 코드: ${response.statusCode}");
        Get.snackbar("오류", "리딩 데이터를 저장할 수 없습니다.");
      }
    } catch (error) {
      print("리딩 데이터 전송 오류 - $error");
      Get.snackbar("오류", "네트워크 요청 실패: $error");
    }
  }

  // 종료 버튼 눌렀을 때 처리
  void _onFinishPressed() {
    if (_pageController.text.isEmpty || _impressionController.text.isEmpty) {
      print("필드 미입력 - 종료 시점페이지 또는 독서 후 느낀 점이 비어 있음");
      _showAlertDialog(); // 필드가 비어있으면 경고창 띄우기
    } else {
      print("종료 버튼 클릭 - 데이터 전송 준비 완료");

      if (isCompleted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('축하합니다! 꽃을 얻으셨습니다!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _submitReadingData(); // 데이터 전송
                  },
                  child: Text('확인'),
                ),
              ],
            );
          },
        );
      } else {
        // 완독 여부가 '아니요'인 경우 바로 데이터 전송
        _submitReadingData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD9C6A5), // 상단 배경색
        title: Text('리딩 타이머'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 도서명
            Text(
              '도서명 : $bookTitle',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 70),

            // 타이머 시간 표시
            Center(
              child: Column(
                children: [
                  Text(
                    _formatDuration(widget.duration),
                    style: TextStyle(
                      fontSize: 40,
                      color: Color(0xFF789C49),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '종료되었습니다.\n아래의 정보를 입력해주세요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF789C49),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),
            // 누적 독서 시간
            Text(
              '현재 누적 독서 시간 : $cumulativeHours H $cumulativeMinutes M $cumulativeSeconds S',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 10),

            // 종료 시점 페이지 입력 필드
            Row(
              children: [
                Text(
                  '종료 시점 페이지 : ',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Expanded(
                  child: TextField(
                    controller: _pageController,
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // 독서 후 느낀점 입력 필드
            Text(
              '독서 후 느낀점 :',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _impressionController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            SizedBox(height: 20),

            // 완독 여부 텍스트
            Row(
              children: [
                Text(
                  '이 도서를 완독하셨나요?',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 10),

            // 완독 여부 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isCompleted = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCompleted ? Colors.green[200] : Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                  child: Text(
                    '네!',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isCompleted = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCompleted ? Colors.grey[300] : Colors.red[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                  child: Text(
                    '아니요',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // 리딩 타이머 종료하기 버튼
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: _onFinishPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF1F4E8),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                  side: BorderSide(color: Color(0xFF789C49), width: 1.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  '리딩 타이머 종료하기',
                  style: TextStyle(fontSize: 16, color: Color(0xFF789C49)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
