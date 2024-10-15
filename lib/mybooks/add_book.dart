import 'package:flutter/material.dart';

class BookInfoPage extends StatelessWidget {
  final Map<String, dynamic> bookInfo;
  final bool isCompleted;
  final Function onCompletedChange;

  BookInfoPage({
    required this.bookInfo,
    required this.isCompleted,
    required this.onCompletedChange,
  });

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
                    width: 50, // 필드의 너비
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true, // 내부 여백을 줄임
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
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true, // 내부 여백을 줄임
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
                  onPressed: () {},
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
