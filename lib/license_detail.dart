import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'license.dart';
import 'license_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class LicenseDetail extends StatelessWidget {
  const LicenseDetail({super.key, required this.license});

  final License license;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인된 사용자 정보 가져오기
    final databaseReference = FirebaseDatabase.instance.ref();

    return Scaffold(
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
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/title.svg', height: 30.0),
        ],
      ),
    ),
      body: Container(
        color: Colors.white,
        child: ZoomIn(
          duration: const Duration(seconds: 1),
          //child: LicenseCard(license: license),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
            color: Colors.white70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ZoomIn(
                  delay: const Duration(microseconds: 500),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              child: Text(
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                license.name.toString(),
                              ),
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //const Expanded(child: SizedBox()),
                ZoomIn(
                  delay: const Duration(seconds: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('● 필요 요구 경력 : ${license.seriesNm}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Inter",
                        ),),
                      Text('● 요구사항: ${license.implNm}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Inter",
                        ),),
                      Text('● 자격증 유지 조건: ${license.instiNm}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Inter",
                        ),),
                      Text('● 설명: ${license.career}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Inter",
                        ),),
                      Text('● 기대되는 역량: ${license.summary == null ? null.toString() : license.summary}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Inter",
                        ),),
                      Text('● 시험 일정: ',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Inter",
                        ),),
                      Text('● 시험 문제 수: ',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Inter",
                        ),),
                      Text('● 시험 시간: ',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Inter",
                        ),),
                      Text('● 공식 홈페이지 주소: ',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Inter",
                        ),),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.black, width: 1)
                            ),
                          ),
                          child: const Text(
                            '취득 후기',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w800,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      TextButton.icon(onPressed:() {}, label: Text("어렵다"), icon: Icon(Icons.accessibility)),
                      TextButton.icon(onPressed:() {}, label: Text("쉽다"), icon: Icon(Icons.accessibility)),
                      TextButton.icon(onPressed:() {}, label: Text("보통이다"), icon: Icon(Icons.accessibility)),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            // 북마크 버튼 클릭 시 데이터베이스에 저장
                            _addBookmark(user, databaseReference, license.name);
                          },
                          icon: Icon(Icons.bookmark),
                        ),
                      ),
                      Expanded(
                          child: Container(
                            child: TextButton(
                              onPressed: () {},
                              child: Text("시험 신청"),
                            ),
                          ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Firebase Realtime Database에 북마크 추가
  void _addBookmark(User? user, DatabaseReference database, String? licenseName) {
    if (user != null && licenseName != null) {
      database.child('users/${user.uid}/bookmarks').once().then((event) {
        DataSnapshot snapshot = event.snapshot;
        List<dynamic> bookmarks = snapshot.value != null
            ? (snapshot.value as Iterable).toList()
            : [];
        bookmarks.add(licenseName);
        database.child('users/${user.uid}/bookmarks').set(bookmarks);
      });
    }
  }
}