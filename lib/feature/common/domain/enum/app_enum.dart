import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum AttendanceLogType {
  @JsonValue('CHECKIN')
  checkIn,
  @JsonValue('CHECKOUT')
  checkOut,
}

extension AttendanceLogTypeApiValue on AttendanceLogType {
  String get apiValue {
    switch (this) {
      case AttendanceLogType.checkIn:
        return 'CHECKIN';
      case AttendanceLogType.checkOut:
        return 'CHECKOUT';
    }
  }

  static AttendanceLogType? fromApiValue(Object? rawValue) {
    if (rawValue is! String) return null;
    switch (rawValue.toUpperCase()) {
      case 'CHECKIN':
        return AttendanceLogType.checkIn;
      case 'CHECKOUT':
        return AttendanceLogType.checkOut;
      default:
        return null;
    }
  }
}

@JsonEnum()
enum CategoryType {
  @JsonValue('SCHOOL')
  school,
  @JsonValue('FIELD')
  field,
  @JsonValue('LOCATION')
  location,
  @JsonValue('STYLE')
  style,
  @JsonValue('PRICE')
  price,
  @JsonValue('ATTENDEE')
  attendee,
  @JsonValue('CRITERION')
  criterion,
}

@JsonEnum()
enum CoinReferenceType {
  @JsonValue('EVENT_ATTEND')
  eventAttend,
  @JsonValue('BUY_PACKAGE')
  buyPackage,
  @JsonValue('BUY_TICKET')
  buyTicket,
  @JsonValue('PORTFOLIO')
  portfolio,
  @JsonValue('REFUND')
  refund,
  @JsonValue('PENALTY')
  penalty,
  @JsonValue('ADMIN_ADJUST')
  adminAdjust,
  @JsonValue('NEWS_READ')
  newsRead,
  @JsonValue('FEEDBACK')
  feedback,
}

extension CoinReferenceTypeApiValue on CoinReferenceType {
  String get apiValue {
    switch (this) {
      case CoinReferenceType.eventAttend:
        return 'EVENT_ATTEND';
      case CoinReferenceType.buyPackage:
        return 'BUY_PACKAGE';
      case CoinReferenceType.buyTicket:
        return 'BUY_TICKET';
      case CoinReferenceType.portfolio:
        return 'PORTFOLIO';
      case CoinReferenceType.refund:
        return 'REFUND';
      case CoinReferenceType.penalty:
        return 'PENALTY';
      case CoinReferenceType.adminAdjust:
        return 'ADMIN_ADJUST';
      case CoinReferenceType.newsRead:
        return 'NEWS_READ';
      case CoinReferenceType.feedback:
        return 'FEEDBACK';
    }
  }

  String get displayName {
    switch (this) {
      case CoinReferenceType.eventAttend:
        return 'Thuong khi tham gia su kien';
      case CoinReferenceType.buyPackage:
        return 'Mua / gia han goi';
      case CoinReferenceType.buyTicket:
        return 'Mua ve';
      case CoinReferenceType.portfolio:
        return 'Tao portfolio';
      case CoinReferenceType.refund:
        return 'Hoan xu';
      case CoinReferenceType.penalty:
        return 'Phat xu';
      case CoinReferenceType.adminAdjust:
        return 'Dieu chinh tu admin';
      case CoinReferenceType.newsRead:
        return 'Doc tin';
      case CoinReferenceType.feedback:
        return 'Danh gia su kien';
    }
  }

  static CoinReferenceType? fromApiValue(Object? rawValue) {
    if (rawValue is! String) return null;
    switch (rawValue.toUpperCase()) {
      case 'EVENT_ATTEND':
        return CoinReferenceType.eventAttend;
      case 'BUY_PACKAGE':
        return CoinReferenceType.buyPackage;
      case 'BUY_TICKET':
        return CoinReferenceType.buyTicket;
      case 'PORTFOLIO':
        return CoinReferenceType.portfolio;
      case 'REFUND':
        return CoinReferenceType.refund;
      case 'PENALTY':
        return CoinReferenceType.penalty;
      case 'ADMIN_ADJUST':
        return CoinReferenceType.adminAdjust;
      case 'NEWS_READ':
        return CoinReferenceType.newsRead;
      case 'FEEDBACK':
        return CoinReferenceType.feedback;
      default:
        return null;
    }
  }
}

