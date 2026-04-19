import 'package:uuid/uuid.dart';

class IdempotencyHelper {
  static const List<String> _paymentEndpoints = [
    '/finance/coin-transaction',
    '/finance/transaction',
    '/finance/momo-payment',
    '/finance/sepay-payment',
    '/finance/packages',
    '/finance/portfolio',
  ];

  static bool requiresIdempotencyKey(String path) {
    return _paymentEndpoints.any((endpoint) => path.contains(endpoint));
  }

  static String generateIdempotencyKey() {
    return const Uuid().v4();
  }

  static String? _findIdempotencyHeaderKey(Map<String, dynamic>? headers) {
    if (headers == null) return null;
    for (final key in headers.keys) {
      if (key.toLowerCase() == 'idempotency-key') {
        return key;
      }
    }
    return null;
  }

  static bool hasIdempotencyKey(Map<String, dynamic>? headers) {
    return _findIdempotencyHeaderKey(headers) != null;
  }

  static String getOrGenerateIdempotencyKey(Map<String, dynamic>? headers) {
    final headerKey = _findIdempotencyHeaderKey(headers);
    if (headerKey != null) {
      final value = headers![headerKey];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
    }

    return generateIdempotencyKey();
  }
}
