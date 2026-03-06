class MessageEntity {
  final int? messageId;
  final int? conversationId;
  final int? senderId;
  final String? content;
  final bool? isRead;
  final bool? isDeleted;
  final DateTime? createdTime;
  final DateTime? deletedAt;

  MessageEntity({
    this.messageId,
    this.conversationId,
    this.senderId,
    this.content,
    this.isRead,
    this.isDeleted,
    this.createdTime,
    this.deletedAt,
  });
}
