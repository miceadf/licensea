import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'main_page.dart';

class StudyPlanPage extends StatefulWidget {
  @override
  _StudyPlanPageState createState() => _StudyPlanPageState();
}

class _StudyPlanPageState extends State<StudyPlanPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final _formKey = GlobalKey<FormState>();

  int _durationMonths = 1; // 기본값: 1개월
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 30)); // 기본값: 30일 후

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('학습 계획 설정'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '자격증 취득까지 희망하는 소요 기간과 시험 일정을 입력해주세요.',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32.0),
              Text('취득 희망 기간 (개월)'),
              SizedBox(height: 8.0),
              TextFormField(
                initialValue: _durationMonths.toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _durationMonths = int.tryParse(value) ?? 1;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '취득 희망 기간을 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              Text('희망 시험 시작일'),
              SizedBox(height: 8.0),
              _buildDatePicker('시작일', _startDate, (date) {
                setState(() {
                  _startDate = date;
                  // 시작일이 종료일보다 늦으면 종료일도 업데이트
                  if (_startDate.isAfter(_endDate)) {
                    _endDate = _startDate.add(Duration(days: 1));
                  }
                });
              }),
              SizedBox(height: 32.0),
              Text('희망 시험 종료일'),
              SizedBox(height: 8.0),
              _buildDatePicker('종료일', _endDate, (date) {
                setState(() {
                  _endDate = date;
                  // 종료일이 시작일보다 빠르면 시작일도 업데이트
                  if (_endDate.isBefore(_startDate)) {
                    _startDate = _endDate.subtract(Duration(days: 1));
                  }
                });
              }),
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

  // 날짜 선택 위젯 생성 함수
  Widget _buildDatePicker(String label, DateTime initialDate, Function(DateTime) onDateSelected) {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null && pickedDate != initialDate) {
          onDateSelected(pickedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${initialDate.year}년 ${initialDate.month}월 ${initialDate.day}일',
            ),
            Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  // 데이터 저장 함수
  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Firebase Database에 데이터 저장
        await _databaseReference.child('users/$userId/info').update({
          'desiredDurationMonths': _durationMonths,
          'desiredExamStartDate': _startDate.toString().substring(0, 10),
          'desiredExamEndDate': _endDate.toString().substring(0, 10),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('학습 계획이 저장되었습니다.')),
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