import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/payment/data/datasource/sepay_payment_datasource.dart';
import 'package:events_app/feature/payment/data/model/payment_url_model.dart';
import 'package:events_app/feature/payment/data/model/transaction_model.dart';
import 'package:events_app/feature/payment/domain/usecase/sepay_payment_params.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_data.dart';
import '../helpers/mock_rest_client.dart';

class TestSePayPaymentDatasource extends SePayPaymentDatasourceImpl {
  ApiResponse<Map<String, dynamic>>? createStub;
  ApiResponse<Map<String, dynamic>>? getTransactionByIdStub;
  ApiResponse<Map<String, dynamic>>? getTransactionsStub;
  Map<String, dynamic>? lastRequestBody;

  TestSePayPaymentDatasource({
    this.createStub,
    this.getTransactionByIdStub,
    this.getTransactionsStub,
  }) : super(client: StubRestClient());

  @override
  Future<ApiResponse<PaymentUrlModel>> createSePayPayment(
    CreateTransactionParams params,
  ) async {
    lastRequestBody = params.toJson();
    final envelope = createStub ??
        successEnvelope(fakePaymentUrlJson());
    return forwardEnvelopeResponse<PaymentUrlModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return PaymentUrlModel.fromJson(object);
      },
      fallbackError: 'Tạo thanh toán SePay thất bại',
    );
  }

  @override
  Future<ApiResponse<TransactionModel>> getTransactionById(
    int transactionId,
  ) async {
    final envelope = getTransactionByIdStub ??
        successEnvelope(fakeTransactionJson(id: transactionId));
    return forwardEnvelopeResponse<TransactionModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return TransactionModel.fromJson(object);
      },
      fallbackError: 'Lấy thông tin giao dịch thất bại',
    );
  }

  @override
  Future<ApiResponse<List<TransactionModel>>> getTransactions() async {
    final envelope = getTransactionsStub ??
        successEnvelope({
          'content': [fakeTransactionJson()],
        });
    return forwardEnvelopeResponse<List<TransactionModel>>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        final content = (object['content'] as List<dynamic>?) ?? <dynamic>[];
        return content
            .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      fallbackError: 'Lấy danh sách giao dịch thất bại',
    );
  }
}

