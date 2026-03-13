import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum AttendanceLogType {
  @JsonValue('CHECKIN')
  checkIn,
  @JsonValue('CHECKOUT')
  checkOut,
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
  @JsonValue('NEWS_READ')
  newsRead,
  @JsonValue('EVENT_ATTEND')
  eventAttend,
  @JsonValue('FEEDBACK')
  feedback,
  @JsonValue('BUY_TICKET')
  buyTicket,
  @JsonValue('BUY_PACKAGE')
  buyPackage,
  @JsonValue('PORTFOLIO')
  portfolio,
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

@JsonEnum()
enum EventParticipantStatus {
  @JsonValue('REGISTERED')
  registered,
  @JsonValue('ATTENDED')
  attended,
  @JsonValue('NOSHOW')
  noShow,
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

@JsonEnum()
enum FeedbackQuestionType {
  @JsonValue('RATING')
  rating,
  @JsonValue('TEXT')
  text,
}

@JsonEnum()
enum NewsTargetType {
  @JsonValue('NONE')
  none,
  @JsonValue('PUBLIC')
  publicTarget,
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

@JsonEnum()
enum ParticipantType {
  @JsonValue('ATTENDEE')
  attendee,
  @JsonValue('CTV')
  ctv,
}

@JsonEnum()
enum PaymentProvider {
  @JsonValue('MOMO')
  momo,
  @JsonValue('VNPAY')
  vnpay,
  @JsonValue('STRIPE')
  stripe,
}

@JsonEnum()
enum RequirementQuestionType {
  @JsonValue('TEXT')
  text,
  @JsonValue('SINGLECHOICE')
  singleChoice,
}

@JsonEnum()
enum ScanMethod {
  @JsonValue('EVENT_QR')
  eventQr,
  @JsonValue('STAFF_QR')
  staffQr,
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

@JsonEnum()
enum TicketStatus {
  @JsonValue('ISSUED')
  issued,
  @JsonValue('USED')
  used,
  @JsonValue('EXPIRED')
  expired,
}

@JsonEnum()
enum TransactionReferenceType {
  @JsonValue('TICKET')
  ticket,
  @JsonValue('PACKAGE')
  package,
  @JsonValue('PORTFOLIO')
  portfolio,
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

@JsonEnum()
enum UserStatus {
  @JsonValue('ACTIVE')
  active,
  @JsonValue('DISABLED')
  disabled,
}

@JsonEnum()
enum VerificationStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('APPROVED')
  approved,
  @JsonValue('REJECTED')
  rejected,
}
