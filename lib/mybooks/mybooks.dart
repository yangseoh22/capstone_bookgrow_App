import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Controller.dart'; // 통합 Controller
import '../serverConfig.dart';
import 'category_edit.dart';
import '../custom_bottom_nav.dart';
import 'barcode_scan.dart'; // 바코드 스캔 페이지
import 'book_detail.dart'; // 도서 정보 페이지 가져오기

class MyBooks extends StatefulWidget {
  @override
  _MyBooksState createState() => _MyBooksState();
}

class _MyBooksState extends State<MyBooks> {
  final Controller controller = Get.put(Controller());
  List<String> categories = ['전체', '소설', '비소설', '과학', '기타'];
  String dropdownValue = '전체';
  List<Map<String, dynamic>> books = []; // 도서 목록 저장을 위한 리스트

  @override
  void initState() {
    super.initState();
    fetchBooks(); // 도서 목록 불러오기
  }

  // 서버에서 도서 목록을 가져오는 함수
  Future<void> fetchBooks() async {
    final userId = controller.userId.value;

    final url = Uri.parse('$SERVER_URL/book/getAll?userId=$userId');
    print("도서 목록 요청 URL: $url");

    try {
      final response = await http.get(url);

      print("도서 목록 응답 상태 코드: ${response.statusCode}");
      print("도서 목록 응답 본문: ${utf8.decode(response.bodyBytes)}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          books = data.map((book) {
            print("도서 데이터: $book"); // 각 도서 데이터 로그 출력
            return {
              'bookId': book['id'],
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
              '나의 도서',
              style: TextStyle(
                color: Color(0xFF789C49), // 초록색 텍스트
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(() => BookScannerPage()); // 도서 등록
                },
                icon: Icon(Icons.add, color: Color(0xFF789C49)), // 아이콘 추가
                label: Text(
                  '새로운 도서 등록하러 가기',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color(0xFF789C49),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF1F4E8),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                  side: BorderSide(
                    color: Color(0xFF789C49),
                    width: 1.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Get.to(() => CategoryEditPage(
                  categories: categories,
                  onCategoriesChanged: (updatedCategories) {
                    setState(() {
                      categories = updatedCategories;
                    });
                  },
                ));
              },
              child: Text(
                '카테고리 수정',
                style: TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            // 카테고리 선택 드롭박스
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
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
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
                      // Controller에 bookId 저장
                      print("선택한 도서 bookId: ${book['bookId']}");
                      controller.setBookId(book['bookId']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewBookPage(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey),
                          left: BorderSide(color: Colors.grey),
                          right: BorderSide(color: Colors.grey),
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 60,
                              color: Colors.grey,
                              child: (book['image_url'] != null && book['image_url'] != 'http://cover.nl.go.kr/')
                                  ? Image.network(book['image_url'])
                                  : Image.asset('assets/images/img_none.png'), // 기본 이미지
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                book['title'],
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
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
    );
  }
}