@JsonEnum()
enum CurrencyTransaction {
  @JsonValue('VN\u0110')
  vnd,
}

@JsonEnum()
enum DocumentType {
  @JsonValue('BUSINESS_LICENSE')
  businessLicense,
  @JsonValue('UNIVERSITY_DECISION')
  universityDecision,
  @JsonValue('CLUB_CERTIFICATE')
  clubCertificate,
  @JsonValue('TAX_CODE')
  taxCode,
  @JsonValue('OTHER')
  other,
}

extension DocumentTypeApiValue on DocumentType {
  String get apiValue {
    switch (this) {
      case DocumentType.businessLicense:
        return 'BUSINESS_LICENSE';
      case DocumentType.universityDecision:
        return 'UNIVERSITY_DECISION';
      case DocumentType.clubCertificate:
        return 'CLUB_CERTIFICATE';
      case DocumentType.taxCode:
        return 'TAX_CODE';
      case DocumentType.other:
        return 'OTHER';
    }
  }

  static DocumentType? fromApiValue(Object? rawValue) {
    if (rawValue is! String) return null;
    switch (rawValue.toUpperCase()) {
      case 'BUSINESS_LICENSE':
        return DocumentType.businessLicense;
      case 'UNIVERSITY_DECISION':
        return DocumentType.universityDecision;
      case 'CLUB_CERTIFICATE':
        return DocumentType.clubCertificate;
      case 'TAX_CODE':
        return DocumentType.taxCode;
      case 'OTHER':
        return DocumentType.other;
      default:
        return null;
    }
  }
}

@JsonEnum()
enum ParticipantStatus {
  @JsonValue('REGISTERED')
  registered,
  @JsonValue('ATTENDED')
  attended,
  @JsonValue('NOSHOW')
  noShow,
}

extension ParticipantStatusApiValue on ParticipantStatus {
  String get apiValue {
    switch (this) {
      case ParticipantStatus.registered:
        return 'REGISTERED';
      case ParticipantStatus.attended:
        return 'ATTENDED';
      case ParticipantStatus.noShow:
        return 'NOSHOW';
    }
  }

  static ParticipantStatus? fromApiValue(Object? rawValue) {
    if (rawValue is! String) return null;
    switch (rawValue.toUpperCase()) {
      case 'REGISTERED':
        return ParticipantStatus.registered;
      case 'ATTENDED':
        return ParticipantStatus.attended;
      case 'NOSHOW':
        return ParticipantStatus.noShow;
      default:
        return null;
    }
  }
}

@JsonEnum()
enum EventRecruitmentType {
  @JsonValue('CTV_ONLY')
  ctvOnly,
  @JsonValue('ATTENDEE_ONLY')
  attendeeOnly,
  @JsonValue('BOTH')
  both,
}

extension EventRecruitmentTypeApiValue on EventRecruitmentType {
  String get apiValue {
    switch (this) {
      case EventRecruitmentType.ctvOnly:
        return 'CTV_ONLY';
      case EventRecruitmentType.attendeeOnly:
        return 'ATTENDEE_ONLY';
      case EventRecruitmentType.both:
        return 'BOTH';
    }
  }

  static EventRecruitmentType? fromApiValue(Object? rawValue) {
    if (rawValue is! String) return null;
    switch (rawValue.toUpperCase()) {
      case 'CTV_ONLY':
        return EventRecruitmentType.ctvOnly;
      case 'ATTENDEE_ONLY':
        return EventRecruitmentType.attendeeOnly;
      case 'BOTH':
        return EventRecruitmentType.both;
      default:
        return null;
    }
  }
}

@JsonEnum()
enum EventRoleType {
  @JsonValue('ATTENDEE')
  attendee,
  @JsonValue('CTV')
  ctv,
}

