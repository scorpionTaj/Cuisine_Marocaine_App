import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../services/chat_service.dart';

class ChatAssistantScreen extends StatefulWidget {
  @override
  _ChatAssistantScreenState createState() => _ChatAssistantScreenState();
}

class _ChatAssistantScreenState extends State<ChatAssistantScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _loading = true;
    });
    _controller.clear();
    try {
      final reply = await ChatService.sendMessage(text);
      setState(() => _messages.add({'role': 'bot', 'text': reply}));
    } catch (e) {
      setState(() => _messages.add({'role': 'bot', 'text': 'Erreur: $e'}));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.4,
      minChildSize: 0.2,
      maxChildSize: 0.8,
      builder: (context, ctrl) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Add logo at the top of the chat
            Padding(
              padding: EdgeInsets.only(top: 8, bottom: 16),
              child: Image.asset(
                'assets/logo.png',
                height: 50,
                width: 50,
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: ctrl,
                itemCount: _messages.length,
                itemBuilder: (_, i) {
                  final msg = _messages[i];
                  final isUser = msg['role'] == 'user';
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg['text'] ?? '',
                        style: TextStyle(
                          color: isUser
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Posez une question...',
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  _loading
                      ? Padding(
                          padding: EdgeInsets.all(8),
                          child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2)),
                        )
                      : IconButton(
                          icon: Icon(Icons.send,
                              color: Theme.of(context).colorScheme.primary),
                          onPressed: _send,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
