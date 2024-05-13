import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'license_detail.dart';
import 'license.dart';
import 'package:dio/dio.dart';

class Screen4 extends StatelessWidget {
  const Screen4({super.key});

  Future<List<License>> readData() async {
    String url = 'http://openapi.q-net.or.kr/api/service/rest/InquiryQualInfo/getList?serviceKey=yeBlEyPYUpcvfhWu46aKhkHF5qWlqEHvfHA%2B9wfdI9D%2FLXYI8NNmfbh8AcKdfdCcF1%2BoLsl8mVKtLNvtCESn1A%3D%3D&seriesCd=04';
    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200) {
      final body = convert.utf8.decode(response.bodyBytes);
      final xml = Xml2Json()..parse(body);
      final json =xml.toParker();

      Map<String, dynamic> jsonResult = convert.jsonDecode(json);
      List<dynamic> list = jsonResult['response']['body']['items']['item'];

      return list.map<License>((e) => License.fromMap(e)).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
          future: readData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CupertinoActivityIndicator(radius: 16,);
            }
            if (!snapshot.hasData) {
              return const Text('데이터가 없습니다.');
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                ),
                Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        License license = snapshot.data![index];
                        return ZoomIn(
                          duration: const Duration(seconds: 1),
                          child: Card(
                            color: Colors.black38,
                            child: ListTile(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LicenseDetail(license: license),
                                ),
                              ),
                              contentPadding:  const EdgeInsets.all(8),
                              title: Text(license.name.toString()),
                              trailing: const Icon(color: Colors.black54, Icons.navigate_next),
                            ),
                          ),
                        );
                      },
                    )
                )
              ],
            );
          }
      ),
    );
  }
}