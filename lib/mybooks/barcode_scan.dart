import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:logger/logger.dart';
import 'book_info.dart';

// Logger 인스턴스 생성
var logger = Logger();

class BarcodeScanExample extends StatefulWidget {
  @override
  _BarcodeScanExampleState createState() => _BarcodeScanExampleState();
}

class _BarcodeScanExampleState extends State<BarcodeScanExample> {
  String barcode = "";  // 스캔된 바코드 결과를 저장할 변수
  String isbnInput = "";  // 사용자가 입력한 ISBN을 저장할 변수
  String apiUrl = "";  // ISBN으로 조합된 API URL을 저장할 변수
  final String apiKey = "e1adc23dd4ac04e3d70203811977a0a5b98a61a61eeb7593d517e459b466cab6";  // 인증된 국립중앙도서관 API 키
  final TextEditingController isbnController = TextEditingController();  // ISBN 입력 필드 컨트롤러

  // 바코드 스캔 메서드
  Future<void> scanBarcode() async {
    try {
      logger.i("바코드 스캔 시작");  // 정보 로그
      var result = await BarcodeScanner.scan();
      setState(() {
        barcode = result.rawContent;  // 스캔된 바코드 데이터를 화면에 표시
        isbnInput = barcode;  // 스캔된 바코드를 ISBN 입력 필드에 반영
        apiUrl = _generateApiUrl(barcode);  // 스캔된 ISBN을 이용해 API URL 생성
        logger.i("스캔된 바코드: $barcode");  // 정보 로그
        logger.i("생성된 API URL: $apiUrl");  // 정보 로그
      });
      if (apiUrl.isNotEmpty) {
        logger.i("API 요청을 위해 페이지 이동");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookInfoPage(apiUrl: apiUrl),
          ),
        );
      }
    } catch (e) {
      setState(() {
        barcode = "바코드 인식 실패: $e";
        logger.e("바코드 스캔 실패: $e");  // 오류 로그
      });
    }
  }

  // ISBN 입력에 따라 API 요청
  void searchBook() {
    setState(() {
      apiUrl = _generateApiUrl(isbnController.text);
    });
    if (apiUrl.isNotEmpty) {
      logger.i("ISBN 입력에 따른 API 요청: $apiUrl");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookInfoPage(apiUrl: apiUrl),
        ),
      );
    }
  }

  // 국립중앙도서관 ISBN API URL 조합 메서드
  String _generateApiUrl(String isbn) {
    const baseUrl = 'https://www.nl.go.kr/NL/search/openApi/search.do';
    return '$baseUrl?key=$apiKey&kwd=$isbn';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 도서'), // 상단 제목
        backgroundColor: Color(0xFFD9C6A5), // 상단 배경색
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 첫 번째 버튼: 바코드 인식
            ElevatedButton(
              onPressed: scanBarcode,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEFF3E2), // 연한 초록 배경색
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 36.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: BorderSide(color: Color(0xFF789C49)), // 테두리 색상
              ),
              child: Text(
                '카메라로 바코드 인식하기',
                style: TextStyle(color: Color(0xFF789C49)), // 텍스트 색상
              ),
            ),
            SizedBox(height: 20), // 버튼 사이 여백

            // 두 번째 버튼: ISBN 직접 입력
            ElevatedButton(
              onPressed: searchBook,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEFF3E2),
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 36.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: BorderSide(color: Color(0xFF789C49)),
              ),
              child: Text(
                'ISBN 번호 직접 입력하기',
                style: TextStyle(color: Color(0xFF789C49)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
