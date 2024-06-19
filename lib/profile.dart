import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login.dart';
import 'info.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  late DatabaseReference _userRef;
  Map<dynamic, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _userRef = FirebaseDatabase.instance.ref().child('users/${user.uid}');
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final snapshot = await _userRef.once();
      if (snapshot.snapshot.value != null) {
        setState(() {
          _userData = snapshot.snapshot.value as Map<dynamic, dynamic>?;
        });
      }
    } catch (error) {
      print('Error loading user data: $error');
      // 에러 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    Map? userInfo = _userData?['info'] as Map? ?? {};
    List<dynamic>? userCategories = _userData?['categories'] as List? ?? [];
    List<dynamic>? userBookmarks = _userData?['bookmarks'] as List? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
      ),
      body: _userData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 이미지 및 기본 정보
            _buildProfileSection(userInfo),
            const SizedBox(height: 32.0),

            // 자격증 추천 정보
            _buildCertificationSection(userInfo, userCategories),
            const SizedBox(height: 32.0),

            // 북마크
            _buildBookmarkSection(userBookmarks),
            const SizedBox(height: 32.0),

            // 로그아웃 및 수정 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text('로그아웃'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserRegistration()),
                    );
                  },
                  child: const Text('수정'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(Map? userInfo) {
    return Row(
      children: [
        Container(
          width: 80.0,
          height: 80.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey,
              width: 2.0,
            ),
          ),
          child: ClipOval(
            child: SvgPicture.asset(
              'assets/images/profile_pic.svg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.email ?? '이메일 없음',
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              _buildInfoText('생년월일\t', userInfo?['birthday'] ?? '없음'),
              _buildInfoText('직업\t', userInfo?['occupation'] ?? '없음'),
              _buildInfoText('지역\t', userInfo?['region'] ?? '없음'),
              _buildInfoText('학교\t', userInfo?['university'] ?? '없음'),
              _buildInfoText('학과\t', userInfo?['department'] ?? '없음'),
              _buildInfoText('회사\t', userInfo?['company'] ?? '없음'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCertificationSection(
      Map? userInfo, List<dynamic>? userCategories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '추가 정보',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        // userCategories가 List이므로 ListView.builder를 사용하여 표시
        _buildInfoText('취득 희망 분야',
            (userCategories != null && userCategories.isNotEmpty)
                ? userCategories.join('\n')
                : '없음'),
        _buildInfoText('취득 희망 사유', userInfo?['reason'] ?? '없음'),
        _buildInfoText('지원 희망 기업', userInfo?['desiredCompany'] ?? '없음'),
        _buildInfoText(
            '희망 소요 기간',
            userInfo?['desiredDurationMonths'] != null
                ? '${userInfo?['desiredDurationMonths']}개월'
                : '없음'),
        _buildInfoText(
            '희망 시험 일정',
            userInfo?['desiredExamStartDate'] != null &&
                userInfo?['desiredExamEndDate'] != null
                ? '${userInfo?['desiredExamStartDate']} ~ ${userInfo?['desiredExamEndDate']}'
                : '없음'),
      ],
    );
  }

  Widget _buildBookmarkSection(List<dynamic>? userBookmarks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '북마크',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        if (userBookmarks != null && userBookmarks.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: userBookmarks.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('• '+userBookmarks[index].toString()),
              );
            },
          )
        else
          const Text('북마크가 없습니다.'),
      ],
    );
  }

  Widget _buildInfoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}