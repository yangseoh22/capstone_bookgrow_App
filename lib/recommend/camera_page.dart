import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'recommend_book.dart'; // recommend_book 페이지 가져오기

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();

      // 전면 카메라를 선택
      final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.high,
      );

      _initializeControllerFuture = _controller.initialize();
      setState(() {}); // 초기화 후 UI 갱신
    } catch (e) {
      print('Camera initialization failed: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('카메라')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_controller), // 카메라 프리뷰
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text(
                      '얼굴을 윤곽선 안에 맞추어\n본인의 감정이 드러나는 표정을 찍어보세요!',
                      textAlign: TextAlign.center, // 텍스트 중앙 정렬
                      style: TextStyle(
                        color: Colors.white, // 글씨 색상
                        fontSize: 15, // 글씨 크기
                      ),
                    ),
                  ),
                ),
                // 얼굴 윤곽 가이드라인 (타원형 프레임)
                Center(
                  child: Container(
                    width: 200, // 타원의 너비
                    height: 300, // 타원의 높이
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150), // 타원형 모양
                      border: Border.all(
                        color: Colors.white, // 윤곽선 색상
                        width: 3.0, // 윤곽선 두께
                      ),
                      color: Colors.white.withOpacity(0.1), // 투명도 있는 배경
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: IconButton(
                      iconSize: 80,
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        try {
                          await _initializeControllerFuture;
                          final image = await _controller.takePicture();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DisplayPictureScreen(
                                imagePath: image.path,
                              ),
                            ),
                          );
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('찍은 사진')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,  // 요소들을 수직 중앙 정렬
        crossAxisAlignment: CrossAxisAlignment.center, // 가로 중앙 정렬
        children: [
          Expanded(
            child: Center( // 이미지를 중앙 정렬
              child: Image.file(File(imagePath)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // 도서 추천 결과 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecommendBookPage()),
                );
              },
              child: Text(
                '제출', // 버튼 텍스트 수정
                style: TextStyle(
                  color: Color(0xFF789C49),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF1F4E8),
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                side: BorderSide(color: Color(0xFF789C49)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

