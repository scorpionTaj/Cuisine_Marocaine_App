import 'package:flutter/material.dart';
import '../services/enhanced_chat_service.dart';
import '../models/chat_message.dart';
import '../widgets/refreshable_view.dart';
import '../utils/animations.dart';
import '../utils/responsive_layout.dart';

class ChatHelperScreen extends StatefulWidget {
  const ChatHelperScreen({Key? key}) : super(key: key);

  @override
  _ChatHelperScreenState createState() => _ChatHelperScreenState();
}

class _ChatHelperScreenState extends State<ChatHelperScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  // For animation
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // Clear all messages and reset chat
  Future<void> _resetChat() async {
    setState(() {
      _messages.clear();
      _isTyping = false;
    });
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _messages.add(ChatMessage(
        text: userMessage,
        isUser: true,
      ));
      _isTyping = true;
    });

    // Scroll to bottom after adding message
    _scrollToBottom();

    try {
      // Get response from enhanced ChatService
      final botResponse = await EnhancedChatService.sendMessage(userMessage);

      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: botResponse,
            isUser: false,
          ));
          _isTyping = false;
        });
        // Scroll to bottom after receiving response
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: "Désolé, je n'ai pas pu traiter votre demande. Veuillez réessayer plus tard.",
            isUser: false,
          ));
          _isTyping = false;
        });
        // Scroll to bottom after error
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    // Add slight delay to ensure the list has updated
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = ResponsiveLayout.isMobile(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Assistant Culinaire',
          style: TextStyle(
            fontSize: ResponsiveLayout.getFontSize(context, 20),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetChat,
            tooltip: 'Réinitialiser la conversation',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshableView(
              onRefresh: _resetChat,
              scrollController: _scrollController,
              child: _messages.isEmpty
                ? Center(
                    child: FadeTransition(
                      opacity: _fadeController,
                      child: AppAnimations.scaleIn(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: ResponsiveLayout.getResponsiveValue(
                                context: context,
                                mobile: 70,
                                tablet: 80,
                              ),
                              color: theme.colorScheme.primary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                'Posez une question sur la cuisine marocaine!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: ResponsiveLayout.getFontSize(context, 16),
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Je suis là pour vous aider',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: ResponsiveLayout.getFontSize(context, 14),
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: ResponsiveLayout.getResponsivePadding(context),
                    controller: _scrollController,
                    itemCount: _messages.length,
                    reverse: false,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return AppAnimations.animatedListItem(
                        index: index,
                        child: _buildMessageBubble(message),
                      );
                    },
                  ),
            ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'En train d\'écrire...',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontSize: ResponsiveLayout.getFontSize(context, 14),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
            decoration: BoxDecoration(
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Tapez votre message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      maxLines: isSmallScreen ? 1 : 3,
                      minLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedBuilder(
                    animation: _messageController,
                    builder: (context, _) {
                      final hasText = _messageController.text.isNotEmpty;
                      return FloatingActionButton(
                        onPressed: hasText ? _sendMessage : null,
                        child: Icon(Icons.send),
                        mini: isSmallScreen,
                        backgroundColor: hasText
                            ? theme.colorScheme.primary
                            : theme.disabledColor,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final theme = Theme.of(context);
    final isUser = message.isUser;
    final isSmallScreen = ResponsiveLayout.isMobile(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 6.0 : 8.0,
      ),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: theme.colorScheme.secondary,
              child: Icon(Icons.restaurant, color: Colors.white, size: 16),
              radius: isSmallScreen ? 14 : 16,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * (isSmallScreen ? 0.75 : 0.7),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 16,
                vertical: isSmallScreen ? 8 : 10,
              ),
              decoration: BoxDecoration(
                color: isUser
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isUser
                      ? Colors.white
                      : theme.colorScheme.onSurface,
                  fontSize: ResponsiveLayout.getFontSize(
                    context,
                    isSmallScreen ? 14 : 15,
                  ),
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}