void main() {
  group('createSePayPayment', () {
    test('trả về PaymentUrlModel với paymentUrl và qrCodeUrl khi thành công', () async {
      final datasource = TestSePayPaymentDatasource(
        createStub: successEnvelope(fakePaymentUrlJson(id: 123)),
      );

      final result = await datasource.createSePayPayment(
        CreateTransactionParams(
          referenceType: TransactionReferenceType.ticket,
          referenceId: 5,
          originalAmount: 100000,
          paymentProvider: PaymentProvider.sepay,
        ),
      );

      result.when(
        success: (paymentUrl) {
          expect(paymentUrl.paymentUrl, isNotNull);
          expect(paymentUrl.qrCodeUrl, isNotNull);
          expect(paymentUrl.orderId, equals(123));
        },
        unexpected: (_) => fail('Expected success'),
        badRequest: (_) => fail('Expected success'),
        unauthorized: (_) => fail('Expected success'),
        forbidden: (_) => fail('Expected success'),
        notFound: (_) => fail('Expected success'),
        conflict: (_) => fail('Expected success'),
        internalServerError: () => fail('Expected success'),
        badGateway: () => fail('Expected success'),
        serviceUnavailable: () => fail('Expected success'),
        gatewayTimeout: () => fail('Expected success'),
        canceled: () => fail('Expected success'),
        responseParsing: () => fail('Expected success'),
      );
    });

    test('gửi đúng body params', () async {
      final datasource = TestSePayPaymentDatasource(
        createStub: successEnvelope(fakePaymentUrlJson()),
      );

      await datasource.createSePayPayment(
        CreateTransactionParams(
          referenceType: TransactionReferenceType.ticket,
          referenceId: 10,
          originalAmount: 50000,
          coinUsed: 1000,
          paymentProvider: PaymentProvider.sepay,
        ),
      );

      expect(datasource.lastRequestBody, isNotNull);
      expect(datasource.lastRequestBody!['referenceType'], equals('TICKET'));
      expect(datasource.lastRequestBody!['referenceId'], equals(10));
      expect(datasource.lastRequestBody!['originalAmount'], equals(50000));
      expect(datasource.lastRequestBody!['coinUsed'], equals(1000));
      expect(datasource.lastRequestBody!['paymentProvider'], equals('SEPAY'));
    });

    test('trả về badRequest khi dữ liệu không hợp lệ', () async {
      final datasource = TestSePayPaymentDatasource(
        createStub: badRequestResponse(),
      );

      final result = await datasource.createSePayPayment(
        CreateTransactionParams(
          referenceType: TransactionReferenceType.ticket,
          originalAmount: 0,
          paymentProvider: PaymentProvider.sepay,
        ),
      );

      expect(
        result.when(
          success: (_) => false,
          badRequest: (_) => true,
          unauthorized: (_) => false,
          forbidden: (_) => false,
          notFound: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });

    test('trả về unauthorized khi 401', () async {
      final datasource = TestSePayPaymentDatasource(
        createStub: unauthorizedResponse(),
      );

      final result = await datasource.createSePayPayment(
        CreateTransactionParams(
          referenceType: TransactionReferenceType.ticket,
          originalAmount: 100000,
          paymentProvider: PaymentProvider.sepay,
        ),
      );

      expect(
        result.when(
          success: (_) => false,
          unauthorized: (_) => true,
          badRequest: (_) => false,
          forbidden: (_) => false,
          notFound: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });
  });

  group('getTransactionById', () {
    test('trả về TransactionModel khi thành công', () async {
      final datasource = TestSePayPaymentDatasource(
        getTransactionByIdStub: successEnvelope(fakeTransactionJson(id: 77)),
      );

      final result = await datasource.getTransactionById(77);

      result.when(
        success: (transaction) {
          expect(transaction.transactionId, equals(77));
          expect(transaction.finalAmount, equals(100000));
        },
        unexpected: (_) => fail('Expected success'),
        badRequest: (_) => fail('Expected success'),
        unauthorized: (_) => fail('Expected success'),
        forbidden: (_) => fail('Expected success'),
        notFound: (_) => fail('Expected success'),
        conflict: (_) => fail('Expected success'),
        internalServerError: () => fail('Expected success'),
        badGateway: () => fail('Expected success'),
        serviceUnavailable: () => fail('Expected success'),
        gatewayTimeout: () => fail('Expected success'),
        canceled: () => fail('Expected success'),
        responseParsing: () => fail('Expected success'),
      );
    });

    test('trả về notFound khi giao dịch không tồn tại', () async {
      final datasource = TestSePayPaymentDatasource(
        getTransactionByIdStub: notFoundResponse(),
      );

      final result = await datasource.getTransactionById(9999);

      expect(
        result.when(
          success: (_) => false,
          notFound: (_) => true,
          unauthorized: (_) => false,
          badRequest: (_) => false,
          forbidden: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });
  });

  group('getTransactions', () {
    test('trả về list TransactionModel khi thành công', () async {
      final datasource = TestSePayPaymentDatasource(
        getTransactionsStub: successEnvelope({
          'content': [
            fakeTransactionJson(id: 1),
            fakeTransactionJson(id: 2),
          ],
        }),
      );

      final result = await datasource.getTransactions();

      result.when(
        success: (transactions) {
          expect(transactions.length, equals(2));
          expect(transactions.first.transactionId, equals(1));
        },
        unexpected: (_) => fail('Expected success'),
        badRequest: (_) => fail('Expected success'),
        unauthorized: (_) => fail('Expected success'),
        forbidden: (_) => fail('Expected success'),
        notFound: (_) => fail('Expected success'),
        conflict: (_) => fail('Expected success'),
        internalServerError: () => fail('Expected success'),
        badGateway: () => fail('Expected success'),
        serviceUnavailable: () => fail('Expected success'),
        gatewayTimeout: () => fail('Expected success'),
        canceled: () => fail('Expected success'),
        responseParsing: () => fail('Expected success'),
      );
    });

    test('trả về list rỗng khi content rỗng', () async {
      final datasource = TestSePayPaymentDatasource(
        getTransactionsStub: successEnvelope({'content': []}),
      );

      final result = await datasource.getTransactions();

      result.when(
        success: (transactions) => expect(transactions, isEmpty),
        unexpected: (_) => fail('Expected success'),
        badRequest: (_) => fail('Expected success'),
        unauthorized: (_) => fail('Expected success'),
        forbidden: (_) => fail('Expected success'),
        notFound: (_) => fail('Expected success'),
        conflict: (_) => fail('Expected success'),
        internalServerError: () => fail('Expected success'),
        badGateway: () => fail('Expected success'),
        serviceUnavailable: () => fail('Expected success'),
        gatewayTimeout: () => fail('Expected success'),
        canceled: () => fail('Expected success'),
        responseParsing: () => fail('Expected success'),
      );
    });

    test('trả về internalServerError khi 500', () async {
      final datasource = TestSePayPaymentDatasource(
        getTransactionsStub: serverErrorResponse(),
      );

      final result = await datasource.getTransactions();

      expect(
        result.when(
          success: (_) => false,
          internalServerError: () => true,
          badRequest: (_) => false,
          unauthorized: (_) => false,
          forbidden: (_) => false,
          notFound: (_) => false,
          conflict: (_) => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });
  });
}
