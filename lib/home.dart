import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // 스크롤 가능하도록 SingleChildScrollView 추가
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
              child: SvgPicture.asset('assets/images/study.svg'),
            ),
            const SizedBox(height: 20),

            // --- 버튼 그룹 ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildButton(
                  context,
                  'assets/images/A.svg',
                  'AI',
                  () {
                    // TODO: AI 페이지로 이동하는 로직 추가
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
    );
  }

  // --- 버튼 위젯 생성 함수 ---
  Widget _buildButton(BuildContext context, String imagePath, String label,
      VoidCallback onPressed) {
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

  // 달력 생성 함수
  Widget _buildCalendar() {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;
    int today = now.day;
    String weekday = _getWeekdayString(now.weekday);

    // 해당 월의 첫 번째 날짜와 마지막 날짜
    DateTime firstDayOfMonth = DateTime(currentYear, currentMonth, 1);
    DateTime lastDayOfMonth = DateTime(currentYear, currentMonth + 1, 0);

    // 해당 월의 첫 번째 요일 (월요일: 1, 일요일: 7)
    int firstWeekday = firstDayOfMonth.weekday;

    // 그리드뷰에 표시할 총 날짜 수
    int totalDays = lastDayOfMonth.day + firstWeekday;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$currentYear년 $currentMonth월 $today일 $weekday', // 년, 월, 일, 요일 표시
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemCount: totalDays, // 총 날짜 수로 변경
          itemBuilder: (context, index) {
            // index가 첫 번째 요일보다 작으면 빈 칸 표시
            if (index < firstWeekday) {
              return Container();
            }

            // 실제 날짜 계산
            int day = index - firstWeekday + 1;

            return Center(
              child: Text(
                '$day',
                style: TextStyle(
                  color:
                      day == today ? Colors.deepOrangeAccent : Colors.white,
                  fontWeight:
                      day == today ? FontWeight.bold : FontWeight.normal,
                  fontSize:
                      day == today ? 15 : 12,
                ),
              ),
            );
          },
        )
      ],
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

  // --- 요일 한글 변환 함수 ---
  String _getWeekdayString(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return '월요일';
      case DateTime.tuesday:
        return '화요일';
      case DateTime.wednesday:
        return '수요일';
      case DateTime.thursday:
        return '목요일';
      case DateTime.friday:
        return '금요일';
      case DateTime.saturday:
        return '토요일';
      case DateTime.sunday:
        return '일요일';
      default:
        return '';
    }
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
