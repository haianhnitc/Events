import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  debugPrint('FCM background message: ${message.messageId}');
}

class FcmService {
  final FirebaseMessaging _messaging;

  FcmService({FirebaseMessaging? messaging})
      : _messaging = messaging ?? FirebaseMessaging.instance;

  String? _token;
  String? get token => _token;

  Future<AuthorizationStatus> getPermissionStatus() async {
    if (kIsWeb) return AuthorizationStatus.notDetermined;
    final settings = await _messaging.getNotificationSettings();
    return settings.authorizationStatus;
  }

  Future<void> initialize({
    void Function(RemoteMessage message)? onForegroundMessage,
    void Function(RemoteMessage message)? onMessageOpenedApp,
    void Function(String token)? onToken,
  }) async {
    if (kIsWeb) return;

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('FCM permission denied');
      return;
    }

    _token = await _messaging.getToken();
    if (_token != null) onToken?.call(_token!);

    _messaging.onTokenRefresh.listen((newToken) {
      _token = newToken;
      onToken?.call(newToken);
    });

    FirebaseMessaging.onMessage.listen((message) {
      onForegroundMessage?.call(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      onMessageOpenedApp?.call(message);
    });
  }
}
