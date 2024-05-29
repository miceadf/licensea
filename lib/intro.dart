import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';

//인트로 화면
class introPage extends StatelessWidget {
  const introPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'licensea',
              style: TextStyle(
                fontSize: 48,
                fontStyle: FontStyle.italic,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w800,
                height: 0,
              ),
            ),
            Text(
              '자   격   증       정   보   의       바   다',
              textAlign: TextAlign.center,

              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
          ],
        ),
      )
    );
  }
}
