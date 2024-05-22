import 'package:flutter/material.dart';
import 'login.dart';
import 'intro.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final ValueNotifier<ThemeMode> themeNotfier = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotfier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.lightBlue,
              textTheme: const TextTheme(
                  headline3: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic)),
            ),
            darkTheme: ThemeData.dark(),
            themeMode: currentMode,
            home: FutureBuilder(
              future: Future.delayed(
                  const Duration(seconds: 3), () => "Intro Completed."),
              builder: (context, snapshot) {
                return AnimatedSwitcher(
                    duration: const Duration(seconds: 3),
                    child: _splashLoadingWidget(snapshot));
              },
            ));
      },
    );
  }

  Widget _splashLoadingWidget(AsyncSnapshot<Object?> snapshot) {
    if (snapshot.hasError) {
      return const Text("Error!!");
    } else if (snapshot.hasData) {
      return const LoginPage();
    } else {
      return const introPage();
    }
  }
}