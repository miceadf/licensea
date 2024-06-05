import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView( // 스크롤 가능하도록 SingleChildScrollView 추가
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 상단 이미지 ---
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Image.asset('assets/images/study.png'),
              ),
              const SizedBox(height: 20),

              // --- 버튼 그룹 ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildButton(
                    context,
                    'assets/images/A.svg',
                    '채핏',
                        () {
                      // TODO: 채핏 페이지로 이동하는 로직 추가
                      _navigateToPage(context, const ChatPage());
                    },
                  ),
                  _buildButton(
                    context,
                    'assets/images/document.svg',
                    '모의시험',
                        () {
                      // TODO: 모의시험 페이지로 이동하는 로직 추가
                      _navigateToPage(context, const ExamPage());
                    },
                  ),
                  _buildButton(
                    context,
                    'assets/images/chat.svg',
                    '채팅 후기',
                        () {
                      // TODO: 채팅 후기 페이지로 이동하는 로직 추가
                      _navigateToPage(context, const ReviewPage());
                    },
                  ),
                  _buildButton(
                    context,
                    'assets/images/calendar.svg',
                    '시험 일정',
                        () {
                      // TODO: 시험 일정 페이지로 이동하는 로직 추가
                      _navigateToPage(context, const SchedulePage());
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // --- 달력 ---
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF44D39A),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '20XX',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '6월 2일 화요일',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildCalendar(),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // --- 진행도 ---
              const Text(
                '정보처리기사 취득 계획형 진행도 (4주)',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildProgress(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // TODO: 하단 탐색 바 아이템 및 탐색 로직 추가
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '프로필',
          ),
        ],
      ),
    );
  }

  // --- 버튼 위젯 생성 함수 ---
  Widget _buildButton(
      BuildContext context, String imagePath, String label, VoidCallback onPressed) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: const Color(0xFF49C2EE),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SvgPicture.asset(imagePath, width: 30, height: 30),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14.0),
        ),
      ],
    );
  }

  // --- 달력 위젯 생성 함수 ---
  Widget _buildCalendar() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: 31, // 달력 일 수
      itemBuilder: (context, index) {
        // TODO: 날짜 및 스타일 설정 로직 추가
        return Center(
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  // --- 진행도 바 위젯 생성 함수 ---
  Widget _buildProgress() {
    return Row(
      children: [
        _buildProgressCircle(true, '1주차'),
        _buildProgressLine(),
        _buildProgressCircle(false, '2주차'),
        _buildProgressLine(),
        _buildProgressCircle(false, '3주차'),
        _buildProgressLine(),
        _buildProgressCircle(false, '4주차'),
      ],
    );
  }

  // --- 진행도 원 위젯 생성 함수 ---
  Widget _buildProgressCircle(bool isActive, String label) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFF44D39A) : Colors.lightBlue[100],
            border: Border.all(
              color: isActive ? Colors.transparent : Colors.grey[300]!,
              width: 2.0,
            ),
          ),
          child: Center(
            child: isActive
                ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 30,
            )
                : Text(
              '30%',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // --- 진행도 선 위젯 생성 함수 ---
  Widget _buildProgressLine() {
    return const Expanded(
      child: Divider(
        color: Colors.grey,
        thickness: 2.0,
        height: 10,
      ),
    );
  }

  // --- 페이지 이동 함수 ---
  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

// --- 예시 페이지 ---
class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('채핏')),
      body: const Center(child: Text('채핏 페이지')),
    );
  }
}

// 모의시험 페이지
class ExamPage extends StatelessWidget {
  const ExamPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('모의시험')),
      body: const Center(child: Text('모의시험 페이지')),
    );
  }
}

// 채팅 후기 페이지
class ReviewPage extends StatelessWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('채팅 후기')),
      body: const Center(child: Text('채팅 후기 페이지')),
    );
  }
}

// 시험 일정 페이지
class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('시험 일정')),
      body: const Center(child: Text('시험 일정 페이지')),
    );
  }
}