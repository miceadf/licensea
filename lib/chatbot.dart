import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const String _apiKey = 'AIzaSyDY6JY0aTYqaCNMzkr6tJsWV-CYtEisRA8';

class LicenseaChatbotPage extends StatefulWidget {
  const LicenseaChatbotPage({Key? key}) : super(key: key);

  @override
  _LicenseaChatbotPageState createState() => _LicenseaChatbotPageState();
}

class _LicenseaChatbotPageState extends State<LicenseaChatbotPage> {
  late final GenerativeModel _model;
  late final ChatSession _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  // 추천 질문 형식
  final String _recommendationMessage = "죄송합니다. 이해하지 못했거나 자격증 관련 질문이 아닙니다. \n\n"
      "다음과 같은 형식으로 질문해주세요: \n"
      "• [자격증 이름]에 대해 알려줘.\n"
      "• [자격증 이름] 시험은 어떻게 준비해야 해?\n"
      "• [직업]이 되려면 어떤 자격증이 필요해?";

  @override
  void initState() {
    super.initState();
    _initializeGemini();
  }

  Future<void> _initializeGemini() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Licensea 챗봇'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessage(message);
              },
            ),
          ),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Align(
        alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
          message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                message.isExpanded ? message.text : message.truncatedText,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black,
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

  Widget _buildTextComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(hintText: "질문을 입력하세요"),
            ),
          ),
          IconButton(
            icon: _isLoading // 로딩 상태에 따라 아이콘 변경
                ? CircularProgressIndicator() // 로딩 중일 때 CircularProgressIndicator 표시
                : Icon(Icons.send), // 로딩 중이 아닐 때 send 아이콘 표시
            onPressed: _isLoading ? null : () => _handleSubmitted(_textController.text), // 로딩 중일 때 버튼 비활성화
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmitted(String text) async {
    _textController.clear();

    // 사용자 메시지 추가
    ChatMessage userMessage = ChatMessage(
      text: text,
      isUser: true,
    );
    setState(() {
      _messages.insert(0, userMessage);
      _isLoading = true; // 로딩 시작
    });

    try {
      print('API 요청: $text'); // 요청 정보 출력

      // 챗봇 답변 생성
      final response = await _chat.sendMessage(
        Content.text(text),
      );

      print('API 응답: ${response.text}'); // 응답 결과 출력

      // 답변을 ChatMessage 객체로 생성
      ChatMessage botMessage = ChatMessage(
        text: response.text ?? "", // null 처리 추가
        isUser: false,
        isTruncated: response.text!.length > 200,
        isExpanded: false,
      );

      // 답변을 자격증 관련 내용으로 유도
      if (botMessage.truncatedText.contains("자격증") ||
          text.contains("자격증") ||
          text.contains("시험") ||
          text.contains("직업")) {
        _messages.insert(0, botMessage);
      } else {
        _messages.insert(0,
            ChatMessage(text: _recommendationMessage, isUser: false));
      }
    } catch (e) {
      print('챗봇 응답 오류: $e');
      // 오류 종류에 따라 다른 메시지 표시
      if (e is TimeoutException) {
        _messages.insert(0, ChatMessage(text: "API 응답 시간이 초과되었습니다.", isUser: false));
      } else if (e is SocketException) {
        _messages.insert(0, ChatMessage(text: "네트워크 연결에 문제가 있습니다.", isUser: false));
      } else {
        _messages.insert(0, ChatMessage(text: "오류가 발생했습니다. 다시 시도해주세요.", isUser: false));
      }
    } finally {
      setState(() {
        _isLoading = false; // 로딩 종료
      });
      _scrollDown(); // 답변 추가 후 스크롤
    }
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isTruncated; // 답변이 잘렸는지 여부
  bool isExpanded; // 전체 답변을 보여줄지 여부

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isTruncated = false,
    this.isExpanded = false,
  });

  // 잘린 텍스트 (200자 + ...)
  String get truncatedText => text.length > 200 ? text.substring(0, 200) + "..." : text;
}