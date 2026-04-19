import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/message_entity.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    int? messageId,
    int? conversationId,
    int? senderId,
    String? content,
    bool? isRead,
    bool? isDeleted,
    DateTime? createdTime,
    DateTime? deletedAt,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      messageId: entity.messageId,
      conversationId: entity.conversationId,
      senderId: entity.senderId,
      content: entity.content,
      isRead: entity.isRead,
      isDeleted: entity.isDeleted,
      createdTime: entity.createdTime,
      deletedAt: entity.deletedAt,
    );
  }
}

extension MessageModelExtension on MessageModel {
  MessageEntity toEntity() {
    return MessageEntity(
      messageId: messageId,
      conversationId: conversationId,
      senderId: senderId,
      content: content,
      isRead: isRead,
      isDeleted: isDeleted,
      createdTime: createdTime,
      deletedAt: deletedAt,
    );
  }
}
