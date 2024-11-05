import 'dart:io';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import '../Controller.dart';
import '../serverConfig.dart';
import 'recommend_book.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final Controller controller = Get.put(Controller());
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
      );
      _controller = CameraController(frontCamera, ResolutionPreset.high);
      _initializeControllerFuture = _controller.initialize();
      setState(() {});
      print("카메라 초기화 성공");
    } catch (e) {
      print('카메라 초기화 실패: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    print("카메라 해제됨");
    super.dispose();
  }

  Future<void> captureAndSendImage() async {
    setState(() {
      isLoading = true;
    });
    print("이미지 캡처 및 전송 시작");

    try {
      await _initializeControllerFuture;
      print("카메라 초기화 완료. 사진 촬영 준비됨");

      final image = await _controller.takePicture();
      print("사진 촬영 완료: ${image.path}");

      String? emotion = await sendImageAsMultipart(image.path);

      if (emotion != null) {
        print("감정 인식 성공: $emotion");
        controller.setEmotion(emotion);

        print("DisplayPictureScreen으로 이동, 이미지 경로: ${image.path}");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (innerContext) => DisplayPictureScreen(imagePath: image.path),
          ),
        ).then((_) {
          print("DisplayPictureScreen에서 돌아옴");
        });
      } else {
        print("이미지 전송 실패. 실패 메시지 표시 중");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("이미지 전송에 실패했습니다. 다시 시도해주세요.")),
        );
      }
    } catch (e) {
      print('이미지 캡처 또는 전송 중 오류 발생: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
      print("이미지 캡처 및 전송 종료");
    }
  }

  Future<String?> sendImageAsMultipart(String imagePath) async {
    final url = Uri.parse('$SERVER_URL/recommend/uploadImage');
    final request = http.MultipartRequest('POST', url);

    request.files.add(await http.MultipartFile.fromPath(
      'imageFile',
      imagePath,
      filename: path.basename(imagePath),
    ));

    try {
      print("서버로 이미지 전송 중: ${url.toString()}");
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        print("이미지 전송 성공, 응답 상태: ${response.statusCode}");

        String responseBody = responseData.body.trim();
        print("서버 응답 본문: $responseBody");

        if (responseBody.startsWith("인식된 감정:")) {
          responseBody = responseBody.replaceFirst("인식된 감정:", "").trim();
        }

        if (responseBody.startsWith('{') && responseBody.endsWith('}')) {
          final responseJson = jsonDecode(responseBody);
          print("응답 JSON 파싱 성공: ${responseJson}");
          return responseJson['dominant_emotion'];
        } else {
          print("응답이 JSON 형식이 아님: $responseBody");
          return null;
        }
      } else {
        print("이미지 전송 실패, 상태 코드: ${response.statusCode}");
        print("서버 응답 본문: ${responseData.body}");
        return null;
      }
    } catch (e) {
      print("이미지 전송 중 오류 발생: $e");
      return null;
    }
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
                CameraPreview(_controller),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text(
                      '얼굴을 윤곽선 안에 맞추어\n본인의 감정이 드러나는 표정을 찍어보세요!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 200,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150),
                      border: Border.all(color: Colors.white, width: 3.0),
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: IconButton(
                      iconSize: 80,
                      icon: Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: isLoading ? null : captureAndSendImage,
                    ),
                  ),
                ),
                if (isLoading)
                  Center(
                    child: CircularProgressIndicator(),
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
  final Controller controller = Get.find();

  DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("이미지 표시 중, 경로: $imagePath");
    return Scaffold(
      appBar: AppBar(title: Text('찍은 사진')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(child: Image.file(File(imagePath))),
                Positioned(
                  bottom: 20,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    color: Colors.black.withOpacity(0.5),
                    child: Obx(() => Text(
                      '인지된 감정: ${controller.recognizedEmotion}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                print("RecommendBookPage로 이동");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecommendBookPage()),
                );
              },
              child: Text(
                '제출',
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
