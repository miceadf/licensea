import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:licensea/main_page.dart';

class AdditionalInfoPage extends StatefulWidget {
  @override
  _AdditionalInfoPageState createState() => _AdditionalInfoPageState();
}

class _AdditionalInfoPageState extends State<AdditionalInfoPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final _formKey = GlobalKey<FormState>();

  String? _selectedReason;
  final TextEditingController _companyController = TextEditingController();
  final List<String> _reasons = [
    '취업',
    '학업',
    '취미',
    '자기계발',
    '이직',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('추가 정보 입력'),
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '추가 정보를 입력해주세요.',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32.0),
              Text('취득 희망 사유'),
              SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                value: _selectedReason,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: _reasons.map((reason) => DropdownMenuItem(
                  value: reason,
                  child: Text(reason),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedReason = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return '취득 희망 사유를 선택해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              Text('지원 희망 기업 (선택 사항)'),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _companyController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '없음',
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) { // 폼 유효성 검사
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        // Firebase Database에 데이터 저장
        await _databaseReference.child('users/$userId/info').update({
          'reason': _selectedReason,
          'company': _companyController.text.isEmpty ? '없음' : _companyController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('정보가 저장되었습니다.')),
        );
        // 다음 페이지로 이동
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 후 이용해주세요.')),
        );
      }
    }
  }
}