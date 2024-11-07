import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Controller.dart'; // 통합 Controller
import '../serverConfig.dart';

class ViewBookPage extends StatefulWidget {
  @override
  _ViewBookPageState createState() => _ViewBookPageState();
}

class _ViewBookPageState extends State<ViewBookPage> {
  final Controller controller = Get.find<Controller>();
  String bookTitle = '도서제목입니다.';
  String author = '홍길동';
  String publisher = '출판사';
  String publishedDate = 'YYYY.MM.DD';
  String isbn = '123456789123';
  String imageUrl = 'http://cover.nl.go.kr/';
  List<String> review = [];

  @override
  void initState() {
    super.initState();
    getBookDetails(); // 도서 상세 정보를 가져오는 함수 호출
  }

  // 서버에 도서 조회 요청을 보내는 함수
  Future<void> getBookDetails() async {
    final bookId = controller.bookId.value;
    final url = Uri.parse('$SERVER_URL/book/get?id=$bookId');
    print("도서 조회 요청 URL: $url");

    try {
      final response = await http.get(url);
      print("도서 조회 응답 상태 코드: ${response.statusCode}");
      print("도서 조회 응답 본문: ${utf8.decode(response.bodyBytes)}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          bookTitle = data['title'] ?? '도서제목입니다.';
          author = data['author'] ?? '저자';
          publisher = data['publisher'] ?? '출판사';
          publishedDate = data['publishedDate'] ?? 'YYYY.MM.DD';
          isbn = data['isbn'] ?? '123456789123';
          imageUrl = data['imageUrl'] ?? 'http://cover.nl.go.kr/';
          review = List<String>.from(data['review'] ?? []);
        });
        print("도서 정보가 성공적으로 불러와졌습니다.");
      } else {
        Get.snackbar("오류", "도서 정보를 불러오지 못했습니다.");
        print("서버 오류로 인해 도서 정보를 불러오지 못했습니다.");
      }
    } catch (error) {
      print("도서 조회 요청 오류 발생: $error");
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
            SizedBox(height: 20),
            Text(
              '나의 도서',
              style: TextStyle(
                color: Color(0xFF789C49),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 60,
                        color: Colors.grey,
                        child: (imageUrl != 'http://cover.nl.go.kr/')
                            ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            'assets/images/img_none.png',
                            fit: BoxFit.cover,
                          ),
                        )
                            : Image.asset('assets/images/img_none.png'),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          bookTitle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text('저자: $author', style: TextStyle(color: Colors.grey[700])),
                  Text('발행처: $publisher', style: TextStyle(color: Colors.grey[700])),
                  Text('발행(예정)일: $publishedDate', style: TextStyle(color: Colors.grey[700])),
                  Text('ISBN: $isbn', style: TextStyle(color: Colors.grey[700])),
                  SizedBox(height: 20),
                  Container(
                    height: 40,
                    color: Colors.grey[300],
                    child: Center(child: Text('진행바', style: TextStyle(color: Colors.grey[700]))),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              '리뷰',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: review.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 5),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFFAF3D2),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text(
                      review[index],
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF1F4E8),
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
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
