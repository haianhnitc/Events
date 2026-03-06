class ConversationEntity {
  final int? conversationId;
  final int? userId1;
  final int? userId2;
  final DateTime? createdTime;
  final DateTime? lastMessageAt;

  ConversationEntity({
    this.conversationId,
    this.userId1,
    this.userId2,
    this.createdTime,
    this.lastMessageAt,
  });
}
