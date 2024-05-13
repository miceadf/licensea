import 'package:flutter/material.dart';
import 'Screen1.dart';
import 'Screen2.dart';
import 'Screen3.dart';
import 'Screen4.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int Index = 0;

  List<Widget> screens = [
    Screen1(),
    Screen2(),
    Screen3(),
    Screen4(),
  ];

  List<String> appbarTitle = ['기술사', '기능장', '기사', '기능사'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(color: Colors.yellowAccent, Icons.bolt),
            Text(appbarTitle[Index]),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 80),
        color: Colors.grey,
        child: screens[Index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white30,
        backgroundColor: Colors.black,
        currentIndex: Index,

        onTap: (value) => setState(() {
          Index = value;
        }),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '기술사'),
          BottomNavigationBarItem(icon: Icon(Icons.home_max), label: '기능장'),
          BottomNavigationBarItem(icon: Icon(Icons.home_mini), label: '기사'),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '기능사'),
        ],
      ),
    );
  }
}