@JsonEnum()
enum EventStatus {
  @JsonValue('PUBLISHED')
  published,
  @JsonValue('CLOSED')
  closed,
  @JsonValue('DRAFT')
  draft,
  @JsonValue('CANCELLED')
  cancelled,
}

extension EventStatusApiValue on EventStatus {
  String get apiValue {
    switch (this) {
      case EventStatus.published:
        return 'PUBLISHED';
      case EventStatus.closed:
        return 'CLOSED';
      case EventStatus.draft:
        return 'DRAFT';
      case EventStatus.cancelled:
        return 'CANCELLED';
    }
  }

  static EventStatus? fromApiValue(Object? rawValue) {
    if (rawValue is! String) return null;
    switch (rawValue.toUpperCase()) {
      case 'PUBLISHED':
        return EventStatus.published;
      case 'CLOSED':
        return EventStatus.closed;
      case 'DRAFT':
        return EventStatus.draft;
      case 'CANCELLED':
        return EventStatus.cancelled;
      default:
        return null;
    }
  }
}

@JsonEnum()
enum FeedbackQuestionType {
  @JsonValue('TEXT')
  text,
  @JsonValue('RATING')
  rating,
  @JsonValue('SINGLECHOICE')
  singleChoice,
  @JsonValue('MULTIPLECHOICE')
  multipleChoice,
}

extension FeedbackQuestionTypeApiValue on FeedbackQuestionType {
  String get apiValue {
    switch (this) {
      case FeedbackQuestionType.text:
        return 'TEXT';
      case FeedbackQuestionType.rating:
        return 'RATING';
      case FeedbackQuestionType.singleChoice:
        return 'SINGLECHOICE';
      case FeedbackQuestionType.multipleChoice:
        return 'MULTIPLECHOICE';
    }
  }

  static FeedbackQuestionType? fromApiValue(Object? rawValue) {
    if (rawValue is! String) return null;
    switch (rawValue.toUpperCase()) {
      case 'TEXT':
        return FeedbackQuestionType.text;
      case 'RATING':
        return FeedbackQuestionType.rating;
      case 'SINGLECHOICE':
        return FeedbackQuestionType.singleChoice;
      case 'MULTIPLECHOICE':
        return FeedbackQuestionType.multipleChoice;
      default:
        return null;
    }
  }
}

@JsonEnum()
enum NewsTargetType {
  @JsonValue('NONE')
  none,
  @JsonValue('EVENT')
  event,
  @JsonValue('USER')
  user,
  @JsonValue('PACKAGE')
  package,
  @JsonValue('EXTERNAL_URL')
  externalUrl,
}

@JsonEnum()
enum NotificationCreatedBy {
  @JsonValue('ADMIN')
  admin,
  @JsonValue('SYSTEM')
  system,
}

@JsonEnum()
enum NotificationTargetType {
  @JsonValue('EVENT')
  event,
  @JsonValue('CTV_RECRUITMENT')
  ctvRecruitment,
  @JsonValue('PORTFOLIO')
  portfolio,
  @JsonValue('USER_PROFILE')
  userProfile,
  @JsonValue('TRANSACTION')
  transaction,
  @JsonValue('NEWS')
  news,
  @JsonValue('NONE')
  none,
}

@JsonEnum()
enum OrganizationType {
  @JsonValue('UNIVERSITY')
  university,
  @JsonValue('CLUB')
  club,
  @JsonValue('COMPANY')
  company,
}

extension OrganizationTypeApiValue on OrganizationType {
  String get apiValue {
    switch (this) {
      case OrganizationType.university:
        return 'UNIVERSITY';
      case OrganizationType.club:
        return 'CLUB';
      case OrganizationType.company:
        return 'COMPANY';
    }
  }
}

@JsonEnum()
enum ParticipantType {
  @JsonValue('ATTENDEE')
  attendee,
  @JsonValue('CTV')
  ctv,
}

