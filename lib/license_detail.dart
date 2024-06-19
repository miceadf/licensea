import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'license.dart';
import 'license_card.dart';

class LicenseDetail extends StatefulWidget {
  const LicenseDetail({super.key, required this.license});

  final License license;

  @override
  State<LicenseDetail> createState() => _LicenseDetailState();
}

class _LicenseDetailState extends State<LicenseDetail> {
  bool isBookmarked = false; // 북마크 상태 (기본값: false)

  @override
  void initState() {
    super.initState();
    _checkBookmark(); // 앱 시작 시 북마크 상태 확인
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.ref();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        shape: const Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1,
            )),
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
                                  widget.license.name.toString(), // widget.license 사용
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
                      Text('● 필요 요구 경력 : ${widget.license.seriesNm}', // widget.license 사용
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Inter",
                        ),),
                      Text('● 요구사항: ${widget.license.implNm}', // widget.license 사용
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Inter",
                        ),),
                      Text('● 자격증 유지 조건: ${widget.license.instiNm}', // widget.license 사용
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Inter",
                        ),),
                      Text('● 설명: ${widget.license.career}', // widget.license 사용
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Inter",
                        ),),
                      Text('● 기대되는 역량: ${widget.license.summary == null ? null.toString() : widget.license.summary}', // widget.license 사용
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
                        child: IconButton(onPressed: () {
                          _toggleBookmark(user, databaseReference, widget.license.name); // widget.license 사용
                        }, icon: Icon(Icons.bookmark, color: isBookmarked ? Colors.blueAccent : Colors.black,)),
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

  // 북마크 상태 확인 함수
  void _checkBookmark() async {
    final user = FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.ref();

    if (user != null) {
      databaseReference
          .child('users/${user.uid}/bookmarks')
          .once()
          .then((event) {
        List<dynamic> bookmarks = event.snapshot.value != null
            ? (event.snapshot.value as Iterable).toList()
            : [];

        if (bookmarks.contains(widget.license.name)) { // widget.license 사용
          setState(() {
            isBookmarked = true;
          });
        }
      });
    }
  }

  // 북마크 토글 함수
  void _toggleBookmark(
      User? user, DatabaseReference databaseReference, String? licenseName) async {
    if (user != null && licenseName != null) {
      databaseReference
          .child('users/${user.uid}/bookmarks')
          .once()
          .then((event) {
        List<dynamic> bookmarks = event.snapshot.value != null
            ? (event.snapshot.value as Iterable).toList()
            : [];

        if (bookmarks.contains(licenseName)) {
          // 이미 북마크 되어 있는 경우 제거
          bookmarks.remove(licenseName);
          setState(() {
            isBookmarked = false;
          });
        } else {
          // 북마크 되어 있지 않은 경우 추가
          bookmarks.add(licenseName);
          setState(() {
            isBookmarked = true;
          });
        }

        // 데이터베이스 업데이트
        databaseReference
            .child('users/${user.uid}/bookmarks')
            .set(bookmarks);
      });
    }
  }
}