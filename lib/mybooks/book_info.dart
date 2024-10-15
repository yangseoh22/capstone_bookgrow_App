import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:logger/logger.dart';

var logger = Logger();

class BookInfoPage extends StatefulWidget {
  final String apiUrl;

  BookInfoPage({required this.apiUrl});

  @override
  _BookInfoPageState createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  Map<String, dynamic> bookInfo = {}; // 동적 맵으로 변경
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookInfo();
  }

  String _getXmlElementText(xml.XmlDocument document, String elementName) {
    try {
      return document.findAllElements(elementName).first.text;
    } catch (e) {
      logger.w("XML 요소 $elementName 찾기 실패: $e");
      return '정보 없음';
    }
  }

  Future<void> fetchBookInfo() async {
    try {
      logger.i("API 요청 시작: ${widget.apiUrl}");
      final response = await http.get(Uri.parse(widget.apiUrl));

      if (response.statusCode == 200) {
        logger.i("API 응답 성공");
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

          if (bookInfo['image_url'].isEmpty) {
            bookInfo['image_url'] = 'assets/images/img_none.png'; // 기본 이미지
          }

          isLoading = false;
        });
      } else {
        logger.w("API 응답 실패: ${response.statusCode}");
        throw Exception('API 호출 실패');
      }
    } catch (e) {
      logger.e("API 요청 중 오류 발생: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Information'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : bookInfo.isNotEmpty
            ? Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title: ${bookInfo['title']}'),
                SizedBox(height: 10),
                Text('Author: ${bookInfo['author']}'),
                SizedBox(height: 10),
                Text('Publisher: ${bookInfo['publisher']}'),
                SizedBox(height: 10),
                Text('Published Date: ${bookInfo['publication_year']}'),
                SizedBox(height: 10),
                Text('ISBN: ${bookInfo['isbn']}'),
                SizedBox(height: 10),
                Text('Type: ${bookInfo['format']}'),
                SizedBox(height: 10),
                Text('Genre: ${bookInfo['genre']}'),
                SizedBox(height: 10),
                // 이미지 표시
                if (bookInfo['image_url'] != null && bookInfo['image_url']!.isNotEmpty)
                  Image.network(bookInfo['image_url'], errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/img_none.png');  // 로컬 기본 이미지 표시
                  }),
                SizedBox(height: 10),
              ],
            ),
          ),
        )
            : Text('도서 정보를 불러오지 못했습니다.'),
      ),
    );
  }
}
