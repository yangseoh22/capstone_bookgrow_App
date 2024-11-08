import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Controller.dart';
import '../custom_bottom_nav.dart';
import 'reading_selection1.dart';
import 'reading_timer1.dart';
import '../serverConfig.dart';

class Timer extends StatefulWidget {
  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  final Controller controller = Get.find<Controller>();
  List<Map<String, dynamic>> books = []; // 진행 중인 도서 목록을 저장할 리스트

  @override
  void initState() {
    super.initState();
    fetchReadingBooks(); // 진행 중인 도서 목록 가져오기
  }

  // 서버에서 진행 중인 도서 목록을 가져오는 함수
  Future<void> fetchReadingBooks() async {
    final userId = controller.userId.value;
    final url = Uri.parse('$SERVER_URL/reading/get?userId=$userId');
    print("진행 중인 도서 목록 요청 URL: $url");

    try {
      final response = await http.get(url);
      print("진행 중인 도서 목록 응답 상태 코드: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          books = data.map((book) {
            return {
              'bookId': book['bookId'],
              'title': book['title'],
              'image_url': book['image_url'],
              'current_page': book['current_page'] ?? 0,
              'total_page': book['total_page'] ?? 1,
            };
          }).toList();
        });
        print("진행 중인 도서 목록이 성공적으로 불러와졌습니다.");
      } else {
        Get.snackbar("오류", "진행 중인 도서 목록을 불러오지 못했습니다.");
        print("서버 오류로 인해 진행 중인 도서 목록을 불러오지 못했습니다.");
      }
    } catch (error) {
      print("진행 중인 도서 목록 요청 오류 발생: $error");
      Get.snackbar("오류", "네트워크 요청 실패: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Text(
              '독서 모드',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF789C49), // 초록색 텍스트
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReadingSelectionPage1()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF1F4E8),
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                  side: BorderSide(color: Color(0xFF789C49)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                icon: Icon(Icons.timer, color: Color(0xFF789C49), size: 50),
                label: Text(
                  '리딩 타이머\n도서 선택하기',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF789C49),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              '독서 진행 중인 도서',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  final progress = (book['current_page'] / book['total_page']).clamp(0.0, 1.0);

                  final imageUrl = (book['image_url'] == null || book['image_url'] == 'http://cover.nl.go.kr/')
                      ? 'assets/images/img_none.png'
                      : book['image_url'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 60,
                            color: Colors.grey,
                            child: imageUrl == 'assets/images/img_none.png'
                                ? Image.asset(imageUrl)
                                : Image.network(imageUrl, fit: BoxFit.cover),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book['title'] ?? '제목 없음',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 10),
                                LinearProgressIndicator(
                                  value: progress,
                                  color: Color(0xFF789C49),
                                  backgroundColor: Colors.grey[300],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(
                              Icons.timer,
                              color: Color(0xFF789C49),
                              size: 30,
                            ),
                            onPressed: () {
                              // 선택한 책의 bookId가 null이 아닐 때만 Controller에 업데이트
                              if (book['bookId'] != null) {
                                controller.bookId.value = book['bookId'];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ReadingTimerPage1()),
                                );
                              } else {
                                // bookId가 null일 경우 오류 메시지 표시
                                Get.snackbar("오류", "선택한 책의 ID를 찾을 수 없습니다.");
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
    );
  }
}
