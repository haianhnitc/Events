import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/payment/domain/entity/payment_url_entity.dart';
import 'package:events_app/feature/payment/domain/entity/transaction_entity.dart';
import 'package:events_app/feature/payment/presentation/controller/sepay_payment_controller.dart';
import 'package:events_app/feature/payment/presentation/controller/shared_payment_checkout_controller.dart';
import 'package:events_app/feature/payment/presentation/page/shared_payment_flow_args.dart';
import 'package:events_app/feature/payment/presentation/widget/coin_input_section.dart';
import 'package:events_app/feature/payment/presentation/widget/payment_item_info_card.dart';
import 'package:events_app/feature/payment/presentation/widget/payment_summary_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SharedPaymentCheckoutPage extends StatelessWidget {
  final SharedPaymentFlowArgs args;

  const SharedPaymentCheckoutPage({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SharedPaymentCheckoutController(args: args)..init();
    return GetBuilder<SharedPaymentCheckoutController>(
      init: controller,
      builder: (ctrl) => _CheckoutView(controller: ctrl),
    );
  }
}

class _CheckoutView extends StatelessWidget {
  final SharedPaymentCheckoutController controller;

  const _CheckoutView({required this.controller});

  @override
  Widget build(BuildContext context) {
    final itemInfo = controller.args.itemInfo ?? controller.args.parseItemInfo();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận thanh toán'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xff273143),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xffF3F4F6),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              controller.args.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xff273143),
              ),
            ),
            if ((controller.args.subtitle ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                controller.args.subtitle!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff67688C),
                ),
              ),
            ],
            if (itemInfo != null) ...[
              const SizedBox(height: 16),
              PaymentItemInfoCard(itemInfo: itemInfo),
            ],
            const SizedBox(height: 16),
            CoinInputSection(
              controller: controller.coinController,
              currentCoin: controller.currentCoin,
              originalAmount: controller.args.originalAmount,
              errorText: controller.coinError.value,
              onChanged: (_) => controller.onCoinChanged(),
            ),
            const SizedBox(height: 16),
            PaymentSummarySection(
              currentCoin: controller.currentCoin,
              originalAmount: controller.args.originalAmount,
              coinUsed: controller.coinUsed,
              finalAmount: controller.finalAmount,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: controller.isCreatingPayment
                    ? null
                    : () => _onPay(context, controller),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff06B6D4),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xff06B6D4).withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: controller.isCreatingPayment
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Thanh toán',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _onPay(BuildContext context, SharedPaymentCheckoutController controller) async {
    FocusScope.of(context).unfocus();
    if (controller.finalAmount <= 0) {
      AppSnackbarUtils.showSuccess('Thành công', 'Thanh toán hoàn tất!');
      Get.back(result: true);
      return;
    }
    final payment = await controller.createPayment();
    if (payment == null) return;
    Get.to(
      () => SharedPaymentQrPage(
        args: controller.args,
        payment: payment,
        coinUsed: controller.coinUsed,
      ),
    );
  }
}

class SharedPaymentQrPage extends StatefulWidget {
  final SharedPaymentFlowArgs args;
  final PaymentUrlEntity payment;
  final int coinUsed;

  const SharedPaymentQrPage({
    super.key,
    required this.args,
    required this.payment,
    required this.coinUsed,
  });

  @override
  State<SharedPaymentQrPage> createState() => _SharedPaymentQrPageState();
}

class _SharedPaymentQrPageState extends State<SharedPaymentQrPage> {
  late final SePayPaymentController _paymentController;
  TransactionStatus? _status;

