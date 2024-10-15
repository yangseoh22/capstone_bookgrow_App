import 'package:flutter/material.dart';
import 'reading_home.dart';

class ReadingTimerPage2 extends StatefulWidget {
  final Duration duration; // 전달된 타이머 값

  ReadingTimerPage2({required this.duration});

  @override
  _ReadingTimerPage2State createState() => _ReadingTimerPage2State();
}

class _ReadingTimerPage2State extends State<ReadingTimerPage2> {
  // 입력 컨트롤러
  final TextEditingController _pageController = TextEditingController();
  final TextEditingController _impressionController = TextEditingController();

  // 시간 포맷을 맞추기 위한 함수
  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  // 경고창을 띄우는 함수
  void _showAlertDialog() {
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

  // 종료 버튼 눌렀을 때 처리
  void _onFinishPressed() {
    if (_pageController.text.isEmpty || _impressionController.text.isEmpty) {
      _showAlertDialog(); // 필드가 비어있으면 경고창 띄우기
    } else {
      // 필드가 모두 입력된 경우 홈으로 이동
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Timer()),
            (route) => false, // 모든 이전 라우트를 제거하여 돌아갈 수 없도록 설정
      );
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
              '도서명 : 도서제목입니다',
              style: TextStyle(fontSize: 16, color: Colors.grey),
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
              '이 도서의 누적 독서 시간 : 00: 00 : 00',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 10),

            // 종료 시점 페이지 입력 필드
            Row(
              children: [
                Text(
                  '종료 시점 페이지 : ',
                  style: TextStyle(fontSize: 14),
                ),
                Expanded(
                  child: TextField(
                    controller: _pageController,
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // 독서 후 느낀점 입력 필드
            Text(
              '독서 후 느낀점 :',
              style: TextStyle(fontSize: 14),
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
