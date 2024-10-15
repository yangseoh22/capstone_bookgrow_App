import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                  Get.to(() => BarcodeScanExample());  // 새로운 도서 등록 로직 추가
                },
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
                  return ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey, // 책 표지 위치
                      child: Center(child: Text('책표지')),
                    ),
                    title: Text(
                      '도서제목입니다.',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0), // 하단 네비게이션 바
    );
  }
}

// 카테고리 수정 페이지
class CategoryEditPage extends StatefulWidget {
  final List<String> categories;
  final ValueChanged<List<String>> onCategoriesChanged;

  CategoryEditPage({required this.categories, required this.onCategoriesChanged});

  @override
  _CategoryEditPageState createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends State<CategoryEditPage> {
  List<String> categories = [];
  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    categories = List.from(widget.categories); // 기존 카테고리 목록을 받아옴
  }

  void _addCategory() {
    if (_categoryController.text.isNotEmpty) {
      setState(() {
        categories.add(_categoryController.text);
        _categoryController.clear();
      });
    }
  }

  void _removeCategory(int index) {
    setState(() {
      categories.removeAt(index);
    });
  }

  void _goBack() {
    widget.onCategoriesChanged(categories); // 수정된 카테고리 목록 전달
    Get.back(); // 뒤로 가기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('카테고리 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 카테고리 리스트
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(categories[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeCategory(index),
                    ),
                  );
                },
              ),
            ),
            // 새 카테고리 추가 필드
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                hintText: '새 카테고리 입력',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addCategory,
                ),
              ),
            ),
            SizedBox(height: 20),
            // 뒤로 가기 버튼
            ElevatedButton(
              onPressed: _goBack,
              child: Text('뒤로 가기'),
            ),
          ],
        ),
      ),
    );
  }
}