  int get _finalAmount => (widget.args.originalAmount - widget.coinUsed).clamp(
        0,
        widget.args.originalAmount,
      );

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => SePayPaymentController());
    _paymentController = Get.find<SePayPaymentController>();
    _status = TransactionStatus.pending;
    _startPolling();
  }

  void _startPolling() {
    final transactionId = widget.payment.orderId;
    if (transactionId == null) return;
    _paymentController.startPolling(
      transactionId: transactionId,
      onSuccess: _onPaymentSuccess,
      onFailure: _onPaymentFailed,
    );
  }

  void _onPaymentSuccess(TransactionEntity transaction) {
    setState(() => _status = transaction.status ?? TransactionStatus.success);
    AppSnackbarUtils.showSuccess('Thành công', 'Thanh toán hoàn tất!');
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) Get.back(result: true);
    });
  }

  void _onPaymentFailed(TransactionEntity transaction) {
    setState(() => _status = TransactionStatus.failed);
  }

  @override
  void dispose() {
    _paymentController.stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final qrUrl = widget.payment.qrCodeUrl ?? widget.payment.paymentUrl;
    final itemInfo = widget.args.itemInfo ?? widget.args.parseItemInfo();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét QR thanh toán'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xff273143),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xffF3F4F6),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (itemInfo != null) ...[
            PaymentItemInfoCard(itemInfo: itemInfo),
            const SizedBox(height: 16),
          ],
          _QrPaymentSummaryCard(
            title: widget.args.title,
            finalAmount: _finalAmount,
            transferContent: 'EVENTS-TX-${widget.payment.orderId ?? ''}',
            status: _status,
          ),
          const SizedBox(height: 16),
          if (qrUrl != null && qrUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                qrUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  height: 240,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_2,
                          size: 64,
                          color: Color(0xff9CA3AF),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Không tải được ảnh QR',
                          style: TextStyle(
                            color: Color(0xff67688C),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          else
            Container(
              height: 240,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_2,
                      size: 64,
                      color: Color(0xff9CA3AF),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Không có ảnh QR',
                      style: TextStyle(
                        color: Color(0xff67688C),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 20),
          _PaymentStatusBanner(status: _status),
        ],
      ),
    );
  }
}

class _QrPaymentSummaryCard extends StatelessWidget {
  final String title;
  final int finalAmount;
  final String transferContent;
  final TransactionStatus? status;

  const _QrPaymentSummaryCard({
    required this.title,
    required this.finalAmount,
    required this.transferContent,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE5E7EB)),
      ),
      child: Column(
        children: [
          _QrSummaryRow(label: 'Đơn hàng', value: title),
          const SizedBox(height: 12),
          _QrSummaryRow(
            label: 'Số tiền cần chuyển',
            value: _formatMoney(finalAmount),
            isEmphasis: true,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xffFEF3C7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 18,
                  color: Color(0xffB45309),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nội dung chuyển khoản',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff92400E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        transferContent,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff78350F),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QrSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isEmphasis;

  const _QrSummaryRow({
    required this.label,
    required this.value,
    this.isEmphasis = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xff67688C),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isEmphasis ? 18 : 14,
            fontWeight: isEmphasis ? FontWeight.w700 : FontWeight.w500,
            color: isEmphasis ? const Color(0xff06B6D4) : const Color(0xff273143),
          ),
        ),
      ],
    );
  }
}

class _PaymentStatusBanner extends StatelessWidget {
  final TransactionStatus? status;

  const _PaymentStatusBanner({required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == null) return const SizedBox.shrink();

    final isSuccess = status == TransactionStatus.success;
    final isFailed = status == TransactionStatus.failed;

    String message;
    IconData icon;
    Color bgColor;
    Color textColor;

    if (isSuccess) {
      message = 'Thanh toán thành công!';
      icon = Icons.check_circle;
      bgColor = const Color(0xffD1FAE5);
      textColor = const Color(0xff065F46);
    } else if (isFailed) {
      message = 'Thanh toán thất bại!';
      icon = Icons.error;
      bgColor = const Color(0xffFEE2E2);
      textColor = const Color(0xff991B1B);
    } else {
      message = 'Đang chờ thanh toán...';
      icon = Icons.hourglass_empty;
      bgColor = const Color(0xffFEF3C7);
      textColor = const Color(0xff92400E);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Trạng thái: $message',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
          if (status == TransactionStatus.pending)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff92400E)),
              ),
            ),
        ],
      ),
    );
  }
}

String _formatMoney(int amount) {
  final value = amount.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (match) => ',',
      );
  return '$value VND';
}
