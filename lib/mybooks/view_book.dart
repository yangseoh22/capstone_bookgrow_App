import 'package:flutter/material.dart';
import 'mybooks.dart';

class ViewBookPage extends StatelessWidget {
  final String bookTitle;
  final String author;
  final String publisher;
  final String publishedDate;
  final String isbn;
  final List<String> thoughts; // "나의 생각"을 담는 리스트

  ViewBookPage({
    this.bookTitle = '도서제목입니다.',
    this.author = '홍길동',
    this.publisher = '출판사',
    this.publishedDate = 'YYYY.MM.DD',
    this.isbn = '123456789123',
    this.thoughts = const ["표지가 흥미로워서 시작했다. 생각보다 재밌어서 잘 고른듯!",
      "내가 주인공이라면 @~!#%#!@# 이렇게 해봤을텐데..",
      "흡끅끆.. 다 생각이 있었던거야!ㅜㅜㅜㅜㅜㅜ",
      "이런 반전이 있다니! 당장 뒷 내용을 읽고 싶지만 학교를 가기 위해 참는다.."],
  });

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
                        child: Center(child: Text('책표지')),
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
                  Text('지은이: $author', style: TextStyle(color: Colors.grey[700])),
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
              '나의 생각',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: thoughts.length,
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
                      thoughts[index],
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
