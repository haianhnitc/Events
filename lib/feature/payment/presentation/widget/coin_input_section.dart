import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CoinInputSection extends StatelessWidget {
  final TextEditingController controller;
  final int currentCoin;
  final int originalAmount;
  final String errorText;
  final void Function(String) onChanged;

  const CoinInputSection({
    super.key,
    required this.controller,
    required this.currentCoin,
    required this.originalAmount,
    required this.errorText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText.isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasError ? const Color(0xffEF4444) : const Color(0xffE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.monetization_on_outlined,
                size: 20,
                color: Color(0xffF59E0B),
              ),
              const SizedBox(width: 8),
              const Text(
                'Sử dụng Coin',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff273143),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xffFEF3C7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 14,
                      color: Color(0xffB45309),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Số dư: $currentCoin coin',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffB45309),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: onChanged,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Nhập số coin để giảm số tiền cần thanh toán',
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 12, right: 8),
                child: Icon(Icons.paid_outlined, color: Color(0xffF59E0B)),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
              suffixIcon: currentCoin > 0
                  ? IconButton(
                      onPressed: () {
                        final maxUse = currentCoin < originalAmount
                            ? currentCoin
                            : originalAmount;
                        controller.text = maxUse.toString();
                        controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length),
                        );
                        onChanged(controller.text);
                      },
                      tooltip: 'Dùng tối đa',
                      icon: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffFEF3C7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Tối đa',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffB45309),
                          ),
                        ),
                      ),
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xffF9FAFB),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xff06B6D4),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xffEF4444),
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xffEF4444),
                  width: 1.5,
                ),
              ),
              errorStyle: const TextStyle(
                fontSize: 12,
                color: Color(0xffEF4444),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (hasError) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 14,
                  color: Color(0xffEF4444),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    errorText,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xffEF4444),
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (!hasError && currentCoin > 0) ...[
            const SizedBox(height: 8),
            Text(
              'Bạn có thể sử dụng tối đa ${_formatCoin(currentCoin < originalAmount ? currentCoin : originalAmount)} coin',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

String _formatCoin(int amount) {
  return amount.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (match) => ',',
      );
}
