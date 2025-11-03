library nrd_network;

import 'package:shared_preferences/shared_preferences.dart';

export 'package:dartz/dartz.dart';
export 'api_provider.dart';
export 'services/rest_clients.dart';
export 'di/injection.dart';
export 'base_request/api_request.dart';

class EvnetNetwork {
  static String baseUrl = '';
  // static List<RequestLogEntry> logEntries = [];

  ///
  /// Set the base URL for all REST request
  /// This 'baseUrl' must start with 'https://' and end with '/'
  ///
  static void setBaseUrl({required String baseUrl}) {
    EvnetNetwork.baseUrl = baseUrl;
  }

  ///
  /// Set the access token for all requests
  ///
  static void setAccessToken({required String accessToken}) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString('access_token', accessToken);
  }
}
