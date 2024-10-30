import 'package:flutter/material.dart';
import 'reading_selection2.dart';

class ReadingSelectionPage1 extends StatefulWidget {
  @override
  _ReadingSelectionPage1State createState() => _ReadingSelectionPage1State();
}

class _ReadingSelectionPage1State extends State<ReadingSelectionPage1> {
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
                      // 책 항목을 클릭하면 ReadingSelectionPage2로 이동
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
                          bottom: BorderSide(color: Colors.grey), // 오른쪽 테두리
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
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
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