extension ParticipantTypeApiValue on ParticipantType {
  String get apiValue {
    switch (this) {
      case ParticipantType.attendee:
        return 'ATTENDEE';
      case ParticipantType.ctv:
        return 'CTV';
    }
  }

  static ParticipantType? fromApiValue(Object? rawValue) {
    if (rawValue is! String) return null;
    switch (rawValue.toUpperCase()) {
      case 'ATTENDEE':
        return ParticipantType.attendee;
      case 'CTV':
        return ParticipantType.ctv;
      default:
        return null;
    }
  }
}

@JsonEnum()
enum PaymentProvider {
  @JsonValue('MOMO')
  momo,
  @JsonValue('VNPAY')
  vnpay,
  @JsonValue('STRIPE')
  stripe,
  @JsonValue('SEPAY')
  sepay,
}

extension PaymentProviderApiValue on PaymentProvider {
  String get apiValue {
    switch (this) {
      case PaymentProvider.momo:
        return 'MOMO';
      case PaymentProvider.vnpay:
        return 'VNPAY';
      case PaymentProvider.stripe:
        return 'STRIPE';
      case PaymentProvider.sepay:
        return 'SEPAY';
    }
  }

  static PaymentProvider? fromApiValue(Object? rawValue) {
    if (rawValue is! String) return null;
    switch (rawValue.toUpperCase()) {
      case 'MOMO':
        return PaymentProvider.momo;
      case 'VNPAY':
        return PaymentProvider.vnpay;
      case 'STRIPE':
        return PaymentProvider.stripe;
      case 'SEPAY':
        return PaymentProvider.sepay;
      default:
        return null;
    }
  }
}

@JsonEnum()
enum RequirementQuestionType {
  @JsonValue('TEXT')
  text,
  @JsonValue('SINGLECHOICE')
  singleChoice,
  @JsonValue('MULTIPLECHOICE')
  multipleChoice,
}

extension RequirementQuestionTypeApiValue on RequirementQuestionType {
  String get apiValue {
    switch (this) {
      case RequirementQuestionType.text:
        return 'TEXT';
      case RequirementQuestionType.singleChoice:
        return 'SINGLECHOICE';
      case RequirementQuestionType.multipleChoice:
        return 'MULTIPLECHOICE';
    }
  }

  static RequirementQuestionType? fromApiValue(Object? rawValue) {
    if (rawValue is! String) return null;
    switch (rawValue.toUpperCase()) {
      case 'TEXT':
        return RequirementQuestionType.text;
      case 'SINGLECHOICE':
        return RequirementQuestionType.singleChoice;
      case 'MULTIPLECHOICE':
        return RequirementQuestionType.multipleChoice;
      default:
        return null;
    }
  }
}

@JsonEnum()
enum ScanMethod {
  @JsonValue('EVENT_QR')
  eventQr,
  @JsonValue('STAFF_QR')
  staffQr,
  @JsonValue('MANUAL')
  manual,
}

extension ScanMethodApiValue on ScanMethod {
  String get apiValue {
    switch (this) {
      case ScanMethod.eventQr:
        return 'EVENT_QR';
      case ScanMethod.staffQr:
        return 'STAFF_QR';
      case ScanMethod.manual:
        return 'MANUAL';
    }
  }

  static ScanMethod? fromApiValue(Object? rawValue) {
    if (rawValue is! String) return null;
    switch (rawValue.toUpperCase()) {
      case 'EVENT_QR':
        return ScanMethod.eventQr;
      case 'STAFF_QR':
        return ScanMethod.staffQr;
      case 'MANUAL':
        return ScanMethod.manual;
      default:
        return null;
    }
  }
}

@JsonEnum()
enum StaffApplicationStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('APPROVED')
  approved,
  @JsonValue('REJECTED')
  rejected,
}

extension StaffApplicationStatusApiValue on StaffApplicationStatus {
  String get apiValue {
    switch (this) {
      case StaffApplicationStatus.pending:
        return 'PENDING';
      case StaffApplicationStatus.approved:
        return 'APPROVED';
      case StaffApplicationStatus.rejected:
        return 'REJECTED';
    }
  }

