library nrd_network;

export 'package:dartz/dartz.dart';
export 'api_provider.dart';
export 'services/rest_clients.dart';
export 'base_request/api_request.dart';

class EventNetwork {
  static String baseUrl = '';

  static void setBaseUrl({required String baseUrl}) {
    EventNetwork.baseUrl = baseUrl;
  }
}
