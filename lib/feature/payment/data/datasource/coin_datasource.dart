import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/payment/data/model/coin_transaction_model.dart';
import 'package:injectable/injectable.dart';

class CoinPage {
  final List<CoinTransactionModel> items;
  final int totalElements;
  final int totalPages;
  final int page;
  final int size;

  const CoinPage({
    required this.items,
    required this.totalElements,
    required this.totalPages,
    required this.page,
    required this.size,
  });
}

abstract class CoinDatasource {
  Future<ApiResponse<CoinPage>> getCoinHistory({
    int page = 0,
    int size = 20,
    String sort = 'createdTime,desc',
  });
}

@Injectable(as: CoinDatasource)
class CoinDatasourceImpl extends ApiProvider implements CoinDatasource {
  CoinDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<CoinPage>> getCoinHistory({
    int page = 0,
    int size = 20,
    String sort = 'createdTime,desc',
  }) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.coinHistory,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: {
          'page': page,
          'size': size,
          'sort': sort,
        },
        requireAuth: true,
      );

      return forwardEnvelopeResponse<CoinPage>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          final contentList = object['content'] as List<dynamic>? ?? [];
          return CoinPage(
            items: contentList
                .map((e) => CoinTransactionModel.fromJson(e as Map<String, dynamic>))
                .toList(),
            totalElements: object['totalElements'] as int? ?? 0,
            totalPages: object['totalPages'] as int? ?? 0,
            page: object['number'] as int? ?? page,
            size: object['size'] as int? ?? size,
          );
        },
        fallbackError: 'Khong the tai lich su coin',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
