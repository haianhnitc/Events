import 'package:flutter/material.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/payment/domain/entity/payment_url_entity.dart';
import 'package:events_app/feature/payment/presentation/controller/sepay_payment_controller.dart';
import 'package:events_app/feature/payment/presentation/page/shared_payment_flow_args.dart';
import 'package:get/get.dart';

class SharedPaymentCheckoutController extends GetxController {
  final SharedPaymentFlowArgs args;

  SharedPaymentCheckoutController({required this.args});

  late final SePayPaymentController _paymentController;
  late final TextEditingController coinController;

  final RxBool isLoading = false.obs;
  final RxString coinError = ''.obs;

  int get currentCoin => AuthController.to.currentUser.value?.currentCoin ?? 0;

  int get coinUsedRaw {
    final parsed = int.tryParse(coinController.text.trim());
    return parsed ?? 0;
  }

  int get coinUsed {
    if (coinUsedRaw < 0) return 0;
    if (coinUsedRaw > args.originalAmount) return args.originalAmount;
    if (coinUsedRaw > currentCoin) return currentCoin;
    return coinUsedRaw;
  }

  int get finalAmount {
    return (args.originalAmount - coinUsed).clamp(
      0,
      args.originalAmount,
    );
  }

  bool get coinInputInvalid {
    return coinUsedRaw < 0 || coinUsedRaw > currentCoin || coinUsedRaw > args.originalAmount;
  }

  bool get isCreatingPayment => _paymentController.isCreatingPayment.value;

  SharedPaymentCheckoutController init() {
    _paymentController = Get.find<SePayPaymentController>();
    coinController = TextEditingController(text: args.initialCoinUsed > 0 ? '${args.initialCoinUsed}' : '');
    return this;
  }

  void onCoinChanged() {
    coinError.value = '';
    if (coinUsedRaw > currentCoin) {
      coinError.value = 'Số coin vượt quá số dư';
    } else if (coinUsedRaw > args.originalAmount) {
      coinError.value = 'Số coin vượt quá giá vé';
    }
  }

  Future<PaymentUrlEntity?> createPayment() async {
    if (isLoading.value) return null;
    isLoading.value = true;

    try {
      final payment = await _paymentController.createPayment(
        referenceType: args.referenceType,
        referenceId: args.referenceId,
        originalAmount: args.originalAmount,
        coinUsed: coinUsed,
        currency: args.currency,
        extraData: args.extraData,
      );
      return payment;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    coinController.dispose();
    super.onClose();
  }
}
