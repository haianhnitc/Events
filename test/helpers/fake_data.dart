/// Tập hợp các fake JSON map dùng xuyên suốt tất cả test file.
/// Mọi fixture đều là hàm factory (không dùng global const) để tránh shared state.
library fake_data;

Map<String, dynamic> fakeUserJson({
  int id = 1,
  String role = 'USER',
  String status = 'ACTIVE',
  String? verificationStatus,
}) {
  return {
    'userId': id,
    'firebaseUid': 'firebase-uid-$id',
    'email': 'test@example.com',
    'role': role,
    'status': status,
    'currentCoin': 0,
    'remainingFreePortfolios': 0,
    'userProfile': {
      'fullName': 'Test User',
      'gender': 'MALE',
      'dateOfBirth': '2000-01-01',
    },
    if (role == 'ORGANIZATION')
      'organizationProfile': {
        'organizationName': 'Test Org',
        'organizationType': 'CLUB',
        'verificationStatus': verificationStatus ?? 'VERIFIED',
      },
  };
}

Map<String, dynamic> fakeEventSummaryJson({int id = 1}) {
  return {
    'eventId': id,
    'title': 'Event $id',
    'banner': 'https://example.com/banner.jpg',
    'startTime': '2025-06-01T08:00:00Z',
    'endTime': '2025-06-01T17:00:00Z',
    'registerOpenTime': '2025-05-01T00:00:00Z',
    'status': 'PUBLISHED',
    'price': 0,
    'categories': [],
    'totalParticipants': 10,
    'userEventState': 'NONE',
  };
}

Map<String, dynamic> fakeEventJson({int id = 1}) {
  return {
    'eventId': id,
    'title': 'Event $id',
    'organizerName': 'Test Organizer',
    'description': 'Description',
    'banner': 'https://example.com/banner.jpg',
    'status': 'PUBLISHED',
    'startTime': '2025-06-01T08:00:00Z',
    'endTime': '2025-06-01T17:00:00Z',
    'registerOpenTime': '2025-05-01T00:00:00Z',
    'price': 0,
    'categories': [],
    'rewardCoin': 10,
    'youthUnionPoint': 5,
    'totalParticipants': 100,
    'userEventState': 'NONE',
  };
}

Map<String, dynamic> fakeAttendanceQrJson() {
  return {
    'qrContent': 'QR_CONTENT_ABC',
    'scanMethod': 'EVENT_QR',
    'eventId': 1,
    'eventParticipantId': 42,
    'issuedTime': '2025-06-01T08:00:00Z',
    'expiryTime': '2025-06-01T18:00:00Z',
  };
}

Map<String, dynamic> fakeScanResultJson({String action = 'CHECKIN'}) {
  return {
    'action': action,
    'eventParticipantId': 42,
    'eventId': 100,
    'attendanceLogId': 10,
    'checkInTime': action == 'CHECKIN' ? '2025-06-01T08:30:00Z' : null,
    'checkOutTime': action == 'CHECKOUT' ? '2025-06-01T18:00:00Z' : null,
    'message': action == 'CHECKIN' ? 'Check-in successful' : 'Check-out successful',
  };
}

Map<String, dynamic> fakeAttendanceLogJson({int id = 1}) {
  return {
    'eventAttendanceLogId': id,
    'eventParticipant': {
      'eventParticipantId': 42,
      'eventId': 1,
      'user': {
        'userId': 10,
        'fullName': 'Test User',
        'avatarUrl': null,
        'role': 'USER',
      },
      'participantType': 'ATTENDEE',
      'status': 'REGISTERED',
      'hasCheckedIn': false,
      'hasFeedback': false,
    },
    'type': 'CHECKIN',
    'scanMethod': 'STAFF_QR',
    'isValid': true,
    'createdTime': '2025-06-01T08:30:00Z',
  };
}

Map<String, dynamic> fakeFeedbackQuestionJson({int id = 1}) {
  return {
    'feedbackQuestionId': id,
    'event': {
      'eventId': 1,
      'title': 'Test Event',
    },
    'questionContent': 'Question $id',
    'questionType': 'TEXT',
    'isRequired': false,
    'options': [],
  };
}

