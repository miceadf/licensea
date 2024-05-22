import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

//개인 데이터
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> readData() async {
  FirebaseDatabase realtime = FirebaseDatabase.instance;
  DataSnapshot snapshot = await realtime.ref().child("info").get();
  Map<dynamic, dynamic> value = snapshot.value as Map<dynamic, dynamic>;

  setDBData(value.category);
}

void setDBData(String category, String name) {
  setState((){
    _
  })
}