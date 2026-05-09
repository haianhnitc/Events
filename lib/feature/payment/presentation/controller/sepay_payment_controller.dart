import 'dart:async';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/payment/domain/entity/payment_url_entity.dart';
import 'package:events_app/feature/payment/domain/entity/transaction_entity.dart';
import 'package:events_app/feature/payment/domain/usecase/sepay_payment_usecase.dart';
import 'package:events_app/feature/payment/domain/usecase/sepay_payment_params.dart';
import 'package:get/get.dart';

class SePayPaymentController extends GetxController {
  final CreateSePayPaymentUsecase _createSePayPaymentUsecase =
      networkGetIt<CreateSePayPaymentUsecase>();
  final GetTransactionStatusUsecase _getTransactionStatusUsecase =
      networkGetIt<GetTransactionStatusUsecase>();

  final Rx<PaymentUrlEntity?> currentPayment = Rx<PaymentUrlEntity?>(null);
  final RxBool isCreatingPayment = false.obs;
  final RxBool isPolling = false.obs;
  final RxInt pollingCount = 0.obs;

  Timer? _pollingTimer;
  static const int _maxPollingAttempts = 60;
  static const Duration _pollingInterval = Duration(seconds: 2);

  Future<PaymentUrlEntity?> createPayment({
    required TransactionReferenceType referenceType,
    int? referenceId,
    required int originalAmount,
    int coinUsed = 0,
    String? extraData,
    String currency = 'VND',
  }) async {
    if (isCreatingPayment.value) return null;
    isCreatingPayment.value = true;

    try {
      final result = await _createSePayPaymentUsecase(
        CreateTransactionParams(
          referenceType: referenceType,
          referenceId: referenceId,
          originalAmount: originalAmount,
          coinUsed: coinUsed,
          currency: currency,
          paymentProvider: PaymentProvider.sepay,
          extraData: extraData,
        ),
      );

      PaymentUrlEntity? payment;
      result.fold(
        (failure) {
          _handleFailure(failure);
          payment = null;
        },
        (paymentResponse) {
          currentPayment.value = paymentResponse;
          payment = paymentResponse;
        },
      );
      return payment;
    } finally {
      isCreatingPayment.value = false;
    }
  }

  Future<bool> startPolling({
    required int transactionId,
    required Function(TransactionEntity transaction) onSuccess,
    Function(TransactionEntity transaction)? onFailure,
  }) async {
    if (isPolling.value) return false;
    isPolling.value = true;
    pollingCount.value = 0;

    return await _pollTransaction(
      transactionId: transactionId,
      onSuccess: onSuccess,
      onFailure: onFailure,
    );
  }

  Future<bool> _pollTransaction({
    required int transactionId,
    required Function(TransactionEntity transaction) onSuccess,
    Function(TransactionEntity transaction)? onFailure,
  }) async {
    if (!isPolling.value || pollingCount.value >= _maxPollingAttempts) {
      isPolling.value = false;
      return false;
    }

    pollingCount.value++;

    final result = await _getTransactionStatusUsecase(
        GetTransactionStatusParams(transactionId: transactionId));

    return await result.fold(
      (failure) async {
        await Future.delayed(_pollingInterval);
        return await _pollTransaction(
          transactionId: transactionId,
          onSuccess: onSuccess,
          onFailure: onFailure,
        );
      },
      (transaction) async {
        if (transaction.status == TransactionStatus.pending) {
          await Future.delayed(_pollingInterval);
          return _pollTransaction(
            transactionId: transactionId,
            onSuccess: onSuccess,
            onFailure: onFailure,
          );
        }

        isPolling.value = false;
        if (transaction.status == TransactionStatus.failed) {
          onFailure?.call(transaction);
          return false;
        }
        onSuccess(transaction);
        return true;
      },
    );
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    isPolling.value = false;
    pollingCount.value = 0;
  }

  void clearPayment() {
    stopPolling();
    currentPayment.value = null;
  }

  String getPaymentContent() {
    final orderId = currentPayment.value?.orderId;
    if (orderId == null) return '';
    return 'EVENTS-TX-$orderId';
  }

  String? getQrCodeUrl() {
    return currentPayment.value?.qrCodeUrl ?? currentPayment.value?.paymentUrl;
  }

  String? getPaymentUrl() {
    return currentPayment.value?.paymentUrl;
  }

  DateTime? getExpireTime() {
    final ms = currentPayment.value?.expireTime;
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  bool isPaymentExpired() {
    final ms = currentPayment.value?.expireTime;
    if (ms == null) return false;
    return DateTime.now().isAfter(DateTime.fromMillisecondsSinceEpoch(ms));
  }

  void _handleFailure(FailureEntity failure) {
    AuthController.handleFailure(failure);
  }

  @override
  void onClose() {
    stopPolling();
    super.onClose();
  }
}