Map<String, dynamic> fakeFeedbackJson({int id = 1}) {
  return {
    'attendanceFeedbackId': id,
    'eventParticipantId': 42,
    'participantFullName': 'Test User',
    'participantType': 'ATTENDEE',
    'feedbackAnswers': [],
    'comment': 'Great event!',
    'createdTime': '2025-06-01T20:00:00Z',
  };
}

Map<String, dynamic> fakeNewsJson({int id = 1}) {
  return {
    'newsId': id,
    'title': 'News $id',
    'content': 'News content',
    'banner': 'https://example.com/banner.jpg',
    'targetType': 'NONE',
    'totalRewardCoin': 0,
    'rewardPerMinute': 0,
    'viewCount': 0,
    'createdTime': '2025-01-01T00:00:00Z',
  };
}

Map<String, dynamic> fakeCtvRecruitmentJson({int id = 1}) {
  return {
    'ctvRecruitmentId': id,
    'eventId': 1,
    'title': 'Recruitment $id',
    'description': 'Description',
    'startTime': '2025-05-01T00:00:00Z',
    'quantity': 10,
    'isOpen': true,
    'appliedCount': 0,
    'recruitmentType': 'CTV_ONLY',
  };
}

Map<String, dynamic> fakeRequirementQuestionJson({int id = 1}) {
  return {
    'questionId': id,
    'ctvRecruitmentId': 5,
    'questionText': 'Why do you want to join?',
    'questionType': 'TEXT',
    'isRequired': true,
    'options': [],
  };
}

Map<String, dynamic> fakeParticipantJson({int id = 1}) {
  return {
    'eventParticipantId': id,
    'eventId': 1,
    'user': {
      'userId': 10,
      'fullName': 'Participant $id',
      'avatarUrl': null,
      'role': 'USER',
    },
    'participantType': 'ATTENDEE',
    'status': 'REGISTERED',
    'hasCheckedIn': false,
    'hasFeedback': false,
  };
}

Map<String, dynamic> fakeTicketJson({int id = 1}) {
  return {
    'ticketId': id,
    'event': {
      'eventId': 1,
      'title': 'Test Event',
      'banner': 'https://example.com/banner.jpg',
      'startTime': '2025-06-01T08:00:00Z',
      'endTime': '2025-06-01T17:00:00Z',
      'registerOpenTime': '2025-05-01T00:00:00Z',
      'status': 'PUBLISHED',
      'price': 0,
      'categories': [],
      'totalParticipants': 10,
      'userEventState': 'NONE',
    },
    'status': 'ISSUED',
    'issuedTime': '2025-06-01T07:00:00Z',
  };
}

Map<String, dynamic> fakeStaffApplicationJson({int id = 1}) {
  return {
    'applicationId': id,
    'applicantUserId': 10,
    'applicantFullName': 'Applicant $id',
    'eventId': 1,
    'eventTitle': 'Test Event',
    'roleName': 'Tình nguyện viên',
    'status': 'PENDING',
    'appliedTime': '2025-05-01T00:00:00Z',
  };
}

Map<String, dynamic> fakeVerificationDocumentJson({int id = 1}) {
  return {
    'verificationDocumentId': id,
    'userSummary': {
      'userId': 1,
      'fullName': 'Test User',
      'email': 'test@example.com',
      'avatarUrl': null,
      'role': 'ORGANIZATION',
      'status': 'ACTIVE',
    },
    'documentType': 'BUSINESS_LICENSE',
    'fileUrl': 'https://example.com/doc.pdf',
    'originalFileName': 'license.pdf',
    'createdTime': '2025-01-01T00:00:00Z',
  };
}

Map<String, dynamic> fakeCoinTransactionJson({int id = 1}) {
  return {
    'transactionId': id,
    'amount': 10,
    'referenceType': 'EVENT_ATTEND',
    'referenceId': 1,
    'balanceAfter': 100,
    'createdTime': '2025-06-01T08:00:00Z',
  };
}

