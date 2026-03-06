class CtvRecruitmentEntity {
  final int? ctvRecruitmentId;
  final int? eventId;
  final String? roleName;
  final String? description;
  final String? benefit;
  final int? quantity;
  final bool? isOpen;
  final DateTime? createdTime;

  CtvRecruitmentEntity({
    this.ctvRecruitmentId,
    this.eventId,
    this.roleName,
    this.description,
    this.benefit,
    this.quantity,
    this.isOpen,
    this.createdTime,
  });
}
