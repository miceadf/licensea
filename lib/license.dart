import 'dart:core';

class License {
  String? career;
  String? name;
  String? summary;
  String? trend;
  String? seriesNm;
  String? implNm;
  String? instiNm;

  License({
    required this.career,
    required this.name,
    required this.summary,
    required this.trend,
    required this.seriesNm,
    required this.implNm,
    required this.instiNm,
  });

  factory License.fromMap(Map<String, dynamic> map) {
    return License(
      name: map['jmNm'],
      career: map['career'],
      summary: map['summary'],
      trend: map['trend'],
      seriesNm: map['seriesNm'],
      implNm: map['implNm'],
      instiNm: map['instiNm'],
    );
  }
}