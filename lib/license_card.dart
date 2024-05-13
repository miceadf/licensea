import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'license.dart';

class LicenseCard extends StatelessWidget {
  const LicenseCard({super.key, required this.license});

  final License license;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      clipBehavior: Clip.antiAlias,
      elevation: 24,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          width: 2,
          color: Colors.blueGrey,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ZoomIn(
              delay: const Duration(microseconds: 500),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        license.name.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            ZoomIn(
              delay: const Duration(seconds: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    '정보',
                  ),
                  Text('seriesNm : ${license.seriesNm}',
                    style: TextStyle(color: Colors.black),),
                  Text('implNm: ${license.implNm}',
                    style: TextStyle(color: Colors.black),),
                  Text('instiNm: ${license.instiNm}',
                    style: TextStyle(color: Colors.black),),
                  Text('career: ${license.career}',
                    style: TextStyle(color: Colors.black),),
                  Text('summary: ${license.summary}',
                    style: TextStyle(color: Colors.black),),
                  Text('trend: ${license.trend}',
                    style: TextStyle(color: Colors.black),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}