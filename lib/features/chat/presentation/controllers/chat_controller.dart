// lib/features/chat/presentation/controllers/chat_controller.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import '../../domain/models/message_model.dart';

class ChatController extends ChangeNotifier {
  final List<MessageModel> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<MessageModel> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get messageCount => _messages.length;

  void _postFrameNotify() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Send message
  void sendMessage({
    required String text,
    required String senderName,
    required String senderId,
    String? senderAvatar,
  }) {
    if (text.trim().isEmpty) return;

    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isMe: true,
      senderName: senderName,
      senderId: senderId,
      senderAvatar: senderAvatar,
      timestamp: DateTime.now(),
      messageType: MessageType.text,
    );

    _messages.add(message);
    _errorMessage = null;
    notifyListeners();
  }

  // Receive message
  void receiveMessage({
    required String text,
    required String senderName,
    required String senderId,
    String? senderAvatar,
  }) {
    if (text.trim().isEmpty) return;

    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isMe: false,
      senderName: senderName,
      senderId: senderId,
      senderAvatar: senderAvatar,
      timestamp: DateTime.now(),
      messageType: MessageType.text,
    );

    _messages.add(message);
    _errorMessage = null;
    notifyListeners();
  }

  // Load messages
  Future<bool> loadMessages(String chatRoomId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate loading messages from Firestore
      await Future.delayed(const Duration(milliseconds: 500));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete message
  void deleteMessage(String messageId) {
    _messages.removeWhere((msg) => msg.id == messageId);
    notifyListeners();
  }

  // Clear messages
  void clearMessages() {
    _messages.clear();
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Mark as read
  Future<bool> markAsRead(String messageId) async {
    try {
      final index = _messages.indexWhere((msg) => msg.id == messageId);
      if (index != -1) {
        // Update message status
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
