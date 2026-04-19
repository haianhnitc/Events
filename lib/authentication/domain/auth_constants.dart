class AuthConstants {
  AuthConstants._();

  static const String organizerPendingCode = 'ORG_PENDING';
  static const String organizerRejectedCode = 'ORG_REJECTED';
  static const String userDisabledCode = 'USER_DISABLED';
  static const String profileNotFoundCode = '404';
  static const String accountConflictCode = '409';
}

enum AuthEvent {
  loginSuccess,
  sessionExpired,
  accountDisabled,
  organizerPending,
  organizerRejected,
  logoutComplete,
}
