import 'package:flutter/material.dart';

class PaymentSummarySection extends StatelessWidget {
  final int currentCoin;
  final int originalAmount;
  final int coinUsed;
  final int finalAmount;
  final String currency;

  const PaymentSummarySection({
    super.key,
    required this.currentCoin,
    required this.originalAmount,
    required this.coinUsed,
    required this.finalAmount,
    this.currency = 'VND',
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin thanh toán',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff273143),
            ),
          ),
          const SizedBox(height: 16),
          _SummaryRow(
            label: 'Số dư coin hiện tại',
            value: _formatMoney(currentCoin),
          ),
          const SizedBox(height: 8),
          _SummaryRow(
            label: 'Tổng tiền ban đầu',
            value: _formatMoney(originalAmount),
          ),
          if (coinUsed > 0) ...[
            const SizedBox(height: 8),
            _SummaryRow(
              label: 'Coin sử dụng',
              value: '- ${_formatMoney(coinUsed)}',
              valueColor: const Color(0xffEF4444),
            ),
          ],
          const Divider(height: 24),
          _SummaryRow(
            label: 'Thực tế cần thanh toán',
            value: _formatMoney(finalAmount),
            isEmphasis: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isEmphasis;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isEmphasis = false,
    this.valueColor,
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
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: isEmphasis ? 18 : 14,
            fontWeight: isEmphasis ? FontWeight.w700 : FontWeight.w500,
            color: valueColor ??
                (isEmphasis ? const Color(0xff06B6D4) : const Color(0xff273143)),
          ),
        ),
      ],
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
