import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'custom_bottom_nav.dart';
import 'barcode_scan.dart'; // 바코드 스캔 페이지

class MyBooks extends StatefulWidget {
  @override
  _MyBooksState createState() => _MyBooksState();
}

class _MyBooksState extends State<MyBooks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 도서'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('나의 도서 페이지입니다.'),
            SizedBox(height: 20),
            // 바코드 조회 페이지로 이동하는 버튼 추가
            ElevatedButton(
              onPressed: () {
                Get.to(() => BarcodeScanExample());
              },
              child: Text('바코드 조회하기'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0), // 하단 네비게이션 바
    );
  }
}