  static StaffApplicationStatus? fromApiValue(Object? rawValue) {
    if (rawValue is! String) return null;
    switch (rawValue.toUpperCase()) {
      case 'PENDING':
        return StaffApplicationStatus.pending;
      case 'APPROVED':
        return StaffApplicationStatus.approved;
      case 'REJECTED':
        return StaffApplicationStatus.rejected;
      default:
        return null;
    }
  }
}

@JsonEnum()
enum TicketStatus {
  @JsonValue('UNPAID')
  unpaid,
  @JsonValue('ISSUED')
  issued,
  @JsonValue('USED')
  used,
  @JsonValue('EXPIRED')
  expired,
}

extension TicketStatusApiValue on TicketStatus {
  String get apiValue {
    switch (this) {
      case TicketStatus.unpaid:
        return 'UNPAID';
      case TicketStatus.issued:
        return 'ISSUED';
      case TicketStatus.used:
        return 'USED';
      case TicketStatus.expired:
        return 'EXPIRED';
    }
  }

  static TicketStatus? fromApiValue(Object? rawValue) {
    if (rawValue is! String) return null;
    switch (rawValue.toUpperCase()) {
      case 'UNPAID':
        return TicketStatus.unpaid;
      case 'ISSUED':
        return TicketStatus.issued;
      case 'USED':
        return TicketStatus.used;
      case 'EXPIRED':
        return TicketStatus.expired;
      default:
        return null;
    }
  }
}

@JsonEnum()
enum TransactionReferenceType {
  @JsonValue('TICKET')
  ticket,
  @JsonValue('PACKAGE_PURCHASE')
  packagePurchase,
  @JsonValue('PACKAGE_RENEWAL')
  packageRenewal,
  @JsonValue('PORTFOLIO')
  portfolio,
}

extension TransactionReferenceTypeApiValue on TransactionReferenceType {
  String get apiValue {
    switch (this) {
      case TransactionReferenceType.ticket:
        return 'TICKET';
      case TransactionReferenceType.packagePurchase:
        return 'PACKAGE_PURCHASE';
      case TransactionReferenceType.packageRenewal:
        return 'PACKAGE_RENEWAL';
      case TransactionReferenceType.portfolio:
        return 'PORTFOLIO';
    }
  }

  static TransactionReferenceType? fromApiValue(Object? rawValue) {
    if (rawValue is! String) return null;
    switch (rawValue.toUpperCase()) {
      case 'TICKET':
        return TransactionReferenceType.ticket;
      case 'PACKAGE_PURCHASE':
        return TransactionReferenceType.packagePurchase;
      case 'PACKAGE_RENEWAL':
        return TransactionReferenceType.packageRenewal;
      case 'PORTFOLIO':
        return TransactionReferenceType.portfolio;
      default:
        return null;
    }
  }
}

@JsonEnum()
enum TransactionStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('SUCCESS')
  success,
  @JsonValue('FAILED')
  failed,
}

@JsonEnum()
enum UserPackageStatus {
  @JsonValue('ACTIVE')
  active,
  @JsonValue('EXPIRE')
  expire,
}

@JsonEnum()
enum UserRole {
  @JsonValue('USER')
  user,
  @JsonValue('ADMIN')
  admin,
  @JsonValue('ORGANIZATION')
  organization,
}

extension UserRoleApiValue on UserRole {
  String get apiValue {
    switch (this) {
      case UserRole.user:
        return 'USER';
      case UserRole.admin:
        return 'ADMIN';
      case UserRole.organization:
        return 'ORGANIZATION';
    }
  }

  static UserRole? fromApiValue(Object? rawValue) {
    if (rawValue is! String) {
      return null;
    }

    switch (rawValue.toUpperCase()) {
      case 'USER':
        return UserRole.user;
      case 'ADMIN':
        return UserRole.admin;
      case 'ORGANIZATION':
        return UserRole.organization;
      default:
        return null;
    }
  }
}

