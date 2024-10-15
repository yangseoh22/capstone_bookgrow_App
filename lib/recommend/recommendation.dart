import 'package:flutter/material.dart';
import '../custom_bottom_nav.dart';

class Recommendation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('추천'),
      ),
      body: Center(
        child: Text('추천 페이지입니다.'),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 2),
    );
  }
}
