import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:logger/logger.dart';  // 로그
import 'book_info.dart'; // 도서 정보 페이지

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
      // 스캔 후에 API 요청 및 결과 페이지로 이동
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
    // 국립중앙도서관 API의 기본 URL
    const baseUrl = 'https://www.nl.go.kr/NL/search/openApi/search.do';

    // kwd 파라미터에 스캔된 ISBN과 API 키를 조합하여 최종 URL 생성
    return '$baseUrl?key=$apiKey&kwd=$isbn';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BookGrow'),  // 앱 상단의 제목
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ISBN 직접 입력 필드
              TextField(
                controller: isbnController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter ISBN',
                ),
                keyboardType: TextInputType.number,  // 숫자 키패드 표시
                onChanged: (value) {
                  setState(() {
                    isbnInput = value;  // 입력된 ISBN을 반영
                  });
                },
              ),
              SizedBox(height: 10),  // 여백 추가
              // 도서 검색 버튼
              ElevatedButton(
                onPressed: searchBook,  // 버튼 클릭 시 ISBN 검색 실행
                child: Text('Search Book by ISBN'),
              ),
              SizedBox(height: 20),  // 버튼과 스캔 버튼 사이에 여백 추가
              // 바코드 스캔 시작 버튼
              ElevatedButton(
                onPressed: scanBarcode,  // 버튼 클릭 시 바코드 스캔 실행
                child: Text('Scan Barcode'),
              ),
              SizedBox(height: 20),  // 버튼과 결과 텍스트 사이에 여백 추가
              // 스캔된 결과 또는 안내 메시지 표시
              Text(
                barcode.isEmpty ? 'Scan a code' : 'Scanned code: $barcode',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
