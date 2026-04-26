// lib/features/chat/domain/models/message_model.dart

class MessageModel {
  final String id;
  final String text;
  final bool isMe;
  final String senderName;
  final String senderId;
  final String? senderAvatar;
  final DateTime timestamp;
  final String? imageUrl;
  final MessageType messageType;

  MessageModel({
    required this.id,
    required this.text,
    required this.isMe,
    required this.senderName,
    required this.senderId,
    this.senderAvatar,
    required this.timestamp,
    this.imageUrl,
    this.messageType = MessageType.text,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as String? ?? '',
      text: map['text'] as String? ?? '',
      isMe: map['isMe'] as bool? ?? false,
      senderName: map['senderName'] as String? ?? '',
      senderId: map['senderId'] as String? ?? '',
      senderAvatar: map['senderAvatar'] as String?,
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'].toString())
          : DateTime.now(),
      imageUrl: map['imageUrl'] as String?,
      messageType: _parseMessageType(map['messageType']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'isMe': isMe,
      'senderName': senderName,
      'senderId': senderId,
      'senderAvatar': senderAvatar,
      'timestamp': timestamp.toIso8601String(),
      'imageUrl': imageUrl,
      'messageType': messageType.toString(),
    };
  }

  static MessageType _parseMessageType(dynamic value) {
    if (value == null) return MessageType.text;
    final str = value.toString();
    return MessageType.values.firstWhere(
      (e) => e.toString() == str,
      orElse: () => MessageType.text,
    );
  }

  MessageModel copyWith({
    String? id,
    String? text,
    bool? isMe,
    String? senderName,
    String? senderId,
    String? senderAvatar,
    DateTime? timestamp,
    String? imageUrl,
    MessageType? messageType,
  }) {
    return MessageModel(
      id: id ?? this.id,
      text: text ?? this.text,
      isMe: isMe ?? this.isMe,
      senderName: senderName ?? this.senderName,
      senderId: senderId ?? this.senderId,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      timestamp: timestamp ?? this.timestamp,
      imageUrl: imageUrl ?? this.imageUrl,
      messageType: messageType ?? this.messageType,
    );
  }
}

enum MessageType { text, image, audio, video, document }
