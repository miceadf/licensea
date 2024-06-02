import 'package:flutter/material.dart';
import 'login.dart';
import 'intro.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//인트로 화면 실행 용
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
            home: FutureBuilder(
              future: Future.delayed(
                  const Duration(seconds: 3), () => "Intro Completed."),
              builder: (context, snapshot) {
                return AnimatedSwitcher(
                    duration: const Duration(seconds: 3),
                    child: _splashLoadingWidget(snapshot));
              },
            ));
  }

  Widget _splashLoadingWidget(AsyncSnapshot<Object?> snapshot) {
    if (snapshot.hasError) {
      return const Text("Error!!");
    } else if (snapshot.hasData) {
      return const LoginPage();
    } else {
      return const IntroPage();
    }
  }
}