@JsonEnum()
enum UserEventState {
  @JsonValue('NONE')
  none,
  @JsonValue('ATTENDEE')
  attendee,
  @JsonValue('CTV')
  ctv,
  @JsonValue('CTV_APPLIED')
  ctvApplied,
  @JsonValue('CTV_REJECTED')
  ctvRejected,
}

@JsonEnum()
enum UserStatus {
  @JsonValue('ACTIVE')
  active,
  @JsonValue('DISABLED')
  disabled,
}

extension UserStatusApiValue on UserStatus {
  String get apiValue {
    switch (this) {
      case UserStatus.active:
        return 'ACTIVE';
      case UserStatus.disabled:
        return 'DISABLED';
    }
  }

  static UserStatus? fromApiValue(Object? rawValue) {
    if (rawValue is! String) {
      return null;
    }
    switch (rawValue.toUpperCase()) {
      case 'DISABLED':
        return UserStatus.disabled;
      case 'ACTIVE':
      default:
        return UserStatus.active;
    }
  }
}

@JsonEnum()
enum VerificationStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('VERIFIED')
  verified,
  @JsonValue('REJECTED')
  rejected,
}

extension VerificationStatusApiValue on VerificationStatus {
  String get apiValue {
    switch (this) {
      case VerificationStatus.pending:
        return 'PENDING';
      case VerificationStatus.verified:
        return 'VERIFIED';
      case VerificationStatus.rejected:
        return 'REJECTED';
    }
  }

  static VerificationStatus? fromApiValue(Object? rawValue) {
    if (rawValue is! String) {
      return null;
    }

    switch (rawValue.toUpperCase()) {
      case 'PENDING':
        return VerificationStatus.pending;
      case 'VERIFIED':
      case 'APPROVED':  
        return VerificationStatus.verified;
      case 'REJECTED':
        return VerificationStatus.rejected;
      default:
        return null;
    }
  }
}

@JsonEnum()
enum FeedbackAnswerQuestionType {
  @JsonValue('TEXT')
  text,
  @JsonValue('RATING')
  rating,
  @JsonValue('SINGLECHOICE')
  singleChoice,
  @JsonValue('MULTIPLECHOICE')
  multipleChoice,
}

extension FeedbackAnswerQuestionTypeApiValue on FeedbackAnswerQuestionType {
  String get apiValue {
    switch (this) {
      case FeedbackAnswerQuestionType.text:
        return 'TEXT';
      case FeedbackAnswerQuestionType.rating:
        return 'RATING';
      case FeedbackAnswerQuestionType.singleChoice:
        return 'SINGLECHOICE';
      case FeedbackAnswerQuestionType.multipleChoice:
        return 'MULTIPLECHOICE';
    }
  }

  static FeedbackAnswerQuestionType? fromApiValue(Object? rawValue) {
    if (rawValue is! String) return null;
    switch (rawValue.toUpperCase()) {
      case 'TEXT':
        return FeedbackAnswerQuestionType.text;
      case 'RATING':
        return FeedbackAnswerQuestionType.rating;
      case 'SINGLECHOICE':
        return FeedbackAnswerQuestionType.singleChoice;
      case 'MULTIPLECHOICE':
        return FeedbackAnswerQuestionType.multipleChoice;
      default:
        return null;
    }
  }
}

@JsonEnum()
enum AttendanceAction {
  @JsonValue('CHECKIN')
  checkIn,
  @JsonValue('CHECKOUT')
  checkOut,
}

extension AttendanceActionApiValue on AttendanceAction {
  String get apiValue {
    switch (this) {
      case AttendanceAction.checkIn:
        return 'CHECKIN';
      case AttendanceAction.checkOut:
        return 'CHECKOUT';
    }
  }

  static AttendanceAction? fromApiValue(Object? rawValue) {
    if (rawValue is! String) return null;
    switch (rawValue.toUpperCase()) {
      case 'CHECKIN':
        return AttendanceAction.checkIn;
      case 'CHECKOUT':
        return AttendanceAction.checkOut;
      default:
        return null;
    }
  }
}

