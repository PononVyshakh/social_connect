// lib/features/chat/data/repositories/chat_repository.dart
import '../../domain/models/message_model.dart';
import '../../../../../core/errors/failures.dart';
import '../datasources/chat_remote_datasource.dart';

abstract class IChatRepository {
  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String text,
    required String senderName,
    required String? senderAvatar,
  });

  Stream<List<MessageModel>> getMessages(String chatRoomId);
  Future<void> markAsRead(String chatRoomId, String messageId);
  Future<void> deleteMessage(String chatRoomId, String messageId);
  String getChatRoomId(String userId1, String userId2);
  Stream<List<Map<String, dynamic>>> getChatRooms(String userId);
}

class ChatRepository implements IChatRepository {
  final IChatRemoteDataSource _remoteDataSource;

  ChatRepository({IChatRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ChatRemoteDataSource();

  @override
  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String text,
    required String senderName,
    required String? senderAvatar,
  }) async {
    try {
      await _remoteDataSource.sendMessage(
        chatRoomId: chatRoomId,
        senderId: senderId,
        text: text,
        senderName: senderName,
        senderAvatar: senderAvatar,
      );
    } catch (e) {
      throw _mapExceptionToFailure(e);
    }
  }

  @override
  Stream<List<MessageModel>> getMessages(String chatRoomId) {
    try {
      return _remoteDataSource.getMessagesStream(chatRoomId);
    } catch (e) {
      throw _mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> markAsRead(String chatRoomId, String messageId) async {
    try {
      await _remoteDataSource.markAsRead(chatRoomId, messageId);
    } catch (e) {
      throw _mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> deleteMessage(String chatRoomId, String messageId) async {
    try {
      await _remoteDataSource.deleteMessage(chatRoomId, messageId);
    } catch (e) {
      throw _mapExceptionToFailure(e);
    }
  }

  @override
  String getChatRoomId(String userId1, String userId2) {
    return _remoteDataSource.getChatRoomId(userId1, userId2);
  }

  @override
  Stream<List<Map<String, dynamic>>> getChatRooms(String userId) {
    try {
      return _remoteDataSource.getChatRooms(userId);
    } catch (e) {
      throw _mapExceptionToFailure(e);
    }
  }

  Failure _mapExceptionToFailure(dynamic exception) {
    if (exception is Failure) {
      return exception;
    }
    return Failure(message: exception.toString());
  }
}
