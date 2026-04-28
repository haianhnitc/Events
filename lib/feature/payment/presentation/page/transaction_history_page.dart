import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/payment/presentation/controller/transaction_history_controller.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(TransactionHistoryController());

    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (ctx) {
          final tabCtrl = DefaultTabController.of(ctx);
          tabCtrl.addListener(() {
            if (!tabCtrl.indexIsChanging) {
              ctrl.onTabChanged(tabCtrl.index);
            }
          });
          return Scaffold(
            backgroundColor: const Color(0xFFF4F6F8),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  _buildSliverHeader(ctrl),
                  SliverAppBar(
                    pinned: true,
                    toolbarHeight: 0,
                    automaticallyImplyLeading: false,
                    flexibleSpace: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF0E7490), Color(0xFF155DFC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(70),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TabBar(
                          indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          labelColor: const Color(0xFF0E7490),
                          unselectedLabelColor: Colors.white,
                          labelStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          tabs: const [
                            Tab(
                              child: SizedBox(
                                height: 40,
                                child: Center(
                                    child: Text(
                                  'Coin',
                                  style: TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                            Tab(
                              child: SizedBox(
                                height: 40,
                                child: Center(
                                    child: Text(
                                  'Tiền mặt',
                                  style: TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _CoinTab(ctrl: ctrl),
                  _MoneyTab(ctrl: ctrl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliverHeader(TransactionHistoryController ctrl) {
    final currencyFormat = NumberFormat('#,###');

    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0E7490), Color(0xFF155DFC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Lịch sử giao dịch',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Obx(() => Row(
                      children: [
                        Expanded(
                          child: _BalanceCard(
                            icon: Icons.monetization_on_outlined,
                            label: 'Số dư Coin',
                            value: ctrl.coinBalance != null
                                ? '${ctrl.coinBalance}'
                                : '---',
                            unit: 'coin',
                            color: const Color(0xFFFFD700),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _BalanceCard(
                            icon: Icons.account_balance_wallet_outlined,
                            label: 'Ví tiền',
                            value: ctrl.moneyBalance != null
                                ? currencyFormat.format(ctrl.moneyBalance)
                                : '---',
                            unit: 'VND',
                            color: const Color(0xFF6EE7B7),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            unit,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinTab extends StatelessWidget {
  const _CoinTab({required this.ctrl});

  final TransactionHistoryController ctrl;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.isLoadingCoin.value && ctrl.coinTransactions.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF06B6D4)),
        );
      }
      if (ctrl.coinTransactions.isEmpty) {
        return const _EmptyState(
          icon: Icons.monetization_on_outlined,
          message: 'Chưa có giao dịch coin nào',
        );
      }
      return RefreshIndicator(
        onRefresh: () => ctrl.loadCoinHistory(refresh: true),
        color: const Color(0xFF06B6D4),
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount:
              ctrl.coinTransactions.length + (ctrl.hasMoreCoin.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == ctrl.coinTransactions.length) {
              ctrl.loadMoreCoin();
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(color: Color(0xFF06B6D4)),
                ),
              );
            }
            return _CoinTransactionItem(ctrl.coinTransactions[index]);
          },
        ),
      );
    });
  }
}

class _MoneyTab extends StatelessWidget {
  const _MoneyTab({required this.ctrl});

  final TransactionHistoryController ctrl;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,###');

    return Obx(() {
      if (ctrl.isLoadingMoney.value && ctrl.moneyTransactions.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF06B6D4)),
        );
      }
      if (ctrl.moneyTransactions.isEmpty) {
        return const _EmptyState(
          icon: Icons.receipt_long_outlined,
          message: 'Chưa có giao dịch nào',
        );
      }
      return RefreshIndicator(
        onRefresh: () => ctrl.loadMoneyHistory(refresh: true),
        color: const Color(0xFF06B6D4),
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: ctrl.moneyTransactions.length,
          itemBuilder: (context, index) {
            return _MoneyTransactionItem(
              ctrl.moneyTransactions[index],
              currencyFormat,
            );
          },
        ),
      );
    });
  }
}

class _CoinTransactionItem extends StatelessWidget {
  const _CoinTransactionItem(this.tx);

  final dynamic tx;

  @override
  Widget build(BuildContext context) {
    final isPositive = tx.isPositive;
    final color =
        isPositive ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
    final icon = _coinIcon(tx.referenceType);
    final label = _coinLabel(tx.referenceType);
    final prefix = isPositive ? '+' : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1D1F),
          ),
        ),
        subtitle: Text(
          tx.createdTime != null
              ? AppDateUtils.formatDateTime(tx.createdTime)
              : '',
          style: const TextStyle(fontSize: 11.5, color: Color(0xFFB0B4C0)),
        ),
        trailing: Text(
          '$prefix${tx.amount ?? 0}',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }

  IconData _coinIcon(CoinReferenceType? type) {
    switch (type) {
      case CoinReferenceType.eventAttend:
        return Icons.event_available;
      case CoinReferenceType.buyTicket:
        return Icons.confirmation_number;
      case CoinReferenceType.buyPackage:
        return Icons.workspace_premium;
      case CoinReferenceType.portfolio:
        return Icons.folder_special;
      case CoinReferenceType.refund:
        return Icons.replay;
      case CoinReferenceType.penalty:
        return Icons.remove_circle;
      case CoinReferenceType.adminAdjust:
        return Icons.admin_panel_settings;
      case CoinReferenceType.newsRead:
        return Icons.article;
      case CoinReferenceType.feedback:
        return Icons.rate_review;
      case null:
        return Icons.swap_horiz;
    }
  }

  String _coinLabel(CoinReferenceType? type) {
    switch (type) {
      case CoinReferenceType.eventAttend:
        return 'Tham gia sự kiện';
      case CoinReferenceType.buyTicket:
        return 'Mua vé';
      case CoinReferenceType.buyPackage:
        return 'Mua gói';
      case CoinReferenceType.portfolio:
        return 'Portfolio';
      case CoinReferenceType.refund:
        return 'Hoàn coin';
      case CoinReferenceType.penalty:
        return 'Phạt';
      case CoinReferenceType.adminAdjust:
        return 'Điều chỉnh';
      case CoinReferenceType.newsRead:
        return 'Đọc tin';
      case CoinReferenceType.feedback:
        return 'Đánh giá';
      case null:
        return 'Giao dịch';
    }
  }
}

class _MoneyTransactionItem extends StatelessWidget {
  const _MoneyTransactionItem(this.tx, this.fmt);

  final dynamic tx;
  final NumberFormat fmt;

  String _providerName(PaymentProvider? provider) {
    if (provider == null) return '';
    if (provider == PaymentProvider.momo) return 'Momo';
    if (provider == PaymentProvider.vnpay) return 'VNPay';
    if (provider == PaymentProvider.stripe) return 'Stripe';
    if (provider == PaymentProvider.sepay) return 'SePay';
    return '';
  }

  IconData _moneyIcon(TransactionReferenceType? type) {
    switch (type) {
      case TransactionReferenceType.ticket:
        return Icons.confirmation_number;
      case TransactionReferenceType.packagePurchase:
      case TransactionReferenceType.packageRenewal:
        return Icons.workspace_premium;
      case TransactionReferenceType.portfolio:
        return Icons.folder_special;
      case null:
        return Icons.payment;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = tx.status;
    final isSuccess = status == TransactionStatus.success;
    final isPending = status == TransactionStatus.pending;
    final statusColor = isSuccess
        ? const Color(0xFF22C55E)
        : isPending
            ? const Color(0xFFF59E0B)
            : const Color(0xFFEF4444);
    final statusLabel = isSuccess
        ? 'Đã thanh toán'
        : isPending
            ? 'Đang chờ'
            : 'Thất bại';

    final icon = _moneyIcon(tx.referenceType);
    final title = tx.referenceTitle ?? 'Thanh toán';
    final provider = _providerName(tx.paymentProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF06B6D4)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1D1F),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (provider.isNotEmpty) ...[
              const SizedBox(height: 1),
              Text(
                provider,
                style:
                    const TextStyle(fontSize: 11.5, color: Color(0xFFB0B4C0)),
              ),
            ],
            const SizedBox(height: 2),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
                if (tx.coinUsed != null && tx.coinUsed != 0) ...[
                  const SizedBox(width: 6),
                  Text(
                    '-${tx.coinUsed ?? 0} coin',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFB0B4C0),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (tx.finalAmount != null)
              Text(
                fmt.format(tx.finalAmount),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1D1F),
                ),
              ),
            const SizedBox(height: 2),
            Text(
              'VND',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(36),
            ),
            child: Icon(icon, size: 34, color: const Color(0xFFB0B4C0)),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF67688C),
            ),
          ),
        ],
      ),
    );
  }
}
