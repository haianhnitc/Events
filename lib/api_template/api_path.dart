class ApiPath {
  // auth
  static const String authVerify = '/auth/verify';
  static const String authSignup = '/auth/signup';
  static const String authLogout = '/auth/logout';

  // upload
  static const String upload = '/upload';
  static String deleteUpload(int fileId) => '/upload/$fileId';

  // verificaition-document
  static const String verificationDocuments = '/verification-documents';
  static const String myVerificationDocuments = '/verification-documents/me';

  // user and participant me
  static const String usersMe = '/users/me';
  static String userDetail(int userId) => '/users/$userId';
  static String userParticipatedEvents(int userId) =>
      '/users/$userId/participated-events';

  // Registration
  static const String registrations = '/registrations';
  static String registrationDetail(int id) => '/registrations/$id';
  static String registrationCancel(int id) => '/registrations/$id/cancel';
  static String registrationsQuery() => '/registrations';

  // participant
  static const String participants = '/participants';
  static String participantDetail(int id) => '/participants/$id';

  // recruitment
  static const String recruitments = '/recruitments';
  static String recruitmentDetail(int id) => '/recruitments/$id';
  static String recruitmentQuestions(int id) => '/recruitments/$id/questions';
  static String recruitmentClose(int id) => '/recruitments/$id/close';

  // staff application
  static const String staffApplications = '/staff-applications';
  static String staffApplicationDetail(int id) => '/staff-applications/$id';
  static String staffApplicationApprove(int id) =>
      '/staff-applications/$id/approve';
  static String staffApplicationAnswers(int appId) =>
      '/application-answers/event-staff-application/$appId';

  // attendance
  static const String attendancesQrParticipant = '/attendances/qr/participant';
  static const String attendancesQrEvent = '/attendances/qr/event';
  static const String attendancesScanQr = '/attendances/scan-qr';
  static const String attendancesSelfCheckin = '/attendances/self-checkin';
  static const String attendancesCheckout = '/attendances/checkout';
  static const String attendancesManualCheckin = '/attendances/manual-checkin';
  static const String attendancesManualCheckout =
      '/attendances/manual-checkout';
  static const String attendances = '/attendances';
  static String attendanceQrParticipant(int eventParticipantId) =>
      '/attendances/qr/participant/$eventParticipantId';
  static String attendanceQrEvent(int eventId) =>
      '/attendances/qr/event/$eventId';
  static String attendanceDetail(int id) => '/attendances/$id';

  // feedback
  static const String feedbackQuestions = '/feedback-questions';
  static const String feedbacks = '/feedbacks';
  static String feedbackQuestionDetail(int id) => '/feedback-questions/$id';
  static String feedbackDetail(int id) => '/feedbacks/$id';

  // ticket
  static const String tickets = '/tickets';
  static String ticketDetail(int id) => '/tickets/$id';
  static String ticketAssign(int id) => '/tickets/$id/assign';

  // transaction and payment
  static const String sePayPayment = '/finance/sepay-payment';
  static const String sePayCallback = '/finance/sepay-callback';
  static const String transactions = '/finance/transactions';
  static String transactionDetail(int id) => '/finance/transactions/$id';
  static const String coinHistory = '/finance/coins/history';

  // event
  static const String events = '/events';
  static const String eventsFeatured = '/events/featured';
  static String eventDetail(int id) => '/events/$id';
  static String eventPublish(int id) => '/events/$id/publish';
  static String eventStatistics(int id) => '/events/$id/statistics';
  static String eventAnalytics(int id) => '/events/$id/analytics';

  // category
  static const String eventCategoryOptions = '/event-category-options';
  static String eventCategoryOptionUpdate(int eventId, int categoryOptionId) =>
      '/event-category-options/$eventId/$categoryOptionId';
  static const String categories = '/categories';

  // venue
  static const String venues = '/venues';
  static String venueDetail(int id) => '/venues/$id';
  static const String venuesList = '/venues';

  // organization
  static String organizationDetail(int id) => '/organizations/$id';
  static const String organizationDashboard = '/organizations/me/dashboard';

  // news
  static const String news = '/news';
  static String newsDetail(int id) => '/news/$id';
  static String newsClaim(int id) => '/news/$id/claim';

  // Package
  static const String packages = '/packages';
  static String packageDetail(int packageId) => '/packages/$packageId';
  static const String userPackages = '/packages/user-packages';
  static String userPackageDetail(int userPackageId) =>
      '/packages/user-packages/$userPackageId';
  static const String userPackagesCheckExpiry =
      '/packages/user-packages/check-expiry';

  // Portfolio
  static const String portfolios = '/portfolios';
  static String portfolioDetail(int id) => '/portfolios/$id';

  // Rank
  static const String ranks = '/ranks';
  static String rankByUser(int userId) => '/ranks/$userId';

  // Notification
  static const String notifications = '/notifications';
  static String notificationDetail(int id) => '/notifications/$id';
}
