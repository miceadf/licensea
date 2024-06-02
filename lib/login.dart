import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:licensea/home.dart';
import 'register.dart';
import 'package:flutter_svg/svg.dart';

//로그인
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idController = TextEditingController(); // 아이디 입력 컨트롤러
  final _passwordController = TextEditingController(); // 비밀번호 입력 컨트롤러
  final _auth = FirebaseAuth.instance; // 파이어베이스 인증 객체
  var _obsecure = true;
  var _iconButton = '';

  @override
  void initState() {
    super.initState();
    print('load page');
  }

  bool authState() {
    // 로그인 상태를 확인하고 반환하는 위젯
    return _auth.currentUser == null
        ? false : true;
  }

  void loginFunc() async {
    // 로딩 팝업 표시
    showDialog(
      context: context,
      barrierDismissible: false, // 팝업 이외의 영역 터치 방지
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(), // 로딩 표시
        );
      },
    );

    try {
      await _auth.signInWithEmailAndPassword(
        email: _idController.text,
        password: _passwordController.text,
      );

      // 로그인 성공 시 팝업 닫고 HomePage로 이동
      Navigator.pop(context); // 팝업 닫기
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      // 로그인 실패 시 팝업 닫고 오류 메시지 표시
      Navigator.pop(context); // 팝업 닫기
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: ${e.toString()}')),
      );
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 50.0,
                ),
                child: SvgPicture.asset('assets/images/title.svg'),
              ),
              SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.7,
                  child: TextField(
                      decoration: const InputDecoration(labelText: 'Id'),
                      controller: _idController)),
              SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.7,
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: _obsecure,
                    controller: _passwordController,

                  )),
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const registerPage()),
                          );
                        },
                        child: const Text('회원가입')),
                    TextButton(
                      onPressed: () {
                        // 로그인 함수 호출
                        loginFunc();
                        setState(() {
                          _idController.clear();
                          _passwordController.clear();
                        });
                      },
                      child: const Text('로그인'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }