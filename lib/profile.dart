import 'package:flutter/material.dart';
import 'custom_bottom_nav.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('프로필'),
      // ),
      body: Center(  // 전체 사각형들을 중앙에 배치
        child: Column(
          mainAxisSize: MainAxisSize.min,  // Column의 높이를 내용에 맞게 최소화
          crossAxisAlignment: CrossAxisAlignment.center,  // 가로 중앙 정렬
          children: [
            SizedBox(height: 10),
            // '마이페이지' 제목
            Text(
              '마이페이지',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF789C49), // 초록색
              ),
            ),
            SizedBox(height: 20),

            // 회원 정보 (고정된 너비)
            Container(
              padding: EdgeInsets.all(16),
              width: 300, // 고정된 너비 설정
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF789C49)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('회원정보', style: TextStyle(color: Color(0xFF789C49), fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('이름: 남도일'),
                  Text('닉네임: 독서짱이될테야'),
                  Text('아이디: namdoil'),
                  Text('비밀번호: **********'),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // 비밀번호 수정 로직
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF789C49), // 초록색 버튼
                      ),
                      child: Text('수정', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // 나의 독서 습관 (고정된 너비)
            Container(
              padding: EdgeInsets.all(16),
              width: 300, // 고정된 너비 설정
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF789C49)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('나의 독서 습관', style: TextStyle(color: Color(0xFF789C49), fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('누적 독서 시간: 108h 46m'),
                  Text('일별 평균 독서 쪽 수: 34쪽'),
                  Text('쪽별 독서 소요 시간: 42초'),
                  Text('소지 도서 수: 36권'),
                  Text('완독 도서 수: 30권'),
                ],
              ),
            ),
            SizedBox(height: 20),

            // 나의 꽃 (고정된 너비)
            Container(
              padding: EdgeInsets.all(16),
              width: 300, // 고정된 너비 설정
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF789C49)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('나의 꽃', style: TextStyle(color: Color(0xFF789C49), fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text('획득한 꽃: 16송이'),
                        Text('기부 횟수: 5번'),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.help_outline, color: Colors.grey),
                    onPressed: () {
                      _showInfoDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 3),
    );
  }

  // 알림창 표시 함수
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('기부 프로젝트'),
          content: Text('획득한 꽃의 수가 3의 배수가 될 때마다 지역 도서관에 기부가 진행됩니다. 자세한 기부 상황을 보려면, http://doseagwan.giboo를 참고하세요.'),
          actions: [
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}