import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/conversation_entity.dart';

part 'conversation_model.freezed.dart';
part 'conversation_model.g.dart';

@freezed
class ConversationModel with _$ConversationModel {
  const factory ConversationModel({
    int? conversationId,
    int? userId1,
    int? userId2,
    DateTime? createdTime,
    DateTime? lastMessageAt,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  factory ConversationModel.fromEntity(ConversationEntity entity) {
    return ConversationModel(
      conversationId: entity.conversationId,
      userId1: entity.userId1,
      userId2: entity.userId2,
      createdTime: entity.createdTime,
      lastMessageAt: entity.lastMessageAt,
    );
  }
}

extension ConversationModelExtension on ConversationModel {
  ConversationEntity toEntity() {
    return ConversationEntity(
      conversationId: conversationId,
      userId1: userId1,
      userId2: userId2,
      createdTime: createdTime,
      lastMessageAt: lastMessageAt,
    );
  }
}
