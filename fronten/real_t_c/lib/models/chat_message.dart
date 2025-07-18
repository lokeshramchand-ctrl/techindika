class ChatMessage {
  final String sender;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
  });

  // Factory constructor to create a ChatMessage from a map (e.g., from JSON)
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      sender: map['sender'] ?? 'Unknown',
      text: map['text'] ?? '',
      timestamp: DateTime.now(), // Or parse from map if available
    );
  }
}
