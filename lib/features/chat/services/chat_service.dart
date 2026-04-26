// lib/features/chat/services/chat_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/models/message_model.dart';

class ChatService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send message
  static Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String text,
    required String senderName,
    required String? senderAvatar,
  }) async {
    try {
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add({
        'senderId': senderId,
        'text': text,
        'senderName': senderName,
        'senderAvatar': senderAvatar,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      // Update last message in chat room
      await _firestore.collection('chat_rooms').doc(chatRoomId).update({
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  // Get messages stream
  static Stream<List<MessageModel>> getMessagesStream(String chatRoomId) {
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Mark message as read
  static Future<void> markAsRead(String chatRoomId, String messageId) async {
    try {
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .doc(messageId)
          .update({'isRead': true});
    } catch (e) {
      print('Error marking message as read: $e');
      rethrow;
    }
  }

  // Delete message
  static Future<void> deleteMessage(String chatRoomId, String messageId) async {
    try {
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } catch (e) {
      print('Error deleting message: $e');
      rethrow;
    }
  }

  // Create or get chat room
  static Future<String> getChatRoomId(String userId1, String userId2) async {
    String chatRoomId = '';
    if (userId1.compareTo(userId2) > 0) {
      chatRoomId = '${userId2}_$userId1';
    } else {
      chatRoomId = '${userId1}_$userId2';
    }

    // Create chat room if it doesn't exist
    final docRef = _firestore.collection('chat_rooms').doc(chatRoomId);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      await docRef.set({
        'participants': [userId1, userId2],
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    }

    return chatRoomId;
  }

  // Get all chat rooms for user
  static Future<List<Map<String, dynamic>>> getChatRooms(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('chat_rooms')
          .where('participants', arrayContains: userId)
          .orderBy('lastMessageTime', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error getting chat rooms: $e');
      return [];
    }
  }
}
