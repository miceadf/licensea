import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';

/*void main() {
  runApp(const Search());
}*/

class Profile extends StatelessWidget {
  const Profile({super.key});

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
                            width: 1),
                        bottom: BorderSide(
                            color: Colors.black.withOpacity(0.24),
                            width: 1))),
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
                                  )),
                              child: Image.asset('images/profile_pic.png')),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "편집",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 11,
                    ),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "아이디",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "나이",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "직업",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "지역",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(""),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "편집",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "편집",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "편집",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
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
                      strokeAlign: BorderSide.strokeAlignCenter,
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
                          Text(
                            "취득 희망 분야",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "-IT,컴퓨터",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "-영어",
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "취득 사유",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "-취직",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "-취미",
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "지원 희망 기업",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "-카카오",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "-네이버",
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "소요 기간 및 일정",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "-1개월 내 선호",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "-시험 일정 : 5월 1일 ~ 6월 30일 내",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              top: 28,
                            ),
                            child: DottedLine(
                              direction: Axis.horizontal,
                              lineLength: double.infinity,
                              dashColor:
                              Colors.black.withOpacity(0.24),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: 85,
                            ),
                            child: DottedLine(
                              direction: Axis.horizontal,
                              lineLength: double.infinity,
                              dashColor:
                              Colors.black.withOpacity(0.24),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: 84,
                            ),
                            child: DottedLine(
                              direction: Axis.horizontal,
                              lineLength: double.infinity,
                              dashColor:
                              Colors.black.withOpacity(0.24),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: 83,
                            ),
                            child: DottedLine(
                              direction: Axis.horizontal,
                              lineLength: double.infinity,
                              dashColor:
                              Colors.black.withOpacity(0.24),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            top: 16,
                          ),
                          child: Text(
                            "편집",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 70,
                          ),
                          child: Text(
                            "편집",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 70,
                          ),
                          child: Text(
                            "편집",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 70,
                          ),
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
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Colors.black.withOpacity(0.24),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.only(top: 13.5, left: 21.17),
                              child: Image.asset('images/bookmark.png'),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:6.17,top:13.5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      "북마크",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    child: Text(
                                      "-정보처리기사",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.black
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    child: Text(
                                      "-정보처리기능사",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.black
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    child: Text(
                                      "-리눅스마스터",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.black
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
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
}
