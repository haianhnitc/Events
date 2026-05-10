import 'dart:async';

import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/payment/domain/entity/payment_url_entity.dart';
import 'package:events_app/feature/payment/domain/entity/transaction_entity.dart';
import 'package:events_app/feature/payment/domain/usecase/sepay_payment_usecase.dart';
import 'package:events_app/feature/payment/domain/usecase/sepay_payment_params.dart';
import 'package:flutter/foundation.dart';
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
  static const Duration _pollingInterval = Duration(seconds: 3);

  Function(TransactionEntity)? _pendingOnSuccess;
  Function(TransactionEntity)? _pendingOnFailure;
  VoidCallback? _pendingOnTimeout;

  int _currentTransactionId = 0;

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
    VoidCallback? onTimeout,
  }) async {
    if (isPolling.value) return false;
    stopPolling();

    _currentTransactionId = transactionId;
    _pendingOnSuccess = onSuccess;
    _pendingOnFailure = onFailure;
    _pendingOnTimeout = onTimeout;
    isPolling.value = true;
    pollingCount.value = 0;
    debugPrint(
        '[SePayPaymentController] startPolling() called for transactionId=$transactionId');

    _doPoll();
    return true;
  }

  Future<void> _doPoll() async {
    debugPrint('[SePayPaymentController] _doPoll() ENTERED - isPolling=${isPolling.value}, pollingCount=${pollingCount.value}');
    if (!isPolling.value) {
      debugPrint('[SePayPaymentController] _doPoll() SKIPPED - not polling');
      return;
    }

    pollingCount.value++;
    if (pollingCount.value > _maxPollingAttempts) {
      stopPolling();
      debugPrint(
          '[SePayPaymentController] Max polling attempts reached, stopping.');
      _pendingOnTimeout?.call();
      return;
    }

    final result = await _getTransactionStatusUsecase(
        GetTransactionStatusParams(transactionId: _currentTransactionId));

    await result.fold(
      (failure) async {
        debugPrint(
            '[SePayPaymentController] Poll ${pollingCount.value}: FAILURE - $failure');
        if (isPolling.value) {
          _scheduleNextPoll();
        }
      },
      (transaction) async {
        debugPrint(
            '[SePay] Poll ${pollingCount.value}: status = ${transaction.status} (raw: $transaction)');
        if (!isPolling.value) return;

        if (transaction.status == TransactionStatus.pending) {
          _scheduleNextPoll();
          return;
        }

        isPolling.value = false;
        if (transaction.status == TransactionStatus.failed) {
          debugPrint('[SePay] Payment FAILED');
          _pendingOnFailure?.call(transaction);
        } else {
          debugPrint(
              '[SePay] Payment SUCCESS — triggering callback, isPolling=$isPolling');
          _pendingOnSuccess?.call(transaction);
          debugPrint('[SePay] Callback returned');
        }
      },
    );
  }

  void _scheduleNextPoll() {
    debugPrint(
        '[SePayPaymentController] Scheduling next poll in ${_pollingInterval.inSeconds}s (attempt ${pollingCount.value}/$_maxPollingAttempts)');
    _pollingTimer?.cancel();
    _pollingTimer = Timer(_pollingInterval, _doPoll);
  }

  void stopPolling() {
    debugPrint('[SePayPaymentController] stopPolling() CALLED');
    _pollingTimer?.cancel();
    _pollingTimer = null;
    isPolling.value = false;
    pollingCount.value = 0;
    debugPrint('[SePayPaymentController] stopPolling() DONE - isPolling=${isPolling.value}');
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
