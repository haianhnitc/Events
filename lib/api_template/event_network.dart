library nrd_network;

import 'package:shared_preferences/shared_preferences.dart';

export 'package:dartz/dartz.dart';
export 'api_provider.dart';
export 'services/rest_clients.dart';
export 'di/injection.dart';
export 'base_request/api_request.dart';

class EvnetNetwork {
  static String baseUrl = '';

  static void setBaseUrl({required String baseUrl}) {
    EvnetNetwork.baseUrl = baseUrl;
  }

  static void setAccessToken({required String accessToken}) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString('access_token', accessToken);
  }
}
