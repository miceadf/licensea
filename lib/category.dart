import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:licensea/addinfo.dart';

class CategorySelectionPage extends StatefulWidget {
  @override
  _CategorySelectionPageState createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  List<String> _selectedCategories = [];
  String _selectedCategoryInfo = ''; // 선택된 카테고리 정보를 저장하는 변수
  final Map<String, List<String>> _categoryExamples = {
    '건설/건축/토목': ['건축기사', '토목기사', '건설안전기사'],
    '기계/금속/자동차': ['기계설계기사', '용접기사', '자동차정비기사'],
    '전기/전자/정보통신': ['전기기사', '전자기사', '정보처리기사'],
    'IT/컴퓨터/소프트웨어': ['정보보안기사', '네트워크관리사', '웹디자인기능사'],
    '디자인/예술/문화': ['시각디자인기사', '제품디자인기사', '컬러리스트기사'],
    '경영/사무/금융': ['회계관리사', '세무사', '공인중개사'],
    '의료/보건/미용': ['간호사', '의사', '약사'],
    '교육/어학/자격': ['교원자격증', '한국어교원자격증', '통번역자격증'],
    '서비스/관광/요리': ['조리기능사', '바리스타', '호텔경영사'],
    '농림/축산/환경': ['산림기사', '축산기사', '환경기능사'],
  };
  final List<String> _categories = [
    '건설/건축/토목',
    '기계/금속/자동차',
    '전기/전자/정보통신',
    'IT/컴퓨터/소프트웨어',
    '디자인/예술/문화',
    '경영/사무/금융',
    '의료/보건/미용',
    '교육/어학/자격',
    '서비스/관광/요리',
    '농림/축산/환경',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('관심 분야 선택'),
        automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '관심 있는 분야를 최소 하나 이상 선택해주세요.',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return ListTile(
                    title: Text(category),
                    onTap: () {
                      setState(() {
                        if (_selectedCategories.contains(category)) {
                          _selectedCategories.remove(category);
                          _selectedCategoryInfo = ''; // 선택 해제 시 정보 초기화
                        } else {
                          _selectedCategories.add(category);
                          _selectedCategoryInfo = category; // 선택 시 정보 업데이트
                        }
                      });
                    },
                    trailing: _selectedCategories.contains(category)
                        ? Icon(Icons.check)
                        : null,
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            // 선택된 카테고리 정보 표시
            if (_selectedCategoryInfo.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '$_selectedCategoryInfo 자격증: ${_categoryExamples[_selectedCategoryInfo]?.join(', ')} 등',
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _selectedCategories.isNotEmpty
                  ? _saveCategories
                  : null,
              child: Text('저장'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveCategories() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;

      // 선택된 카테고리들을 Firebase Database에 저장
      await _databaseReference.child('users/$userId/categories').set(_selectedCategories);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('관심 분야가 저장되었습니다.')),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalInfoPage()));
    } else {
      // 로그인하지 않은 경우 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 후 이용해주세요.')),
      );
    }
  }
}