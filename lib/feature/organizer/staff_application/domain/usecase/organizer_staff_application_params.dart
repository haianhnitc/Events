class GetOrganizerStaffApplicationsParams {
  final int? eventId;
  final String? keyword;
  final int? status;
  final int page;
  final int size;

  const GetOrganizerStaffApplicationsParams({
    this.eventId,
    this.keyword,
    this.status,
    this.page = 0,
    this.size = 20,
  });
}

class ApproveStaffApplicationParams {
  final int applicationId;
  final bool isApproved;
  final String? feedback;

  const ApproveStaffApplicationParams({
    required this.applicationId,
    required this.isApproved,
    this.feedback,
  });

  Map<String, dynamic> toJson() => {
        'isApproved': isApproved,
        if (feedback != null) 'feedback': feedback,
      };
}
