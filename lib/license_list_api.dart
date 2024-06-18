import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'license_detail.dart';
import 'license.dart';
import 'package:flutter_svg/flutter_svg.dart';

class License_list_api extends StatefulWidget {
  const License_list_api({super.key});

  @override
  _LicenseListApiState createState() => _LicenseListApiState();
}

class _LicenseListApiState extends State<License_list_api> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<License> _licenses = [];
  List<License> _filteredLicenses = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _page = 1;
  int _maxPage = 4;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _searchController.addListener(_filterLicenses);
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _fetchData() async {
    if (_page > _maxPage) return;

    setState(() {
      _isLoadingMore = true;
    });

    String url =
        'http://openapi.q-net.or.kr/api/service/rest/InquiryQualInfo/getList?serviceKey=yeBlEyPYUpcvfhWu46aKhkHF5qWlqEHvfHA%2B9wfdI9D%2FLXYI8NNmfbh8AcKdfdCcF1%2BoLsl8mVKtLNvtCESn1A%3D%3D&seriesCd=0$_page';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = convert.utf8.decode(response.bodyBytes);
      final xml = Xml2Json()..parse(body);
      final json = xml.toParker();

      Map<String, dynamic> jsonResult = convert.jsonDecode(json);
      List<dynamic> list = jsonResult['response']['body']['items']['item'];
      List<License> licenses =
      list.map<License>((e) => License.fromMap(e)).toList();

      setState(() {
        _licenses.addAll(licenses);
        _filteredLicenses.addAll(licenses);
        _isLoading = false;
        _isLoadingMore = false;
        _page++;
      });
    }
  }

  void _filterLicenses() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLicenses = _licenses.where((license) {
        return license.name.toString().toLowerCase().contains(query);
      }).toList();
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      _fetchData();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double textWidth = constraints.maxWidth - 134 - 30.0;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset('assets/images/title.svg', height: 30.0),
                const SizedBox(width: 30),
                SizedBox(
                  width: textWidth,
                  child: Text(
                    '\n자격증 정보의 바다',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: textWidth / 17,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: SearchBar(
              leading: Icon(Icons.search),
              backgroundColor: MaterialStatePropertyAll(Colors.white),
              overlayColor:
              MaterialStateColor.resolveWith((states) => Colors.white),
              elevation: MaterialStateProperty.all(3),
              constraints: const BoxConstraints(maxHeight: 100),
              side: MaterialStateProperty.all(
                  const BorderSide(color: Colors.black)),
              hintText: "원하는 자격증을 검색하세요.",
              controller: _searchController,
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              color: Colors.white,
              child: Center(
                child: _isLoading
                    ? const CupertinoActivityIndicator(radius: 16)
                    : _filteredLicenses.isEmpty
                    ? const Text('데이터가 없습니다.')
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _filteredLicenses.length +
                            (_isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _filteredLicenses.length) {
                            return const Center(
                              child: CupertinoActivityIndicator(
                                  radius: 16),
                            );
                          }
                          License license =
                          _filteredLicenses[index];
                          return ZoomIn(
                            duration: const Duration(seconds: 1),
                            child: Card(
                              color: const Color(0xff9ADBFF),
                              child: ListTile(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        LicenseDetail(
                                            license: license),
                                  ),
                                ),
                                contentPadding:
                                const EdgeInsets.all(8),
                                title: Text(
                                  license.name.toString(),
                                  style: TextStyle(
                                      color: Colors.black),
                                ),
                                trailing: const Icon(
                                    color: Colors.black54,
                                    Icons.navigate_next),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('AI 추천 자격증 보기'),
            ),
          ),
        ],
      ),
    );
  }
}