Map<String, dynamic> fakePaymentUrlJson({int id = 1}) {
  return {
    'paymentUrl': 'https://sepay.vn/pay/$id',
    'qrCodeUrl': 'https://sepay.vn/qr/$id.png',
    'orderId': id,
    'requestId': 'REQ-$id',
    'expireTime': 1717200000000,
  };
}

Map<String, dynamic> fakeTransactionJson({int id = 1}) {
  return {
    'transactionId': id,
    'user': {
      'userId': 10,
      'fullName': 'Test User',
      'avatarUrl': null,
      'role': 'USER',
    },
    'referenceType': 'TICKET',
    'referenceId': 5,
    'referenceTitle': 'Ticket Purchase',
    'originalAmount': 100000,
    'coinUsed': 0,
    'finalAmount': 100000,
    'currency': 'VND',
    'paymentProvider': 'SEPAY',
    'externalTransactionId': 'EXT-$id',
    'status': 'SUCCESS',
    'paidAt': '2025-06-01T10:00:00Z',
    'createdTime': '2025-06-01T09:55:00Z',
    'paymentUrl': 'https://sepay.vn/pay/$id',
  };
}

Map<String, dynamic> fakePortfolioJson({int id = 1}) {
  return {
    'portfolioId': id,
    'userId': 1,
    'title': 'Portfolio $id',
    'description': 'Portfolio description',
    'thumbnailUrl': 'https://example.com/thumb.jpg',
    'isPublished': true,
    'createdTime': '2025-01-01T00:00:00Z',
  };
}

Map<String, dynamic> fakePortfolioDetailJson({int id = 1}) {
  return {
    'portfolioId': id,
    'userId': 1,
    'title': 'Portfolio $id',
    'description': 'Portfolio description',
    'thumbnailUrl': 'https://example.com/thumb.jpg',
    'isPublished': true,
    'createdTime': '2025-01-01T00:00:00Z',
    'events': [fakeEventSummaryJson(id: 1)],
    'totalEvents': 1,
    'totalCoinsEarned': 10,
  };
}

Map<String, dynamic> fakeRankJson({int id = 1}) {
  return {
    'userId': id,
    'user': {
      'userId': id,
      'fullName': 'User $id',
      'email': 'user$id@example.com',
      'avatarUrl': null,
      'role': 'USER',
    },
    'totalCoin': 100 * id,
    'ranking': id,
    'level': 1,
    'levelName': 'Bronze',
    'updatedTime': '2025-01-01T00:00:00Z',
  };
}

Map<String, dynamic> fakeUserPackageJson({int id = 1}) {
  return {
    'id': id,
    'userId': 1,
    'packageId': 1,
    'packageName': 'Premium Package',
    'status': 'ACTIVE',
    'startDate': '2025-01-01T00:00:00Z',
    'expiryDate': '2025-12-31T23:59:59Z',
    'notes': null,
    'createdAt': '2025-01-01T00:00:00Z',
    'autoRenew': false,
  };
}

Map<String, dynamic> fakeFileJson({int id = 1}) {
  return {
    'fileId': id,
    'url': 'https://example.com/file_$id.jpg',
    'fileType': 'AVATAR',
    'fileSize': 1024,
    'createdTime': '2025-01-01T00:00:00Z',
  };
}

Map<String, dynamic> fakeNotificationJson({int id = 1}) {
  return {
    'notificationId': id,
    'title': 'Notification $id',
    'body': 'Notification body $id',
    'createdBy': 'ADMIN',
    'targetType': 'EVENT',
    'targetId': 1,
    'deeplink': '/event/1',
    'createdTime': '2025-01-01T00:00:00Z',
  };
}

Map<String, dynamic> fakeCategoryJson({int id = 1}) {
  return {
    'categoryId': id,
    'name': 'Category $id',
    'type': 'SCHOOL',
    'options': [
      {'value': 'option1', 'label': 'Option 1'},
      {'value': 'option2', 'label': 'Option 2'},
    ],
  };
}
