import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';

const String _apiKey = 'AIzaSyDY6JY0aTYqaCNMzkr6tJsWV-CYtEisRA8';

class LicenseaChatbotPage extends StatefulWidget {
  const LicenseaChatbotPage({Key? key}) : super(key: key);

  @override
  _LicenseaChatbotPageState createState() => _LicenseaChatbotPageState();
}

class _LicenseaChatbotPageState extends State<LicenseaChatbotPage> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;

  // 추천 질문 형식
  final String _recommendationMessage = "죄송합니다. 이해하지 못했거나 자격증 관련 질문이 아닙니다.😢 \n\n"
      "다음과 같은 형식으로 질문해주세요: \n"
      "• [자격증 이름]에 대해 알려줘.\n"
      "• [자격증 이름] 시험은 어떻게 준비해야 해?\n"
      "• [희망 기업]에 취직하려면 어떤 자격증이 필요해?\n"
      "• [거주 지역] 주변에서 [자격증]을 취득할 수 있는 곳을 알려줘.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Licensea 챗봇'),
      ),
      body: Consumer<ChatbotState>(
          builder: (context, chatbotState, child) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: chatbotState.scrollController,
                    reverse: true,
                    itemCount: chatbotState.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatbotState.messages[index];
                      return _buildMessage(message, chatbotState);
                    },
                  ),
                ),
                _buildTextComposer(chatbotState),
              ],
            );
          }
      ),
    );
  }

  Widget _buildMessage(ChatMessage message, ChatbotState chatbotState) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Align(
        alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
          message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: MarkdownBody( // MarkdownBody 위젯 사용
                data: message.isExpanded ? message.text : message.truncatedText,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle( // 일반 텍스트 스타일
                    fontSize: 11.5,
                    color: message.isUser ? Colors.white : Colors.black,
                  ),
                  strong: TextStyle( // 굵은 텍스트 스타일
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: message.isUser ? Colors.white : Colors.lightBlueAccent,
                  ),
                  h1: TextStyle( // 문단 제목 1 스타일
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: message.isUser ? Colors.white : Colors.blueAccent,
                  ),
                  h2: TextStyle( // 문단 제목 2 스타일
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: message.isUser ? Colors.white : Colors.indigoAccent,
                  ),
                  h3: TextStyle( // 문단 제목 3 스타일
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: message.isUser ? Colors.white : Colors.indigo,
                  ),
                  em: TextStyle( // 기울어진 글씨 스타일
                    fontSize: 11.5,
                    fontStyle: FontStyle.italic,
                    color: message.isUser ? Colors.white : Colors.black12,
                  ),
                ),
              ),
            ),
            // 더 보기 버튼 (필요한 경우에만 표시)
            if (message.isTruncated)
              TextButton(
                onPressed: () {
                  setState(() {
                    message.isExpanded = !message.isExpanded;
                  });
                },
                child: Text(message.isExpanded ? '접기' : '더 보기'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer(ChatbotState chatbotState) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: (text) => _handleSubmitted(text, chatbotState),
              decoration: InputDecoration.collapsed(hintText: "질문을 입력하세요"),
            ),
          ),
          IconButton(
            icon: _isLoading // 로딩 상태에 따라 아이콘 변경
                ? CircularProgressIndicator() // 로딩 중일 때 CircularProgressIndicator 표시
                : Icon(Icons.send), // 로딩 중이 아닐 때 send 아이콘 표시
            onPressed: _isLoading ? null : () => _handleSubmitted(_textController.text, chatbotState), // 로딩 중일 때 버튼 비활성화
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmitted(String text, ChatbotState chatbotState) async {
    _textController.clear();

    // 사용자 메시지 추가
    ChatMessage userMessage = ChatMessage(
      text: text,
      isUser: true,
    );
    chatbotState.addMessage(userMessage);
    setState(() {
      _isLoading = true; // 로딩 시작
    });

    try {
      // Firebase Database에서 사용자 정보 가져오기
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        DatabaseReference userRef = FirebaseDatabase.instance.ref('users/$userId');
        DataSnapshot infoSnapshot = await userRef.child('info').get();
        DataSnapshot categorySnapshot = await userRef.child('categories').get();

        Map<String, dynamic> userInfo = Map<String, dynamic>.from(infoSnapshot.value as Map);
        List<dynamic> userCategories = List.from(categorySnapshot.value as List);

        if (userInfo != null) {
          // API 요청에 사용자 정보 추가 (화면에 표시되지 않음)
          String augmentedText = '$text\n\n위 질문에 대해 아래 주어진 사용자 정보 및 취득희망 자격증 분야를 참고하여 답변하세요.\n'
              '이름, 생년월일, 지역 등 개인 정보는 답변에 절대 포함하지 마세요.\n'
              '질문 특성 상 답변에 꼭 필요한 경우에 한해 포함하되, 대체어를 고려하여 답변하세요.\n'
              '\n사용자 정보:\n'
              '${userInfo.toString()}\n'
              '취득희망 자격증 분야:\n'
              '${userCategories.join(', ')}';
          print('API 요청 (사용자 정보 포함): $augmentedText');

          // 챗봇 답변 생성 (augmentedText 사용)
          if (chatbotState.isInitialized) {
            final response = await chatbotState.chat.sendMessage(
              Content.text(augmentedText),
            );

            print('API 응답: ${response.text}');

            ChatMessage botMessage = ChatMessage(
              text: response.text ?? "",
              isUser: false,
              isTruncated: response.text!.length > 200,
              isExpanded: false,
            );

            // 답변을 자격증 관련 내용으로 유도
            if (botMessage.truncatedText.contains("자격증") ||
                text.contains("자격증") ||
                text.contains("시험") ||
                text.contains("직업")) {
              chatbotState.addMessage(botMessage);
            } else {
              chatbotState.addMessage(ChatMessage(text: _recommendationMessage, isUser: false));
            }
          } else {
            print('챗봇 초기화 중입니다. 잠시 후 다시 시도해주세요.');
            chatbotState.addMessage(ChatMessage(
              text: '챗봇 초기화 중입니다. 잠시 후 다시 시도해주세요.',
              isUser: false,
            ));
          }
        } else {
          print('사용자 정보를 찾을 수 없습니다.');
          chatbotState.addMessage(ChatMessage(
            text: '사용자 정보를 찾을 수 없습니다. 다시 시도해주세요.',
            isUser: false,
          ));
        }
      } else {
        print('사용자 로그인 정보를 찾을 수 없습니다.');
        chatbotState.addMessage(ChatMessage(
          text: '로그인 후 이용해주세요.',
          isUser: false,
        ));
      }
    } catch (e) {
      print('챗봇 응답 오류: $e');
      // 오류 종류에 따라 다른 메시지 표시
      if (e is TimeoutException) {
        chatbotState.addMessage(ChatMessage(text: "API 응답 시간이 초과되었습니다.",
          isUser: false,
          isError: true,
        ));
      } else if (e is SocketException) {
        chatbotState.addMessage(ChatMessage(text: "네트워크 연결에 문제가 있습니다.",
          isUser: false,
          isError: true,
        ));
      } else {
        chatbotState.addMessage(ChatMessage(text: "오류가 발생했습니다. 다시 시도해주세요.",
          isUser: false,
          isError: true,
        ));
      }
    } finally {
      setState(() {
        _isLoading = false; // 로딩 종료
      });
      chatbotState.scrollDown();
    }
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isTruncated; // 답변이 잘렸는지 여부
  bool isExpanded; // 전체 답변을 보여줄지 여부
  final bool isError; // 에러 메시지인지 여부

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isTruncated = false,
    this.isExpanded = false,
    this.isError = false,
  });

  // 잘린 텍스트 (300자 + ...)
  String get truncatedText => text.length > 300 ? text.substring(0, 300) + "..." : text;
}

class ChatbotState extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  late GenerativeModel _model;
  late ChatSession _chat;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  List<ChatMessage> get messages => _messages;

  ScrollController get scrollController => _scrollController;

  ChatSession get chat => _chat;

  void addMessage(ChatMessage message) {
    _messages.insert(0, message);
    notifyListeners();
  }

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> initialize() async {
    const apiKey = _apiKey;
    if (apiKey == null) {
      print('API 키를 찾을 수 없습니다.');
      return;
    }
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );
    _chat = _model.startChat();

    _isInitialized = true; // 초기화 완료 후 플래그 설정
    notifyListeners(); // 상태 변경 알림
    print(_isInitialized);
  }

  // 로그인 상태 변경 시 챗봇 상태 초기화
  void resetChatbotState() {
    _messages.clear();
    _scrollController.dispose();
    _chat = _model.startChat(); // 새로운 챗 세션 생성
    notifyListeners();
  }
}