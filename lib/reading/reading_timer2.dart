import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Controller.dart'; // 통합 Controller
import '../serverConfig.dart';
import 'reading_home.dart';

class ReadingTimerPage2 extends StatefulWidget {
  final Duration duration;

  ReadingTimerPage2({required this.duration});

  @override
  _ReadingTimerPage2State createState() => _ReadingTimerPage2State();
}

class _ReadingTimerPage2State extends State<ReadingTimerPage2> {
  final Controller controller = Get.find<Controller>();
  final TextEditingController _pageController = TextEditingController();
  final TextEditingController _impressionController = TextEditingController();
  String bookTitle = '도서제목입니다';
  int cumulativeHours = 0;
  int cumulativeMinutes = 0;
  int cumulativeSeconds = 0;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    getBookTitle();
    getCumulativeReadingTime();
  }

  Future<void> getBookTitle() async {
    final bookId = controller.bookId.value;
    final url = Uri.parse('$SERVER_URL/book/get?id=$bookId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          bookTitle = data['title'] ?? '도서제목입니다';
        });
      }
    } catch (error) {
      print("도서 조회 요청 오류 - $error");
    }
  }

  Future<void> getCumulativeReadingTime() async {
    final userId = controller.userId.value;
    final url = Uri.parse('$SERVER_URL/user/get?id=$userId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          cumulativeHours = data['cumulativeHours'] ?? 0;
          cumulativeMinutes = data['cumulativeMinutes'] ?? 0;
          cumulativeSeconds = data['cumulativeSeconds'] ?? 0;
        });
      }
    } catch (error) {
      print("누적 독서 시간 요청 오류 - $error");
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

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

  Future<void> _submitReadingData() async {
    final bookId = controller.bookId.value;
    final userId = controller.userId.value;
    final url = Uri.parse('$SERVER_URL/reading/add?bookId=$bookId&userId=$userId');

    final totalTime = _formatDuration(widget.duration);

    List<String> reviewList = [_impressionController.text];

    Map<String, dynamic> readingData = {
      "read_time": totalTime,
      "start_page": null,
      "end_page": int.parse(_pageController.text),
      "review": reviewList,
      "isCompleted": isCompleted
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(readingData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final isDominationIncreased = data["isDominationIncreased"] ?? false;

        if (isDominationIncreased) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('축하합니다, 기부 가능 횟수가 증가하였습니다!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('확인'),
                  ),
                ],
              );
            },
          );
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Timer()),
              (route) => false,
        );
      } else {
        Get.snackbar("오류", "리딩 데이터를 저장할 수 없습니다.");
      }
    } catch (error) {
      Get.snackbar("오류", "네트워크 요청 실패: $error");
    }
  }

  void _onFinishPressed() {
    if (_pageController.text.isEmpty || _impressionController.text.isEmpty) {
      _showAlertDialog();
    } else {
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
                    _submitReadingData();
                  },
                  child: Text('확인'),
                ),
              ],
            );
          },
        );
      } else {
        _submitReadingData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD9C6A5),
        title: Text('리딩 타이머'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '도서명 : $bookTitle',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 70),
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
            Text(
              '현재 누적 독서 시간 : $cumulativeHours H $cumulativeMinutes M $cumulativeSeconds S',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 10),
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
            Row(
              children: [
                Text(
                  '이 도서를 완독하셨나요?',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 10),
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
