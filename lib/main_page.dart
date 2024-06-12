import 'package:flutter/material.dart';
import 'license_list_api.dart';
import 'home.dart';
import 'profile.dart';
import 'Screen4.dart';
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
    Screen4(),
    License_list_api(),
    Profile(),
  ];

  List<String> appbarTitle = ['홈', 'AI', '검색', '프로필'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset('assets/images/title.svg', height: 30.0), // title.svg를 앱 바에 추가
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white, // 앱 바 배경색을 흰색으로 설정
        elevation: 0, // 앱 바 그림자 제거
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