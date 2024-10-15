import 'package:flutter/material.dart';
import '../custom_bottom_nav.dart';

class Timer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('타이머'),
      ),
      body: Center(
        child: Text('타이머 페이지입니다.'),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
    );
  }
}
