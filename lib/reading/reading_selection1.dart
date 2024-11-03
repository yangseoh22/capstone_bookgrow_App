import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Controller.dart'; // 통합 Controller
import '../serverConfig.dart';
import 'reading_selection2.dart';

class ReadingSelectionPage1 extends StatefulWidget {
  @override
  _ReadingSelectionPage1State createState() => _ReadingSelectionPage1State();
}

class _ReadingSelectionPage1State extends State<ReadingSelectionPage1> {
  final Controller controller = Get.find<Controller>();
  List<String> categories = ['전체', '소설', '비소설', '과학', '기타'];
  String dropdownValue = '전체';
  List<Map<String, dynamic>> books = []; // 도서 목록을 저장할 리스트

  @override
  void initState() {
    super.initState();
    fetchBooks(); // 도서 목록 불러오기
  }

  // 서버에서 도서 목록을 가져오는 함수
  Future<void> fetchBooks() async {
    final userId = controller.userId.value;
    final url = Uri.parse('$SERVER_URL/book/getAll?userId=$userId');
    print("도서 목록 요청 URL: $url"); // URL 로그

    try {
      final response = await http.get(url);
      print("도서 목록 응답 상태 코드: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          books = data.map((book) {
            print("도서 데이터: $book");
            return {
              'id': book['id'],
              'title': book['title'],
              'image_url': book['image_url'],
            };
          }).toList();
        });
        print("도서 목록이 성공적으로 불러와졌습니다. 총 ${books.length}권");
      } else {
        Get.snackbar("오류", "도서 목록을 불러오지 못했습니다.");
        print("서버 오류로 인해 도서 목록을 불러오지 못했습니다.");
      }
    } catch (error) {
      print("도서 목록 요청 오류 발생: $error");
      Get.snackbar("오류", "네트워크 요청 실패: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Text(
              '리딩 타이머',
              style: TextStyle(
                color: Color(0xFF789C49), // 초록색 텍스트
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '읽을 도서를 선택하세요.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF789C49),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 100),
                Text(
                  '카테고리',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 30),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_drop_down),
                  items: categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                      print("선택된 카테고리: $dropdownValue");
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return GestureDetector(
                    onTap: () {
                      print("선택된 도서 ID: ${book['id']}");
                      controller.bookId.value = book['id'];  // bookId를 controller에 저장
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReadingSelectionPage2()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey), // 위쪽 테두리
                          left: BorderSide(color: Colors.grey), // 왼쪽 테두리
                          right: BorderSide(color: Colors.grey), // 오른쪽 테두리
                          bottom: BorderSide(color: Colors.grey), // 아래쪽 테두리
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0), // 내부 여백
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 60,
                              color: Colors.grey, // 책 표지 위치
                              child: (book['image_url'] != null && book['image_url'] != 'http://cover.nl.go.kr/')
                                  ? Image.network(book['image_url'], fit: BoxFit.cover)
                                  : Image.asset('assets/images/img_none.png'), // 기본 이미지
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                book['title'] ?? '제목 없음',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  print("이전 페이지로 돌아가기");
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  backgroundColor: Color(0xFFF1F4E8),
                  side: BorderSide(color: Color(0xFF789C49)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: Text(
                  '이전으로 돌아가기',
                  style: TextStyle(
                    color: Color(0xFF789C49),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
