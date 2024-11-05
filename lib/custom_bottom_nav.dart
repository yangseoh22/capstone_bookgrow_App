import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mybooks/mybooks.dart';
import 'reading/reading_home.dart';
import 'recommend/recommend_home.dart';
import 'mypages/profile.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  const CustomBottomNavBar({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          Get.offAll(() => MyBooks(), transition: Transition.noTransition);
          break;
        case 1:
          Get.offAll(() => Timer(), transition: Transition.noTransition);
          break;
        case 2:
          Get.offAll(() => Recommendation(), transition: Transition.noTransition);
          break;
        case 3:
          Get.offAll(() => Profile(), transition: Transition.noTransition);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: '도서', // Label 추가
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timer),
          label: '타이머', // Label 추가
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.thumb_up),
          label: '추천', // Label 추가
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '프로필', // Label 추가
        ),
      ],
      currentIndex: widget.selectedIndex,
      backgroundColor: Color(0xFFF0E3C0),
      selectedItemColor: Color(0xFF789C49),
      unselectedItemColor: Colors.white,
      showUnselectedLabels: false,  // 선택되지 않은 메뉴는 라벨 숨기기
      onTap: _onItemTapped,
    );
  }
}
