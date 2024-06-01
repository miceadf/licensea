import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:licensea/login.dart';
import 'package:licensea/info.dart';

//회원가입
class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void initState(){
    super.initState();
    print('loaded');
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
              width: MediaQuery.of(context).size.width*0.7,
              child: TextField(decoration: const InputDecoration(labelText: 'Id'),
                  controller: _idController),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.7,
              child: TextField(decoration: const InputDecoration(labelText: 'Password'),
                  controller: _passwordController),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width*0.7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text('로그인 페이지로 이동')),
                    TextButton(onPressed: () async {
                      // 이메일로 회원가입 및 로그인
                      try {
                        await _auth.createUserWithEmailAndPassword(
                          email: _idController.text,
                          password: _passwordController.text,
                        );
                        // 로그인 성공 후 UserRegistration 페이지로 이동
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => UserRegistration()),
                        );
                      } catch (e) {
                        // 오류 발생 시 스낵바로 알림
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('회원가입 실패: ${e.toString()}')),
                        );
                      }
                    }, child: const Text('완료')),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}