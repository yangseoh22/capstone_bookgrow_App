import 'package:bookgrow_app/recommend/recommend_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Controller.dart';
import '../serverConfig.dart';

class RecommendBookPage extends StatefulWidget {
  @override
  _RecommendBookPageState createState() => _RecommendBookPageState();
}

class _RecommendBookPageState extends State<RecommendBookPage> {
  final Controller controller = Get.find();
  List<Map<String, String>> bookRecommendations = []; // 도서 추천 결과 저장
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecommendations();
  }

  Future<void> fetchRecommendations() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('$SERVER_URL/recommend/getBooks?emotion=${controller.recognizedEmotion}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // 서버에서 받은 데이터를 bookRecommendations에 저장
        setState(() {
          bookRecommendations = data.map((item) {
            return {
              'title': item['title']?.toString() ?? '제목 없음',
              'image': item['image']?.toString() ?? '',
              'isbn': item['isbn']?.toString() ?? '',
            };
          }).toList().cast<Map<String, String>>();
          isLoading = false;
        });
      } else {
        print('Failed to load recommendations: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching recommendations: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

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
            Obx(() => Text(
              '감지된 감정 : ${controller.recognizedEmotion}',
              style: TextStyle(
                color: Color(0xFF789C49),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )),
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
            isLoading
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 145.0),
              child: Column(
                children: [
                  SizedBox(height: 150),
                  CircularProgressIndicator(),
                  SizedBox(height: 150),
                ],
              ),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: bookRecommendations.length,
                itemBuilder: (context, index) {
                  final book = bookRecommendations[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: ListTile(
                        leading: book['image']!.isNotEmpty
                            ? Image.network(
                          book['image']!,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey,
                            child: Center(
                              child: Text(
                                '책표지',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                            : Container(
                          color: Colors.grey,
                          width: 60,
                          height: 60,
                          child: Center(
                            child: Text(
                              '책표지',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        title: Text(
                          book['title']!,
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: book['isbn']!.isNotEmpty
                            ? Text('ISBN: ${book['isbn']}')
                            : null,
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
                  '도서 추천 종료하기',
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
