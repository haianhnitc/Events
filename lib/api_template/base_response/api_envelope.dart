class ApiEnvelope<T> {
  final int? errorCode;
  final int? statusCode;
  final String? message;
  final T? object;

  const ApiEnvelope({
    required this.errorCode,
    required this.statusCode,
    required this.message,
    required this.object,
  });

  factory ApiEnvelope.fromJson(
    Map<String, dynamic> json,
    T Function(Object? jsonObject) objectParser,
  ) {
    return ApiEnvelope<T>(
      errorCode: json['errorCode'] as int?,
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      object: objectParser(json['object']),
    );
  }

  bool get isSuccess => (errorCode ?? -1) == 0;
}
