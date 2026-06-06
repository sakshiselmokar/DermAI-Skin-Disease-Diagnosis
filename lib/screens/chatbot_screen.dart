import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dermai/resources.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

const String _kModel = 'meta-llama/llama-3.1-8b-instruct:free';

const String _kSystemPrompt = '''
You are DermAI Assistant, an expert dermatology AI built into the DermAI app.
You help users understand skin conditions, skincare routines, home remedies, and when to see a doctor.

Your expertise covers:
- Acne & Rosacea, Eczema, Melanoma/Moles, Nail Fungus, Psoriasis
- Morning and night skincare routines
- Natural home remedies using kitchen ingredients
- Skincare ingredients (what to use and avoid)
- When symptoms require urgent medical attention

Rules:
- Always be warm, clear and concise
- Never diagnose definitively — always recommend seeing a dermatologist for confirmation
- If someone describes symptoms of melanoma or skin cancer, strongly urge them to see a doctor immediately
- Keep responses focused on skin health
- Use bullet points for lists and steps
- If the user shares their recent scan result, use it to give personalised advice
- Never recommend prescription medications by name
- Always end serious responses with a reminder to consult a dermatologist
''';

class _Message {
  final String text;
  final bool isUser;
  final DateTime time;
  _Message({required this.text, required this.isUser}) : time = DateTime.now();
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);
  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final List<_Message> _messages = [];
  bool _loading = false;
  String? _lastDiagnosis;

  // Read key from .env at runtime
  String get _apiKey => dotenv.env['OPENROUTER_API_KEY'] ?? '';

  static const _suggestions = [
    'What is eczema and how do I treat it?',
    'Best morning skincare routine for acne',
    'Home remedies for nail fungus',
    'How do I know if a mole is dangerous?',
    'What ingredients should I avoid?',
    'Tips for managing psoriasis flare-ups',
  ];

  @override
  void initState() {
    super.initState();
    _loadLastDiagnosis();
    _messages.add(_Message(
      text: 'Hi! I\'m your DermAI Assistant 👋\n\nI can help you with skin conditions, routines, remedies and more. What would you like to know?',
      isUser: false,
    ));
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _loadLastDiagnosis() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('scan_history')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();
      if (snap.docs.isNotEmpty) {
        setState(() => _lastDiagnosis = snap.docs.first['label'] as String?);
      }
    } catch (_) {}
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  Future<void> _send([String? quickText]) async {
    final text = (quickText ?? _input.text).trim();
    if (text.isEmpty || _loading) return;
    _input.clear();

    setState(() {
      _messages.add(_Message(text: text, isUser: true));
      _loading = true;
    });
    _scrollToBottom();

    try {
      if (_apiKey.isEmpty) {
        throw Exception('API key not found in .env');
      }

      final history = _messages
          .where((m) => m.text != _messages.last.text || !m.isUser)
          .take(10)
          .map((m) => {'role': m.isUser ? 'user' : 'assistant', 'content': m.text})
          .toList();

      String systemPrompt = _kSystemPrompt;
      if (_lastDiagnosis != null) {
        systemPrompt +=
            '\n\nThe user\'s most recent skin scan detected: $_lastDiagnosis. Use this to personalise your advice when relevant.';
      }

      final response = await http.post(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://dermai.app',
          'X-Title': 'DermAI',
        },
        body: jsonEncode({
          'model': _kModel,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            ...history,
            {'role': 'user', 'content': text},
          ],
          'max_tokens': 600,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'] as String;
        setState(() {
          _messages.add(_Message(text: reply.trim(), isUser: false));
          _loading = false;
        });
      } else {
        throw Exception('Status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _messages.add(_Message(
          text: 'Sorry, I couldn\'t connect right now. Please check your internet and try again.\n\nError: $e',
          isUser: false,
        ));
        _loading = false;
      });
    }
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          _buildHeader(),
          if (_lastDiagnosis != null) _buildDiagnosisBanner(),
          Expanded(child: _buildMessages()),
          if (_messages.length <= 2) _buildSuggestions(),
          _buildInput(),
        ]),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.smart_toy_outlined, color: c, size: 22),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('DermAI Assistant',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            Text('Powered by Llama 3.1 · Skin specialist AI',
                style: TextStyle(fontSize: 11, color: Colors.black38)),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFFF0FFF6), borderRadius: BorderRadius.circular(20)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 7, height: 7, decoration: const BoxDecoration(color: c, shape: BoxShape.circle)),
            const SizedBox(width: 5),
            const Text('Online', style: TextStyle(fontSize: 11, color: c, fontWeight: FontWeight.w600)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildDiagnosisBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FFF6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withOpacity(0.25)),
      ),
      child: Row(children: [
        const Icon(Icons.biotech_rounded, size: 16, color: c),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Last scan: $_lastDiagnosis — I\'ll personalise my advice for you.',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ]),
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      itemCount: _messages.length + (_loading ? 1 : 0),
      itemBuilder: (_, i) {
        if (_loading && i == _messages.length) return _buildTyping();
        return _buildBubble(_messages[i]);
      },
    );
  }

  Widget _buildBubble(_Message msg) {
    final isUser = msg.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(color: c.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.smart_toy_outlined, size: 16, color: c),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: msg.text));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Copied to clipboard'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isUser ? c : Colors.grey.shade100,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isUser ? 16 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 16),
                  ),
                ),
                child: Text(
                  msg.text,
                  style: TextStyle(fontSize: 14, height: 1.5,
                      color: isUser ? Colors.white : Colors.black87),
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTyping() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: c.withOpacity(0.1), shape: BoxShape.circle),
          child: const Icon(Icons.smart_toy_outlined, size: 16, color: c),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            _dot(), const SizedBox(width: 4),
            _dot(), const SizedBox(width: 4),
            _dot(),
          ]),
        ),
      ]),
    );
  }

  Widget _dot() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      builder: (_, v, __) => Container(
        width: 7, height: 7,
        decoration: BoxDecoration(color: c.withOpacity(v), shape: BoxShape.circle),
      ),
    );
  }

  Widget _buildSuggestions() {
    return Container(
      height: 42,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => _send(_suggestions[i]),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(_suggestions[i],
                style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500)),
          ),
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: Row(children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextField(
              controller: _input,
              maxLines: 4,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Ask about your skin...',
                hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _loading ? null : () => _send(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: _loading ? Colors.grey.shade300 : c,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _loading ? Icons.hourglass_empty_rounded : Icons.send_rounded,
              color: Colors.white, size: 20,
            ),
          ),
        ),
      ]),
    );
  }
}