import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewBookPage extends StatefulWidget {
  @override
  _ViewBookPageState createState() => _ViewBookPageState();
}

class _ViewBookPageState extends State<ViewBookPage> {
  String bookTitle = '도서제목입니다.';
  String author = '홍길동';
  String publisher = '출판사';
  String publishedDate = 'YYYY.MM.DD';
  String isbn = '123456789123';
  String imageUrl = 'http://cover.nl.go.kr/';
  List<String> review = [];

  int currentPage = 150; // 현재 읽은 페이지 예시
  int totalPages = 200; // 전체 페이지 수 예시

  // 각 단계별로 회색/색상 이미지 경로를 저장
  final List<String> grayImages = [
    'assets/images/gray1.png',
    'assets/images/gray2.png',
    'assets/images/gray3.png',
    'assets/images/gray4.png',
    'assets/images/gray5.png',
  ];

  final List<String> coloredImages = [
    'assets/images/prog1.png',
    'assets/images/prog2.png',
    'assets/images/prog3.png',
    'assets/images/prog4.png',
    'assets/images/prog5.png',
  ];

  // 진행도에 따라 이미지 선택 함수
  List<String> getImagePaths(double progress) {
    List<String> selectedImages = List.from(grayImages); // 기본적으로 회색 이미지

    if (progress >= 0) selectedImages[0] = coloredImages[0];
    if (progress >= 0.25) selectedImages[1] = coloredImages[1];
    if (progress >= 0.5) selectedImages[2] = coloredImages[2];
    if (progress >= 0.75) selectedImages[3] = coloredImages[3];
    if (progress == 1.0) selectedImages[4] = coloredImages[4];

    return selectedImages;
  }

  @override
  Widget build(BuildContext context) {
    final progress = (currentPage / totalPages).clamp(0.0, 1.0); // 진행도 계산
    final imagePaths = getImagePaths(progress); // 진행도에 따른 이미지 리스트

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
                        child: (imageUrl != 'http://cover.nl.go.kr/')
                            ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                                'assets/images/img_none.png',
                                fit: BoxFit.cover,
                              ),
                        )
                            : Image.asset('assets/images/img_none.png'),
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
                  Text('저자: $author', style: TextStyle(color: Colors.grey[700])),
                  Text('발행처: $publisher', style: TextStyle(color: Colors.grey[700])),
                  Text('발행(예정)일: $publishedDate', style: TextStyle(color: Colors.grey[700])),
                  Text('ISBN: $isbn', style: TextStyle(color: Colors.grey[700])),
                  SizedBox(height: 20),

                  // 이미지 진행 상태 표시
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Expanded(
                          child: Image.asset(
                            imagePaths[index],
                            height: 30,
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 5),

                  // 진행 바
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 16, // 진행 바의 굵기 설정
                          child: LinearProgressIndicator(
                            value: progress,
                            color: Color(0xFF789C49),
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 진행률 표시 (아랫줄, 오른쪽 정렬)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        '$currentPage / $totalPages 쪽',
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              '리뷰',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: review.length,
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
                      review[index],
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
