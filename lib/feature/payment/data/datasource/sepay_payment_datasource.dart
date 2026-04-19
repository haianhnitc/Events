import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/payment/data/model/payment_url_model.dart';
import 'package:events_app/feature/payment/data/model/transaction_model.dart';
import 'package:events_app/feature/payment/domain/usecase/sepay_payment_params.dart';
import 'package:injectable/injectable.dart';

abstract class SePayPaymentDatasource {
  Future<ApiResponse<PaymentUrlModel>> createSePayPayment(
      CreateTransactionParams params);

  Future<ApiResponse<TransactionModel>> getTransactionById(int transactionId);

  Future<ApiResponse<List<TransactionModel>>> getTransactions();
}

@Injectable(as: SePayPaymentDatasource)
class SePayPaymentDatasourceImpl extends ApiProvider
    implements SePayPaymentDatasource {
  SePayPaymentDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<PaymentUrlModel>> createSePayPayment(
    CreateTransactionParams params,
  ) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiPath.sePayPayment,
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(params.toJson()),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<PaymentUrlModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return PaymentUrlModel.fromJson(object);
        },
        fallbackError: 'Tạo thanh toán SePay thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<TransactionModel>> getTransactionById(
    int transactionId,
  ) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.transactionDetail(transactionId),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<TransactionModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return TransactionModel.fromJson(object);
        },
        fallbackError: 'Lấy thông tin giao dịch thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<List<TransactionModel>>> getTransactions() async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.transactions,
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<List<TransactionModel>>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          final content =
              (object['content'] as List<dynamic>?) ?? <dynamic>[];
          return content
              .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
        fallbackError: 'Lấy danh sách giao dịch thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
