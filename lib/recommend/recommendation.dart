import 'package:flutter/material.dart';
import '../custom_bottom_nav.dart';
import 'camera_page.dart'; // 카메라 페이지를 import
import 'recommend_book.dart'; // recommend_book 페이지 가져오기

class Recommendation extends StatefulWidget {
  @override
  _RecommendationPageState createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<Recommendation> {
  String _selectedEmotion = '행복'; // 초기값 설정

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
              '도서 추천',
              style: TextStyle(
                color: Color(0xFF789C49), // 초록색 텍스트
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '감정을 인식하기 위해 본인의 감정을 잘 표현하는\n표정을 찍어보세요. 도서를 추천해드립니다!',
              style: TextStyle(
                color: Colors.grey[600], // 설명 텍스트 색상
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraPage()),
                  );
                },
                icon: Icon(Icons.camera_alt, color: Color(0xFF789C49), size: 30),
                label: Text(
                  '표정 촬영하러 가기',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF789C49),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF1F4E8),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                  side: BorderSide(color: Color(0xFF789C49)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 5,
              endIndent: 15,
            ),
            SizedBox(height: 10),
            Text(
              '감정 키워드를 선택해보세요. 도서를 추천해드립니다!',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                color: Colors.grey[200],
                child: ListView(
                  children: [
                    RadioListTile<String>(
                      title: Text('행복'),
                      value: '행복',
                      groupValue: _selectedEmotion,
                      onChanged: (value) {
                        setState(() {
                          _selectedEmotion = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('증오'),
                      value: '증오',
                      groupValue: _selectedEmotion,
                      onChanged: (value) {
                        setState(() {
                          _selectedEmotion = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('슬픔'),
                      value: '슬픔',
                      groupValue: _selectedEmotion,
                      onChanged: (value) {
                        setState(() {
                          _selectedEmotion = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('답답'),
                      value: '답답',
                      groupValue: _selectedEmotion,
                      onChanged: (value) {
                        setState(() {
                          _selectedEmotion = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('생각없음'),
                      value: '생각없음',
                      groupValue: _selectedEmotion,
                      onChanged: (value) {
                        setState(() {
                          _selectedEmotion = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // 도서 추천 결과 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecommendBookPage()),
                  );
                },
                icon: Icon(Icons.book, color: Color(0xFF789C49)),
                label: Text(
                  '감정 키워드로 도서 추천 받기',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF789C49),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF1F4E8),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  side: BorderSide(color: Color(0xFF789C49)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 2),
    );
  }
}
