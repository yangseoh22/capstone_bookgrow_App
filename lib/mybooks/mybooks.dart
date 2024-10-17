import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'category_edit.dart';
import '../custom_bottom_nav.dart';
import 'barcode_scan.dart'; // 바코드 스캔 페이지

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
              alignment: Alignment.center, // 가로 방향으로 중앙 정렬
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => BookScannerPage());  // 새로운 도서 등록 로직 추가
                },
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
                child: Text(
                  '새로운 도서 등록하러 가기',
                  style: TextStyle(fontSize: 16, color: Color(0xFF789C49)),
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
                itemCount: 10, // 샘플 데이터 수
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey), // 위쪽 테두리
                        left: BorderSide(color: Colors.grey), // 왼쪽 테두리
                        right: BorderSide(color: Colors.grey), // 오른쪽 테두리
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
                          SizedBox(width: 20), // 이미지와 텍스트 사이의 간격
                          Expanded(
                            child: Text(
                              '도서제목입니다.',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
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
