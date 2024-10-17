import 'package:bookgrow_app/recommend/recommendation.dart';
import 'package:flutter/material.dart';

class RecommendBookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('도서 추천'),
        backgroundColor: Color(0xFFE8D9AE),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              '감지된 감정 : {감정}',  // 감정 인식 부분
              style: TextStyle(
                color: Color(0xFF789C49),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 30),
            Text(
              '이 도서들은 어떤가요?',
              style: TextStyle(
                color: Color(0xFF789C49),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // 도서 목록 수
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0), // 위아래 여백 추가
                    child: Container(
                      padding: EdgeInsets.all(10), // 내부 여백 추가
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 60,
                          color: Colors.grey,
                          child: Center(
                            child: Text(
                              '책표지',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        title: Text(
                          '도서제목입니다.',
                          style: TextStyle(
                            color: Colors.blueGrey, // 글씨 색상
                            fontSize: 15, // 글씨 크기
                          ),
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
                  // 다른 감정으로 추천 받기
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Recommendation()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF1F4E8),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  side: BorderSide(color: Color(0xFF789C49)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: Text(
                  '도서 추천 종료하기', // 버튼 텍스트 수정
                  style: TextStyle(
                    color: Color(0xFF789C49),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
