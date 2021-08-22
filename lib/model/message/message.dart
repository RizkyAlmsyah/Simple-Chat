class Message{
  final String sendBy;
  final String message;
  final String sendTo;
  final String timestamp;

  Message({required this.sendBy, required this.sendTo, required this.message, required this.timestamp});

  Message.fromJson(Map<String, Object?> json) : this(
    message: json['message']! as String,
    sendBy: json['sendBy']! as String,
    sendTo: json['sendTo']! as String,
    timestamp: json['timestamp']! as String,
  );

  Map<String, Object?> toJson() {
    return {
      'message' : message,
      'sendBy' : sendBy,
      'sendTo' : sendTo,
      'timestamp': timestamp,
    };
  }
}