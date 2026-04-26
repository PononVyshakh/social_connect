// lib/features/chat/data/datasources/chat_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/message_model.dart';
import '../../../../../core/errors/exceptions.dart';

abstract class IChatRemoteDataSource {
  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String text,
    required String senderName,
    required String? senderAvatar,
  });

  Stream<List<MessageModel>> getMessagesStream(String chatRoomId);
  Future<void> markAsRead(String chatRoomId, String messageId);
  Future<void> deleteMessage(String chatRoomId, String messageId);
  String getChatRoomId(String userId1, String userId2);
  Stream<List<Map<String, dynamic>>> getChatRooms(String userId);
}

class ChatRemoteDataSource implements IChatRemoteDataSource {
  final FirebaseFirestore _firestore;

  ChatRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> sendMessage({
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
    } on FirebaseException catch (e) {
      throw FirebaseAppException(
        message: 'Failed to send message: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw AppException(
        message: 'Unexpected error sending message',
        originalException: e,
      );
    }
  }

  @override
  Stream<List<MessageModel>> getMessagesStream(String chatRoomId) {
    try {
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
    } on FirebaseException catch (e) {
      throw FirebaseAppException(
        message: 'Failed to get messages: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw AppException(
        message: 'Unexpected error getting messages',
        originalException: e,
      );
    }
  }

  @override
  Future<void> markAsRead(String chatRoomId, String messageId) async {
    try {
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .doc(messageId)
          .update({'isRead': true});
    } on FirebaseException catch (e) {
      throw FirebaseAppException(
        message: 'Failed to mark message as read: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw AppException(
        message: 'Unexpected error marking message as read',
        originalException: e,
      );
    }
  }

  @override
  Future<void> deleteMessage(String chatRoomId, String messageId) async {
    try {
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } on FirebaseException catch (e) {
      throw FirebaseAppException(
        message: 'Failed to delete message: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw AppException(
        message: 'Unexpected error deleting message',
        originalException: e,
      );
    }
  }

  @override
  String getChatRoomId(String userId1, String userId2) {
    // Generate consistent chat room ID
    List<String> ids = [userId1, userId2];
    ids.sort();
    return ids.join('_');
  }

  @override
  Stream<List<Map<String, dynamic>>> getChatRooms(String userId) {
    try {
      return _firestore
          .collection('chat_rooms')
          .where('participants', arrayContains: userId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => doc.data())
            .toList();
      });
    } on FirebaseException catch (e) {
      throw FirebaseAppException(
        message: 'Failed to get chat rooms: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw AppException(
        message: 'Unexpected error getting chat rooms',
        originalException: e,
      );
    }
  }
}
