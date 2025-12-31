import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class IslamicChatbot extends StatefulWidget {
  const IslamicChatbot({super.key});

  @override
  State<IslamicChatbot> createState() => _IslamicChatbotState();
}

class _IslamicChatbotState extends State<IslamicChatbot> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  // Replace with your friend's working API key
  static const String _apiKey = 'AIzaSyAM2CKznczi8IDI2CtqXE8b6mprNFVZcSw';

  late GenerativeModel _model;
  final List<Content> _chatHistoryInternal = [];

  @override
  void initState() {
    super.initState();
    _initModel();
    _addMessage(
      'Assalamu alaikum! 🌙\n\n'
          'I am **Islamic MindLens**, your Islamic guidance assistant.\n\n'
          'Ask me anything about Islam! 🤲',
      false,
    );

    // Initialize chat history with system prompt
    _chatHistoryInternal.add(
      Content.text(
        'You are "Islamic MindLens", an Islamic scholar-level assistant.\n\n'
            'IMPORTANT RESPONSE RULES:\n'
            '- Provide a detailed explanation (minimum 3–5 paragraphs)\n'
            '- Explain the reasoning step-by-step\n'
            '- Include at least one Quran verse (with Surah and Ayah number)\n'
            '- Include at least one authentic Hadith (mention source)\n'
            '- Add practical examples from daily life\n'
            '- End with a short du\'a\n'
            '- Always respond in English\n'
            '- Maintain a respectful, knowledgeable, and compassionate tone',
      ),
    );
    _chatHistoryInternal.add(Content.text('Understood. I am ready to provide comprehensive Islamic guidance.'));
  }

  Future<void> _initModel() async {
    try {
      _model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.7,
          topP: 0.95,
          maxOutputTokens: 2000,
        ),
      );
      print('Model initialized successfully');
    } catch (e) {
      print('Error initializing model: $e');
    }
  }

  void _addMessage(String text, bool isUser) {
    setState(() {
      _messages.add({
        'text': text,
        'isUser': isUser,
        'time': DateTime.now(),
      });
    });
  }

  Future<void> _sendMessage() async {
    final userQuestion = _controller.text.trim();
    if (userQuestion.isEmpty) return;

    _controller.clear();
    _addMessage(userQuestion, true);

    setState(() => _isLoading = true);

    try {
      // Add user message to history
      _chatHistoryInternal.add(Content.text(userQuestion));

      // Generate response using the new Gemini API
      final response = await _model.generateContent(_chatHistoryInternal);

      if (response.text != null && response.text!.isNotEmpty) {
        // Add model response to history
        _chatHistoryInternal.add(Content.text(response.text!));

        // Add to display messages
        _addMessage(response.text!.trim(), false);
      } else {
        _addMessage('I apologize, I could not generate a response at the moment. Please try again.', false);
      }
    } catch (e) {
      print('API Error: $e');

      // More specific error messages
      if (e.toString().contains('API_KEY_INVALID') ||
          e.toString().contains('PERMISSION_DENIED')) {
        _addMessage(
          'API key error. Please check if the API key is valid and has proper permissions.',
          false,
        );
      } else if (e.toString().contains('429')) {
        _addMessage(
          'Rate limit exceeded. Please wait a moment before trying again.',
          false,
        );
      } else if (e.toString().contains('503') ||
          e.toString().contains('UNAVAILABLE')) {
        _addMessage(
          'Service temporarily unavailable. Please try again in a few moments.',
          false,
        );
      } else {
        _addMessage(
          'Unable to connect. Please check your internet connection and try again.',
          false,
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Islamic MindLens'),
        backgroundColor: const Color(0xFF074C4C),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!message['isUser'])
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF074C4C),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      if (message['isUser']) const Spacer(),
                      Flexible(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.8,
                          ),
                          margin: EdgeInsets.only(
                            left: message['isUser'] ? 40 : 8,
                            right: message['isUser'] ? 8 : 40,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: message['isUser']
                                ? const Color(0xFF074C4C)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: message['isUser']
                              ? Text(
                            message['text'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          )
                              : MarkdownBody(
                            data: message['text'],
                            styleSheet: MarkdownStyleSheet(
                              p: const TextStyle(
                                fontSize: 14,
                                height: 1.5,
                              ),
                              strong: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                              em: const TextStyle(fontStyle: FontStyle.italic),
                              blockquote: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[700],
                              ),
                              code: TextStyle(
                                backgroundColor: Colors.grey[100],
                                fontFamily: 'monospace',
                                fontSize: 13,
                              ),
                              blockquoteDecoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              blockquotePadding: const EdgeInsets.all(8),
                            ),
                          ),
                        ),
                      ),
                      if (message['isUser'])
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC39F47),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Loading
          if (_isLoading)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF074C4C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF074C4C)),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Islamic MindLens is thinking...',
                          style: TextStyle(color: Color(0xFF074C4C)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask your Islamic question...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: Color(0xFF074C4C)),
                        onPressed: _sendMessage,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}