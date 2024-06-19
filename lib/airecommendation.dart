import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIRecommendationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  late GenerativeModel _model;

  Future<void> initialize() async {
    const apiKey = 'AIzaSyDY6JY0aTYqaCNMzkr6tJsWV-CYtEisRA8';
    if (apiKey == null) {
      print('API 키를 찾을 수 없습니다.');
      return;
    }
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );
  }

  Future<void> updateRecommendations() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;

      // 사용자 정보 가져오기
      DataSnapshot userInfoSnapshot = await _databaseReference.child('users/$userId/info').get();
      Map<String, dynamic> userInfo = Map<String, dynamic>.from(userInfoSnapshot.value as Map);

      // 사용자 선호 카테고리 가져오기
      DataSnapshot categoriesSnapshot = await _databaseReference.child('users/$userId/categories').get();
      List<dynamic> selectedCategories = List.from(categoriesSnapshot.value as List);

      // "추천 완료" 확인
      DataSnapshot infoSnapshot = await _databaseReference.child('users/$userId/settings').get();
      bool recommendationCompleted = infoSnapshot.child('recommendationCompleted').value as bool? ?? false;

      if(!recommendationCompleted) {
        // AI 모델에 전달할 프롬프트 생성
        String prompt = _generatePrompt(userInfo, selectedCategories);

        // AI 추천 결과 가져오기
        String recommendations = await _getAIRecommendations(prompt);

        // 추천 결과 파싱 및 저장
        List<String> licenseList = _parseRecommendations(recommendations);
        await _databaseReference.child('users/$userId/license').set(licenseList);

        // "추천 완료" 업데이트
        await _databaseReference.child('users/$userId/settings').update({'recommendationCompleted': true});
        print('AI 추천 자격증 저장 완료: $licenseList');
      } else {
        print('이미 AI 추천을 받은 유저입니다.');
      }
    } else {
      print('사용자 로그인 정보를 찾을 수 없습니다.');
    }
  }

  String _generatePrompt(Map<String, dynamic> userInfo, List<dynamic> categories) {
    String prompt = "다음 사용자 정보를 바탕으로 자격증을 추천해주세요.\n\n";
    prompt += "사용자 정보:\n";
    prompt += "• 생년월일: ${userInfo['birthday']}\n";
    prompt += "• 거주지역: ${userInfo['region']}\n";
    prompt += "• 직업: ${userInfo['occupation']}\n";
    prompt += "• 학력: ${userInfo['education']}\n";
    prompt += "• 대학교: ${userInfo['university'] != null ? userInfo['university'] : '사용자가 다닌 대학 정보가 없습니다.'}\n";
    prompt += "• 학과: ${userInfo['department'] != null ? userInfo['department'] : '사용자가 다닌 대학 학과 정보가 없습니다.'}\n";
    prompt += "• 회사: ${userInfo['company'] != null ? userInfo['company'] : '사용자는 회사에 다니지 않습니다.'}\n";
    prompt += "• 취득 희망 사유: ${userInfo['reason']}\n";
    prompt += "• 지원 희망 기업: ${userInfo['desiredCompany']}\n";
    prompt += "• 희망 소요 기간 (개월): ${userInfo['desiredDurationMonths']}\n";
    prompt += "• 희망 시험 시작일: ${userInfo['desiredExamStartDate']}\n";
    prompt += "• 희망 시험 종료일: ${userInfo['desiredExamEndDate']}\n";
    prompt += "\n취득 선호 자격증 분야:\n";
    categories.forEach((category) {
      prompt += "• $category\n";
    });
    prompt += '''
      \n주의 사항:
      * 각 자격증 이름은 '**자격증 이름**' 형태로 출력해야 합니다.
      * 다른 텍스트나 설명 없이 반드시 자격증 이름만 출력해야 합니다.
      * 분야별로 최대 2개, 전체 10개 이내로 출력해야 합니다.
      예시:
      **정보처리기사**
      **네트워크관리사**
      **금속가공기술사**
      ''';
    print('생성된 프롬프트: $prompt'); // 프롬프트 출력
    return prompt;
  }

  Future<String> _getAIRecommendations(String prompt) async {
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      print('AI 응답: ${response.text}'); // AI 응답 출력
      return response.text ?? "";
    } catch (e) {
      print('AI 추천 오류: $e');
      return "추천을 불러오는 중 오류가 발생했습니다.";
    }
  }

  List<String> _parseRecommendations(String recommendations) {
    List<String> licenseList = [];

    // "**"로 감싸진 텍스트를 찾는 정규 표현식
    RegExp regex = RegExp(r'\*\*(.+?)\*\*');
    Iterable<Match> matches = regex.allMatches(recommendations);

    // 찾은 텍스트를 리스트에 추가
    for (Match match in matches) {
      licenseList.add(match.group(1)!);
    }

    print('파싱된 자격증 리스트: $licenseList'); // 파싱된 리스트 출력
    // 최대 10개까지만 저장
    return licenseList.sublist(0, licenseList.length > 10 ? 10 : licenseList.length);
  }
}