@JsonEnum()
enum RegistrationStatus {
  @JsonValue('REGISTERED')
  registered,
  @JsonValue('CANCELLED')
  cancelled,
}

extension RegistrationStatusApiValue on RegistrationStatus {
  String get apiValue {
    switch (this) {
      case RegistrationStatus.registered:
        return 'REGISTERED';
      case RegistrationStatus.cancelled:
        return 'CANCELLED';
    }
  }

  static RegistrationStatus? fromApiValue(Object? rawValue) {
    if (rawValue is! String) return null;
    switch (rawValue.toUpperCase()) {
      case 'REGISTERED':
        return RegistrationStatus.registered;
      case 'CANCELLED':
        return RegistrationStatus.cancelled;
      default:
        return null;
    }
  }
}

enum ApproveStatus {
  @JsonValue('APPROVED')
  approved,
  @JsonValue('REJECTED')
  rejected,
}

extension ApproveStatusApiValue on ApproveStatus {
  String get apiValue {
    switch (this) {
      case ApproveStatus.approved:
        return 'APPROVED';
      case ApproveStatus.rejected:
        return 'REJECTED';
    }
  }
}

enum RecruitmentCloseStatus {
  @JsonValue('CLOSED')
  closed,
  @JsonValue('OPEN')
  open,
}

extension RecruitmentCloseStatusApiValue on RecruitmentCloseStatus {
  String get apiValue {
    switch (this) {
      case RecruitmentCloseStatus.closed:
        return 'CLOSED';
      case RecruitmentCloseStatus.open:
        return 'OPEN';
    }
  }

  static RecruitmentCloseStatus? fromApiValue(Object? rawValue) {
    if (rawValue is! String) return null;
    switch (rawValue.toUpperCase()) {
      case 'CLOSED':
        return RecruitmentCloseStatus.closed;
      case 'OPEN':
        return RecruitmentCloseStatus.open;
      default:
        return null;
    }
  }
}

enum FileType {
  avatar,
  eventBanner,
  recruitmentBanner,
  newsBanner,
  organizationLogo,
  verificationDocument,
}

extension FileTypeApiValue on FileType {
  String get apiValue {
    switch (this) {
      case FileType.avatar:
        return 'AVATAR';
      case FileType.eventBanner:
        return 'EVENT_BANNER';
      case FileType.recruitmentBanner:
        return 'RECRUITMENT_BANNER';
      case FileType.newsBanner:
        return 'NEWS_BANNER';
      case FileType.organizationLogo:
        return 'ORGANIZATION_LOGO';
      case FileType.verificationDocument:
        return 'VERIFICATION_DOCUMENT';
    }
  }

  String get displayLabel {
    switch (this) {
      case FileType.avatar:
        return 'Ảnh đại diện';
      case FileType.eventBanner:
        return 'Banner sự kiện';
      case FileType.recruitmentBanner:
        return 'Banner tuyển dụng';
      case FileType.newsBanner:
        return 'Banner tin tức';
      case FileType.organizationLogo:
        return 'Logo tổ chức';
      case FileType.verificationDocument:
        return 'Tài liệu xác minh';
    }
  }

  int get maxSizeBytes {
    switch (this) {
      case FileType.verificationDocument:
        return 10 * 1024 * 1024; // 10MB
      default:
        return 5 * 1024 * 1024; // 5MB
    }
  }

  static FileType? fromApiValue(Object? rawValue) {
    if (rawValue is! String) return null;
    switch (rawValue.toUpperCase()) {
      case 'AVATAR':
        return FileType.avatar;
      case 'EVENT_BANNER':
        return FileType.eventBanner;
      case 'RECRUITMENT_BANNER':
        return FileType.recruitmentBanner;
      case 'NEWS_BANNER':
        return FileType.newsBanner;
      case 'ORGANIZATION_LOGO':
        return FileType.organizationLogo;
      case 'VERIFICATION_DOCUMENT':
        return FileType.verificationDocument;
      default:
        return null;
    }
  }
}
