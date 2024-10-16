import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                      icon: Icon(Icons.delete, color: Color(0xFF789C49)), // 초록색으로 변경
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
            SizedBox(height: 50),
            // 뒤로 가기 버튼
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: _goBack, // 뒤로 가기 기능 추가
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF1F4E8),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                  side: BorderSide(color: Color(0xFF789C49), width: 1.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  '뒤로 가기',
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
