import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';

class Profile extends StatelessWidget {
  final String id;
  final String age;
  final String job;
  final String location;

  const Profile({
    Key? key,
    this.id = '없음',
    this.age = '없음',
    this.job = '없음',
    this.location = '없음',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                //두번 째 박스
                width: double.infinity,
                height: 154,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.black.withOpacity(0.24),
                      width: 1,
                    ),
                    bottom: BorderSide(
                      color: Colors.black.withOpacity(0.24),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      //프로필 사진 들어갈 곳
                      width: 110,
                      height: 130,
                      margin: EdgeInsets.only(left: 19, top: 10),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black.withOpacity(0.24),
                              ),
                            ),
                            child: Image.asset('images/profile_pic.png'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 11,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildRow("아이디:", id),
                        buildRow("나이:", age),
                        buildRow("직업:", job),
                        buildRow("지역:", location),
                      ],
                    ),
                    Expanded(child: Container()),
                    SizedBox(width: 16), // Add some padding at the end
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 385,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Colors.black.withOpacity(0.24),
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 40.0, top: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildText("취득 희망 분야", ["-IT,컴퓨터", "-영어"]),
                          SizedBox(height: 16),
                          buildText("취득 사유", ["-취직", "-취미"]),
                          SizedBox(height: 16),
                          buildText("지원 희망 기업", ["-카카오", "-네이버"]),
                          SizedBox(height: 16),
                          buildText("소요 기간 및 일정", ["-1개월 내 선호", "-시험 일정 : 5월 1일 ~ 6월 30일 내"]),
                        ],
                      ),
                    ),
                    SizedBox(width: 16), // Add some padding at the end
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 173,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Colors.black.withOpacity(0.24),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 13.5, left: 21.17),
                          child: Icon(Icons.bookmark),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 6.17, top: 13.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildText("북마크", ["-정보처리기사", "-정보처리기능사", "-리눅스마스터"]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "편집",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildText(String title, List<String> contents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "편집",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
          ]
        ),
        SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: contents.map((content) => Text(content, style: TextStyle(fontSize: 12))).toList(),
        ),
      ],
    );
  }

  Widget buildDottedLine() {
    return Container(
      padding: EdgeInsets.only(top: 28),
      child: DottedLine(
        direction: Axis.horizontal,
        lineLength: double.infinity,
        dashColor: Colors.black.withOpacity(0.24),
      ),
    );
  }
}

