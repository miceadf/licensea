import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'license.dart';
import 'license_card.dart';

class LicenseDetail extends StatelessWidget {
  const LicenseDetail({super.key, required this.license});

  final License license;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ZoomIn(
          duration: const Duration(seconds: 1),
          child: LicenseCard(license: license),
        ),
      ),
    );
  }
}