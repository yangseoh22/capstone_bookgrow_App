import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'category_edit.dart';
import '../custom_bottom_nav.dart';
import 'barcode_scan.dart'; // 바코드 스캔 페이지
import 'view_book.dart'; // 도서 정보 페이지 가져오기

class MyBooks extends StatefulWidget {
  @override
  _MyBooksState createState() => _MyBooksState();
}

class _MyBooksState extends State<MyBooks> {
  List<String> categories = ['전체', '소설', '비소설', '과학', '기타'];
  String dropdownValue = '전체';

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
                  Get.to(() => BookScannerPage());  // 새로운 도서 등록 로직 추가
                },
                icon: Icon(Icons.add, color: Color(0xFF789C49)), // 아이콘 추가
                label: Text(
                  '새로운 도서 등록하러 가기',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF789C49),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF1F4E8),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
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
                  items: categories
                      .map<DropdownMenuItem<String>>((String value) {
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
                itemCount: 10, // 도서 목록 수 예시
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // 책 항목을 클릭하면 view_book 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewBookPage(), // ViewBookPage로 이동
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey),
                          left: BorderSide(color: Colors.grey),
                          right: BorderSide(color: Colors.grey),
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
                              child: Center(child: Text('책표지')),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                '도서제목입니다.',
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
            SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0), // 하단 네비게이션 바
    );
  }
}
