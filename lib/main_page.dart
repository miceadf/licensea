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
      backgroundColor: Colors.white,
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        //toolbarHeight: 80,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        shape: const Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          )
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'licensea',
              style: TextStyle(
                fontSize: 48,
                fontStyle: FontStyle.italic,
                fontFamily: "Inter",
                fontWeight: FontWeight.w800,
                height: 0,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          /*
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: SearchBar(
              leading: Icon(Icons.search),
              backgroundColor: MaterialStatePropertyAll(Colors.white),
              //trailing: [IconButton(onPressed: null,icon: Icon(Icons.search))],
              overlayColor: MaterialStateColor.resolveWith((states) => Colors.white),
              elevation: MaterialStateProperty.all(3),
              constraints: const BoxConstraints(maxHeight: 100),
              side: MaterialStateProperty.all(
                const BorderSide(color: Colors.black),
              ),
              hintText: "원하는 자격증을 검색하세요.",
           ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: const Center(
                child: Text(
                  'IT관련 자격증입니다.\n자격증에 대한 정보를 얻으시려면 터치하세요.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
            ),
          ),

           */
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