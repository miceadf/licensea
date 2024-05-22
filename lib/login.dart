import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'register.dart';
import 'main_page.dart';

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
    // 로그인 시 사용자 인증을 거친 다음에 상태 초기화
    await _auth.signInWithEmailAndPassword(
        email: _idController.text, password: _passwordController.text);
    setState(() {});
    print('login state');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login Page'),
            Image.asset('assets/images/title.png'),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextField(
                    decoration: const InputDecoration(labelText: 'Id'),
                    controller: _idController)),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextField(
                  decoration: const InputDecoration(
                      labelText: 'Password',
                  ),
                  obscureText: _obsecure,
                  controller: _passwordController,

                )),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
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
                      child: const Text('sign up')),
                  TextButton(
                    onPressed: () {
                      loginFunc();
                      setState(() {
                        _idController.clear();
                        _passwordController.clear();
                        Future.delayed(const Duration(seconds: 1));
                        if(authState()) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainPage()));
                        }
                      });
                    },
                    child: const Text('log in'),
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
