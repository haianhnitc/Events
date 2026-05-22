import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimezoneHelper {
  static bool _initialized = false;

  static void ensureInitialized() {
    if (!_initialized) {
      tz.initializeTimeZones();
      _initialized = true;
    }
  }

  static tz.TZDateTime toAsiaHCM(DateTime utcDateTime) {
    ensureInitialized();
    final hcmTz = tz.getLocation('Asia/Ho_Chi_Minh');
    return tz.TZDateTime.from(utcDateTime.toUtc(), hcmTz);
  }
}
