class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final double? confidenceScore;
  final String? recoveryTopic;
  final List<String>? actionSuggestions;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.confidenceScore,
    this.recoveryTopic,
    this.actionSuggestions,
  });
}

