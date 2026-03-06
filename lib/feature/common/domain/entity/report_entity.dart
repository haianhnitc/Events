class ReportEntity {
  final int? reportId;
  final int? userId;
  final String? title;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? description;
  final DateTime? createdTime;

  ReportEntity({
    this.reportId,
    this.userId,
    this.title,
    this.name,
    this.email,
    this.phoneNumber,
    this.description,
    this.createdTime,
  });
}
