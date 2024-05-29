import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:licensea/main_page.dart';

class UserRegistration extends StatefulWidget {
  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  final _formKey = GlobalKey<FormState>();

  // 텍스트 필드 컨트롤러
  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _regionController = TextEditingController();
  String? _selectedOccupation;
  String? _selectedEducation;

  // 파이어베이스 데이터베이스 참조
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.ref('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사용자 등록'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView( // 스크롤 가능하도록 수정
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: '이름'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이름을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _birthdayController,
                  decoration: InputDecoration(labelText: '생년월일 (연/월/일)'),
                  keyboardType: TextInputType.datetime, // 날짜 입력 키보드 사용
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '생년월일을 입력해주세요.';
                    }
                    // 생년월일 형식 검증 추가 가능
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _regionController,
                  decoration: InputDecoration(labelText: '지역 (도,시/구,동)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '지역을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _selectedOccupation,
                  decoration: InputDecoration(labelText: '직업'),
                  items: [
                    DropdownMenuItem(value: '학생', child: Text('학생')),
                    DropdownMenuItem(value: '직장인', child: Text('직장인')),
                    DropdownMenuItem(value: '주부', child: Text('주부')),
                    DropdownMenuItem(value: '파트타임', child: Text('파트타임')),
                    DropdownMenuItem(value: '공무원', child: Text('공무원')),
                    DropdownMenuItem(value: '기타', child: Text('기타')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedOccupation = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return '직업을 선택해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _selectedEducation,
                  decoration: InputDecoration(labelText: '학력'),
                  items: [
                    DropdownMenuItem(value: '초등학교 졸업', child: Text('초등학교 졸업')),
                    DropdownMenuItem(value: '중학교 졸업', child: Text('중학교 졸업')),
                    DropdownMenuItem(value: '고등학교 재학', child: Text('고등학교 재학')),
                    DropdownMenuItem(value: '고등학교 졸업', child: Text('고등학교 졸업')),
                    DropdownMenuItem(value: '대학교 재학', child: Text('대학교 재학')),
                    DropdownMenuItem(value: '대학교 졸업', child: Text('대학교 졸업')),
                    DropdownMenuItem(value: '대학원 재학', child: Text('대학원 재학')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedEducation = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return '학력을 선택해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitData();
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const MainPage()));
                  },
                  child: Text('저장'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 데이터 저장 함수
  void _submitData() {
    _databaseReference.push().set({
      'name': _nameController.text,
      'birthday': _birthdayController.text,
      'region': _regionController.text,
      'occupation': _selectedOccupation,
      'education': _selectedEducation,
    }).then((_) {
      // 성공적으로 저장된 경우
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사용자 정보가 저장되었습니다.')),
      );
    }).catchError((error) {
      // 저장 실패 시 에러 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 실패: $error')),
      );
    });
  }
}