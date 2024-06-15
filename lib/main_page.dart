import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'license_list_api.dart';
import 'home.dart';
import 'profile.dart';
import 'chatbot.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int Index = 0;

  List<Widget> screens = [
    HomePage(),
    LicenseaChatbotPage(),
    License_list_api(),
    Profile(),
  ];

  List<String> appbarTitle = ['홈', 'AI', '검색', '프로필'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: LayoutBuilder( // LayoutBuilder 추가
          builder: (BuildContext context, BoxConstraints constraints) {
            // 텍스트 너비 계산
            double textWidth = constraints.maxWidth - 134 - 30.0; // 화면 너비 - title.svg 너비 - SizedBox 너비

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset('assets/images/title.svg', height: 30.0),
                const SizedBox(width: 30),
                SizedBox(
                  width: textWidth, // 계산된 텍스트 너비 사용
                  child: Text(
                    '\n자격증 정보의 바다',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: textWidth / 17, // 글자 간격을 텍스트 너비에 비례하게 조정
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                color: Colors.white,
                child: screens[Index],
              ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black45,
        //backgroundColor: Colors.black,
        currentIndex: Index,

        onTap: (value) => setState(() {
          Index = value;
        }),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy_outlined), label: 'AI'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
        ],
      ),
    );
  }
}