import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'add_book.dart';

// Logger 인스턴스 생성
var logger = Logger();

class BookScannerPage extends StatefulWidget {
  @override
  _BookScannerPageState createState() => _BookScannerPageState();
}

class _BookScannerPageState extends State<BookScannerPage> {
  String barcode = "";
  String isbnInput = "";
  String apiUrl = "";
  final String apiKey = "e1adc23dd4ac04e3d70203811977a0a5b98a61a61eeb7593d517e459b466cab6";
  final TextEditingController isbnController = TextEditingController();

  Map<String, dynamic> bookInfo = {};
  bool isLoading = false;
  bool isCompleted = false;

  Future<void> scanBarcode() async {
    try {
      logger.i("바코드 스캔 시작");
      var result = await BarcodeScanner.scan();
      setState(() {
        barcode = result.rawContent;
        isbnInput = barcode;
        apiUrl = _generateApiUrl(barcode);
      });
      if (apiUrl.isNotEmpty) {
        fetchBookInfo();
      }
    } catch (e) {
      setState(() {
        barcode = "바코드 인식 실패: $e";
        logger.e("바코드 스캔 실패: $e");
      });
    }
  }

  void searchBook() {
    if (isbnController.text.isNotEmpty) {
      setState(() {
        isbnInput = isbnController.text;
        apiUrl = _generateApiUrl(isbnInput);
      });
      if (apiUrl.isNotEmpty) {
        fetchBookInfo();
      }
    }
  }

  String _generateApiUrl(String isbn) {
    const baseUrl = 'https://www.nl.go.kr/NL/search/openApi/search.do';
    return '$baseUrl?key=$apiKey&kwd=$isbn';
  }

  Future<void> fetchBookInfo() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final document = xml.XmlDocument.parse(response.body);
        setState(() {
          bookInfo = {
            'title': _getXmlElementText(document, 'title_info'),
            'author': _getXmlElementText(document, 'author_info'),
            'publisher': _getXmlElementText(document, 'pub_info'),
            'publication_year': _getXmlElementText(document, 'pub_year_info'),
            'isbn': _getXmlElementText(document, 'isbn'),
            'format': _getXmlElementText(document, 'type_name'),
            'genre': _getXmlElementText(document, 'kdc_name_1s'),
            'image_url': _getXmlElementText(document, 'image_url') ?? ''
          };
          isLoading = false;
        });
      }
    } catch (e) {
      logger.e("API 요청 중 오류 발생: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getXmlElementText(xml.XmlDocument document, String elementName) {
    try {
      return document.findAllElements(elementName).first.text;
    } catch (e) {
      return '정보 없음';
    }
  }

  Future<void> _showIsbnInputDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ISBN 번호 입력'),
          content: TextField(
            controller: isbnController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'ISBN 번호를 입력하세요'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                searchBook();
              },
            ),
          ],
        );
      },
    );
  }

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
              '나의 도서',
              style: TextStyle(
                color: Color(0xFF789C49),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: scanBarcode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF1F4E8),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                  side: BorderSide(color: Color(0xFF789C49), width: 1.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  '카메라로 바코드 인식하기',
                  style: TextStyle(fontSize: 18, color: Color(0xFF789C49),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: _showIsbnInputDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF1F4E8),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                  side: BorderSide(color: Color(0xFF789C49), width: 1.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  'ISBN 번호 직접 입력하기',
                  style: TextStyle(fontSize: 18, color: Color(0xFF789C49),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : bookInfo.isNotEmpty
                ? Expanded(
              child: BookInfoPage(
                bookInfo: bookInfo,
                isCompleted: isCompleted,
                onCompletedChange: (newValue) {
                  setState(() {
                    isCompleted = newValue;
                  });
                },
              ),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
