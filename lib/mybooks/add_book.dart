import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Controller/UserController.dart'; // UserController 가져오기
import '../serverConfig.dart'; // 서버 주소 설정 파일

class BookInfoPage extends StatelessWidget {
  final Map<String, dynamic> bookInfo;
  final bool isCompleted;
  final Function onCompletedChange;

  final TextEditingController totalPageController = TextEditingController();
  final TextEditingController currentPageController = TextEditingController();

  BookInfoPage({
    required this.bookInfo,
    required this.isCompleted,
    required this.onCompletedChange,
  });

  // 서버에 도서 등록 요청을 보내는 함수
  Future<void> _registerBook(BuildContext context) async {
    // 필드 값 가져오기
    final totalPage = totalPageController.text.trim();
    final currentPage = currentPageController.text.trim();

    // 유효성 검사
    if (totalPage.isEmpty) {
      Get.snackbar("오류", "총 쪽 수를 입력해주세요.");
      return;
    }
    if (!isCompleted && currentPage.isEmpty) {
      Get.snackbar("오류", "현재까지 읽은 쪽 수를 입력해주세요.");
      return;
    }

    // UserController 인스턴스에서 userId 가져오기
    final userController = Get.find<UserController>();
    final userId = userController.userId.value;

    // 도서 데이터 설정
    Map<String, dynamic> bookData = {
      "title": bookInfo['title'],
      "author": bookInfo['author'],
      "publisher": bookInfo['publisher'],
      "published_year": bookInfo['publication_year'],
      "isbn": bookInfo['isbn'],
      "total_page": totalPage,
      "current_page": currentPage,
      "format": bookInfo['format'] ?? "",
      "image_url": bookInfo['image_url'],
      "genre": bookInfo['genre'] ?? "",
      "is_completed": isCompleted,
    };

    // 도서 등록 엔드포인트 URL에 userId 추가
    final url = Uri.parse("$SERVER_URL/book/register?userId=$userId");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bookData),
      );

      print("도서 등록 응답 상태 코드: ${response.statusCode}");
      print("도서 등록 응답 본문: ${utf8.decode(response.bodyBytes)}");

      if (response.statusCode == 200) {
        Get.snackbar("성공", "도서가 등록되었습니다!");
        Navigator.pop(context); // 등록 완료 후 이전 화면으로 돌아감
      } else {
        Get.snackbar("오류", "도서 등록에 실패했습니다. 다시 시도해주세요.");
      }
    } catch (error) {
      print("도서 등록 요청 오류 발생: $error");
      Get.snackbar("오류", "네트워크 요청 실패: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 0,
        color: Colors.grey[180],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '인식된 도서',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 80,
                    color: Colors.grey[300],
                    child: Center(
                      child: Image.network(
                        bookInfo['image_url'],
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/images/img_none.png'); // 기본 이미지
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('제목: ${bookInfo['title']}'),
                        Text('저자: ${bookInfo['author']}'),
                        Text('출판사: ${bookInfo['publisher']}'),
                        Text('발행년도: ${bookInfo['publication_year']}'),
                        Text('ISBN: ${bookInfo['isbn']}'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: Text('이 도서의 총 쪽 수를 입력하세요.')),
                  SizedBox(width: 10),
                  Container(
                    width: 50,
                    child: TextField(
                      controller: totalPageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 3),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text('쪽'),
                ],
              ),
              SizedBox(height: 1),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '이 도서를 완독하셨나요?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Radio(
                    value: true,
                    groupValue: isCompleted,
                    onChanged: (val) {
                      onCompletedChange(true);
                    },
                  ),
                  Text('Y'),
                  Radio(
                    value: false,
                    groupValue: isCompleted,
                    onChanged: (val) {
                      onCompletedChange(false);
                    },
                  ),
                  Text('N'),
                ],
              ),
              SizedBox(height: isCompleted ? 0 : 10),
              if (!isCompleted)
                Row(
                  children: [
                    Expanded(child: Text('아직 완독하지 않았다면, \n현재까지 읽은 쪽 수를 알려주세요.')),
                    SizedBox(width: 1),
                    Container(
                      width: 50,
                      child: TextField(
                        controller: currentPageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 3),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text('쪽'),
                  ],
                ),
              SizedBox(height: 24),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () => _registerBook(context), // 도서 등록 함수 호출
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF1F4E8),
                    padding: EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                    side: BorderSide(color: Color(0xFF789C49), width: 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: Text(
                    '등록하기',
                    style: TextStyle(fontSize: 16, color: Color(0xFF789C49)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
