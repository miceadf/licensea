import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'license_detail.dart';
import 'license.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'license_list_api.dart';

class AI_License extends StatefulWidget {
  const AI_License({super.key});

  @override
  _AILicenseListApiState createState() => _AILicenseListApiState();
}

class _AILicenseListApiState extends State<AI_License> {
  List<License> _apiLicenses = [];
  Map<String, License?> _recommendedLicenses = {};
  List<String> _userLicenseNames = [];
  bool _isLoadingAPI = false;
  bool _isLoadingFirebase = true;
  int _page = 1;
  int _maxPage = 4;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    print('Firebase 초기화 시작');
    try {
      await Firebase.initializeApp();
      print('Firebase 초기화 완료');
    } catch (e) {
      print('Firebase 초기화 오류: $e');
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      print('사용자 UID: $_userId');
      await _fetchUserLicenses();
      _fetchData();
    } else {
      print('사용자가 로그인하지 않았습니다.');
    }
  }

  Future<void> _fetchUserLicenses() async {
    print('Firebase 데이터 가져오기 시작');
    final database = FirebaseDatabase.instance.ref();
    final userLicensesRef =
    database.child('users').child(_userId!).child('license');

    try {
      final snapshot = await userLicensesRef.get();
      print('스냅샷: ${snapshot.value}');
      if (snapshot.exists) {
        final userLicenses = snapshot.value as List<dynamic>;

        setState(() {
          _userLicenseNames = userLicenses
              .map((value) => value.toString().replaceAll(' ', ''))
              .toList();
          _recommendedLicenses = Map.fromIterable(_userLicenseNames,
              key: (name) => name, value: (name) => null);
          _isLoadingFirebase = false;
        });
        print('Firebase 데이터 가져오기 완료');
      } else {
        print('데이터가 존재하지 않습니다.');
        setState(() {
          _isLoadingFirebase = false;
        });
      }
    } catch (e) {
      print('Firebase 데이터 가져오기 오류: $e');
      setState(() {
        _isLoadingFirebase = false;
      });
    }
  }

  Future<void> _fetchData() async {
    if (_page > _maxPage) {
      print('API 데이터 로딩 완료');
      setState(() {
        _isLoadingAPI = false;
      });
      return;
    }

    setState(() {
      _isLoadingAPI = true;
    });

    String url =
        'http://openapi.q-net.or.kr/api/service/rest/InquiryQualInfo/getList?serviceKey=yeBlEyPYUpcvfhWu46aKhkHF5qWlqEHvfHA%2B9wfdI9D%2FLXYI8NNmfbh8AcKdfdCcF1%2BoLsl8mVKtLNvtCESn1A%3D%3D&seriesCd=0$_page';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = convert.utf8.decode(response.bodyBytes);
      final xml = Xml2Json()..parse(body);
      final json = xml.toParker();

      Map<String, dynamic> jsonResult = convert.jsonDecode(json);
      List<dynamic> list = jsonResult['response']['body']['items']['item'];
      List<License> licenses =
      list.map<License>((e) => License.fromMap(e)).toList();

      setState(() {
        _apiLicenses.addAll(licenses);
        print('API 페이지 로딩: $_page/$_maxPage');
        _page++;
        _isLoadingAPI = false;
      });

      _filterAILicenses();
      _fetchData();
    }
  }

  void _filterAILicenses() {
    print('필터링 실행');
    for (var apiLicense in _apiLicenses) {
      final trimmedApiLicenseName = apiLicense.name!.replaceAll(' ', '');
      print('API: $trimmedApiLicenseName');
      if (_recommendedLicenses.containsKey(trimmedApiLicenseName)) {
        print('일치하는 자격증 발견: $trimmedApiLicenseName');
        setState(() {
          _recommendedLicenses[trimmedApiLicenseName] = apiLicense;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            color: Colors.white,
            child: _isLoadingFirebase
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('AI 추천 자격증 로딩 중...'),
                  SizedBox(height: 16),
                  CupertinoActivityIndicator(radius: 16),
                ],
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: _userLicenseNames.length,
              itemBuilder: (context, index) {
                String licenseName = _userLicenseNames[index];
                License? license = _recommendedLicenses[licenseName];

                return ZoomIn(
                  duration: const Duration(seconds: 1),
                  child: Card(
                    color: const Color(0xff9ADBFF),
                    child: ListTile(
                      onTap: license != null
                          ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LicenseDetail(
                              license: license),
                        ),
                      )
                          : null,
                      contentPadding: const EdgeInsets.all(8),
                      title: Text(
                        '${licenseName} 👍AI 추천',
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: _isLoadingAPI && license == null // API 로딩 중이고 license 정보가 없으면 로딩 표시
                          ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(),
                      )
                          : license != null
                          ? Icon(
                          color: Colors.black54,
                          Icons.arrow_forward) // license 정보가 있으면 '>' 화살표 표시
                          : Text('정보 없음'), // license 정보가 없으면 '정보 없음' 표시
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const License_list_api()),
              );
            },
            child: const Text('다른 자격증을 검색하려면 눌러주세요'),
          ),
        ),
      ],
    );
  }
}