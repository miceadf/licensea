import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:licensea/login.dart';
import 'info.dart';
import 'main_page.dart';

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
            const Text('Register Page'),
            SvgPicture.asset('assets/images/title.svg'),
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
                  TextButton(onPressed: (){
                    setState(() {});
                    print(_idController.text);
                    _auth.createUserWithEmailAndPassword(
                        email: _idController.text, password: _passwordController.text).then((value)=>_auth.signOut());
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>UserRegistration()));
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