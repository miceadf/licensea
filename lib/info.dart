import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:licensea/home.dart';
import 'package:licensea/main_page.dart';

class UserRegistration extends StatefulWidget {
  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  final _formKey = GlobalKey<FormState>();

  // 텍스트 필드 컨트롤러
  final _nameController = TextEditingController();
  String? _selectedOccupation;
  String? _selectedEducation;
  final _universityController = TextEditingController();
  final _departmentController = TextEditingController();
  final _companyController = TextEditingController();

  // 파이어베이스 인증 인스턴스
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 생년월일 드롭다운 메뉴
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;
  int _selectedDay = DateTime.now().day;

  // 지역 드롭다운 메뉴
  String? _selectedSido;
  String? _selectedGugun;
  String? _selectedDong;

  // 지역 데이터 (실제 데이터로 변경 필요)
  final List<String> _sidoList = [
    '서울특별시',
    '부산광역시',
    '대구광역시',
    // ... other Sido
  ];
  final Map<String, List<String>> _gugunList = {
    '서울특별시': ['강남구', '강동구', '강북구', '강서구', '...'],
    '부산광역시': ['강서구', '금정구', '기장군', '남구', '...'],
    // ... other Gugun
  };
  final Map<String, List<String>> _dongList = {
    '서울특별시-강남구': ['개포동', '논현동', '대치동', '...'],
    '서울특별시-강동구': ['강일동', '길동', '둔촌동', '...'],
    // ... other Dong
  };

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
          child: SingleChildScrollView(
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
                // 생년월일 입력 (드롭다운 메뉴 사용)
                Row(
                  children: [
                    // 연도 선택
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _selectedYear,
                        decoration: InputDecoration(labelText: '년'),
                        items: List.generate(100, (index) {
                          int year = DateTime.now().year - index;
                          return DropdownMenuItem(
                            value: year,
                            child: Text('$year'),
                          );
                        }),
                        onChanged: (value) {
                          setState(() {
                            _selectedYear = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 16.0),
                    // 월 선택
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _selectedMonth,
                        decoration: InputDecoration(labelText: '월'),
                        items: List.generate(12, (index) {
                          int month = index + 1;
                          return DropdownMenuItem(
                            value: month,
                            child: Text('$month'),
                          );
                        }),
                        onChanged: (value) {
                          setState(() {
                            _selectedMonth = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 16.0),
                    // 일 선택
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _selectedDay,
                        decoration: InputDecoration(labelText: '일'),
                        items: _getDaysInMonth(_selectedYear, _selectedMonth)
                            .map((day) => DropdownMenuItem(
                          value: day,
                          child: Text('$day'),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDay = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                // 지역 선택 (드롭다운 메뉴 사용)
                Row(
                  children: [
                    // 시/도 선택
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedSido,
                        decoration: InputDecoration(labelText: '시/도'),
                        items: _sidoList
                            .map((sido) => DropdownMenuItem(
                          value: sido,
                          child: Text(sido),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSido = value;
                            _selectedGugun = null; // 시/도 변경 시 구/군 초기화
                            _selectedDong = null; // 시/도 변경 시 동 초기화
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 16.0),
                    // 구/군 선택
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedGugun,
                        decoration: InputDecoration(labelText: '구/군'),
                        items: _selectedSido != null
                            ? _gugunList[_selectedSido]!
                            .map((gugun) => DropdownMenuItem(
                          value: gugun,
                          child: Text(gugun),
                        ))
                            .toList()
                            : [],
                        onChanged: (value) {
                          setState(() {
                            _selectedGugun = value;
                            _selectedDong = null; // 구/군 변경 시 동 초기화
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 16.0),
                    // 동 선택
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedDong,
                        decoration: InputDecoration(labelText: '동'),
                        items: _selectedSido != null && _selectedGugun != null
                            ? _dongList['$_selectedSido-$_selectedGugun']!
                            .map((dong) => DropdownMenuItem(
                          value: dong,
                          child: Text(dong),
                        ))
                            .toList()
                            : [],
                        onChanged: (value) {
                          setState(() {
                            _selectedDong = value;
                          });
                        },
                      ),
                    ),
                  ],
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
                // 직업이 학생이고 학력이 대학교/대학원 재학일 때만 표시
                if ((_selectedOccupation == '학생' &&
                    (_selectedEducation == '대학교 재학' ||
                        _selectedEducation == '대학원 재학')) ||
                        _selectedEducation == '대학교 졸업')
                  Column(
                    children: [
                      TextFormField(
                        controller: _universityController,
                        decoration: InputDecoration(labelText: '대학교'),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _departmentController,
                        decoration: InputDecoration(labelText: '학과'),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),

                // 직업이 직장인일 때만 표시
                if (_selectedOccupation == '직장인')
                  Column(
                    children: [
                      TextFormField(
                        controller: _companyController,
                        decoration: InputDecoration(labelText: '회사'),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitData();
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePage()));
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
  void _submitData() async {
    // 현재 로그인한 사용자 가져오기
    User? user = _auth.currentUser;

    if (user != null) {
      // 로그인한 사용자의 UID 가져오기
      String userId = user.uid;

      // 사용자 UID 아래에 정보 저장
      final DatabaseReference userRef =
      FirebaseDatabase.instance.ref('users/$userId');

      String birthday = '$_selectedYear/$_selectedMonth/$_selectedDay';
      String region =
          '$_selectedSido $_selectedGugun $_selectedDong';
      Map<String, dynamic> userData = {
        'name': _nameController.text,
        'birthday': birthday,
        'region': region,
        'occupation': _selectedOccupation,
        'education': _selectedEducation,
      };

      // 직업이 학생이고 학력이 대학교/대학원 재학/졸업일 때 대학교, 학과 추가
      if (_selectedOccupation == '학생' &&
          (_selectedEducation == '대학교 재학' ||
              _selectedEducation == '대학원 재학')) {
        userData['university'] = _universityController.text;
        userData['department'] = _departmentController.text;
      }
      if (_selectedEducation == '대학교 졸업') {{
        userData['university'] = _universityController.text;
        userData['department'] = _departmentController.text;
      }}
      // 직업이 직장인일 때 회사 추가
      if (_selectedOccupation == '직장인') {
        userData['company'] = _companyController.text;
      }

      userRef.set({
        userData
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사용자 정보가 저장되었습니다.')),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const MainPage()));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $error')),
        );
      });
    } else {
      // 로그인하지 않은 경우 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 후 이용해주세요.')),
      );
    }
  }

  // 해당 연도/월의 일 수를 반환하는 함수
  List<int> _getDaysInMonth(int year, int month) {
    int daysInMonth = DateTime(year, month + 1, 0).day;
    return List.generate(daysInMonth, (index) => index + 1);
  }
}