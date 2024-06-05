import 'package:flutter/material.dart';
import 'license_list_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "선물함",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                text: "보낸 선물",
              ),
              Tab(
                text: "받은 선물",
              ),
              Tab(
                text: "만료된 선물",
              ),
            ],
            labelColor: const Color(0xFF6B40FF), // 선택된 탭 텍스트 색상
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelColor: Colors.black, // 선택되지 않은 탭 텍스트 색상
            unselectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            indicatorColor: const Color(0xFF6B40FF), // 탭 아래 표시줄 색상
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              color: Colors.white,
              child: License_list_api(),
            ),
            /*
            child: TabBarView(
              controller: _tabController,
              children: [
                // 보낸 선물 탭 내용
                _buildGiftList("보낸 선물"),
                // 받은 선물 탭 내용
                _buildGiftList("받은 선물"),
                // 만료된 선물 탭 내용
                _buildGiftList("만료된 선물"),
              ],
            ),
            */
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        // 수정 가능한 아래 탭바
        child: Container(
          height: 60,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavigationItem(Icons.home, "홈", () {}),
              _buildBottomNavigationItem(Icons.search, "검색", () {}),
              _buildBottomNavigationItem(Icons.favorite, "찜", () {}),
              _buildBottomNavigationItem(Icons.person, "마이", () {}),
            ],
          ),
        ),
      ),
    );
  }

  // 아래 탭바 아이템 위젯
  Widget _buildBottomNavigationItem(
      IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          Text(label),
        ],
      ),
    );
  }

  // 선물 리스트를 보여주는 위젯
  Widget _buildGiftList(String type) {
    // TODO: 실제 데이터를 기반으로 리스트 아이템 생성
    // 예시 데이터
    List<Map<String, dynamic>> giftData = [
      {
        "image": "assets/images/sample_gift_image.png",
        "name": "선물 이름 1",
        "expirationDate": "2023-12-31",
      },
      {
        "image": "assets/images/sample_gift_image.png",
        "name": "선물 이름 2",
        "expirationDate": "2024-01-15",
      },
    ];

    return ListView.builder(
      itemCount: giftData.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.asset(giftData[index]["image"]),
          title: Text(giftData[index]["name"]),
          subtitle: Text("만료일: ${giftData[index]["expirationDate"]}"),
          trailing: type == "보낸 선물"
              ? ElevatedButton(
            onPressed: () {
              // TODO: 선물 다시 보내기 기능 구현
            },
            child: const Text("다시 보내기"),
          )
              : null,
        );
      },
    );
  }
}