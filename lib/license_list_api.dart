import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'license_detail.dart';
import 'license.dart';
import 'package:dio/dio.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  Future<List<License>> readData() async {
    List<dynamic> result = [];
    for (int i = 1; i <= 4 ; i++) {
      String url = 'http://openapi.q-net.or.kr/api/service/rest/InquiryQualInfo/getList?serviceKey=yeBlEyPYUpcvfhWu46aKhkHF5qWlqEHvfHA%2B9wfdI9D%2FLXYI8NNmfbh8AcKdfdCcF1%2BoLsl8mVKtLNvtCESn1A%3D%3D&seriesCd=0$i';
      final response = await http.get(Uri.parse(url));

      if(response.statusCode == 200) {
        final body = convert.utf8.decode(response.bodyBytes);
        final xml = Xml2Json()..parse(body);
        final json =xml.toParker();

        Map<String, dynamic> jsonResult = convert.jsonDecode(json);
        List<dynamic> list = jsonResult['response']['body']['items']['item'];
        result.addAll(list);
      }
    }
    return result.map<License>((e) => License.fromMap(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: SearchBar(
            leading: Icon(Icons.search),
            backgroundColor: MaterialStatePropertyAll(Colors.white),
            //trailing: [IconButton(onPressed: null,icon: Icon(Icons.search))],
            overlayColor: MaterialStateColor.resolveWith((states) => Colors.white),
            elevation: MaterialStateProperty.all(3),
            constraints: const BoxConstraints(maxHeight: 100),
            side: MaterialStateProperty.all(
              const BorderSide(color: Colors.black),
            ),
            hintText: "원하는 자격증을 검색하세요.",
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: const Center(
              child: Text(
                'IT관련 자격증입니다.\n자격증에 대한 정보를 얻으시려면 터치하세요.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            color: Colors.white,
            child: Center(
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
            ),
          ),
        ),
      ],
    );
  }
}
