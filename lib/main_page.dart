import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:licensea/ai_license_list.dart';
import 'airecommendation.dart';
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
  int _currentIndex = 0;
  final AIRecommendationService _aiService = AIRecommendationService();
  final PageController _pageController = PageController();

  List<String> appbarTitle = ['홈', 'AI', '검색', '프로필'];

  @override
  void initState() {
    super.initState();
    _aiService.initialize().then((_) {
      _aiService.updateRecommendations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double textWidth = constraints.maxWidth - 134 - 30.0;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset('assets/images/title.svg', height: 30.0),
                const SizedBox(width: 30),
                SizedBox(
                  width: textWidth,
                  child: Text(
                    '\n자격증 정보의 바다',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: textWidth / 17,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),

      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index; // 페이지 변경 시 인덱스 업데이트
          });
        },
        children: const [
          HomePage(),
          LicenseaChatbotPage(),
          AI_License(),
          ProfilePage(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black45,
        currentIndex: _currentIndex,

        onTap: (value) {
          _pageController.jumpToPage(value); // BottomNavigationBarItem 클릭 시 페이지 변경
        },
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