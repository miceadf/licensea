// main.dart
import 'package:flutter/material.dart';
import 'login.dart';
import 'intro.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'chatbot.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ChatbotState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'PretendardVariable'
      ),
      home: IntroPageWrapper(),
    );
  }
}

class IntroPageWrapper extends StatefulWidget {
  const IntroPageWrapper({Key? key}) : super(key: key);

  @override
  State<IntroPageWrapper> createState() => _IntroPageWrapperState();
}

class _IntroPageWrapperState extends State<IntroPageWrapper> {
  @override
  void initState() {
    super.initState();
    _initializeChatbotAndNavigate();
  }

  Future<void> _initializeChatbotAndNavigate() async {
    await Provider.of<ChatbotState>(context, listen: false).initialize();
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const IntroPage();
  }
}
