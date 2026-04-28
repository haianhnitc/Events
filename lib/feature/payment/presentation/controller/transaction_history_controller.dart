import 'package:get/get.dart';
import 'package:events_app/common/helpers/no_params.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/payment/domain/entity/coin_transaction_entity.dart';
import 'package:events_app/feature/payment/domain/entity/transaction_entity.dart';
import 'package:events_app/feature/payment/domain/usecase/coin_history_usecase.dart';
import 'package:events_app/feature/payment/domain/usecase/sepay_payment_usecase.dart';

class TransactionHistoryController extends GetxController {
  final GetCoinHistoryUsecase _getCoinHistoryUsecase =
      networkGetIt<GetCoinHistoryUsecase>();
  final GetTransactionsUsecase _getTransactionsUsecase =
      networkGetIt<GetTransactionsUsecase>();

  late final RxInt selectedTab;

  final RxList<CoinTransactionEntity> coinTransactions =
      <CoinTransactionEntity>[].obs;
  final RxList<TransactionEntity> moneyTransactions =
      <TransactionEntity>[].obs;

  final RxBool isLoadingCoin = false.obs;
  final RxBool isLoadingMoney = false.obs;

  final RxBool hasMoreCoin = true.obs;
  final RxBool hasMoreMoney = true.obs;
  final RxInt coinPage = 0.obs;
  final RxInt moneyPage = 0.obs;

  int? get coinBalance =>
      coinTransactions.isNotEmpty ? coinTransactions.first.balanceAfter : null;

  int? get moneyBalance {
    final paid = moneyTransactions
        .where((t) => t.status == TransactionStatus.success)
        .fold<int>(0, (sum, t) => sum + (t.finalAmount ?? 0));
    return paid;
  }

  @override
  void onInit() {
    super.onInit();
    selectedTab = 0.obs;
    loadCoinHistory();
    loadMoneyHistory();
  }

  void onTabChanged(int index) {
    selectedTab.value = index;
  }

  Future<void> loadCoinHistory({bool refresh = false}) async {
    if (isLoadingCoin.value) return;
    if (refresh) {
      coinPage.value = 0;
      coinTransactions.clear();
      hasMoreCoin.value = true;
    }
    isLoadingCoin.value = true;

    final result = await _getCoinHistoryUsecase(
      CoinHistoryParams(page: coinPage.value, size: 20),
    );

    isLoadingCoin.value = false;

    result.fold(
      (_) {},
      (data) {
        if (refresh) {
          coinTransactions.assignAll(data.items);
        } else {
          coinTransactions.addAll(data.items);
        }
        hasMoreCoin.value = coinPage.value < data.totalPages - 1;
        coinPage.value++;
      },
    );
  }

  Future<void> loadMoneyHistory({bool refresh = false}) async {
    if (isLoadingMoney.value) return;
    if (refresh) {
      moneyPage.value = 0;
      moneyTransactions.clear();
      hasMoreMoney.value = true;
    }
    isLoadingMoney.value = true;

    final result = await _getTransactionsUsecase(NoParams());

    isLoadingMoney.value = false;

    result.fold(
      (_) {},
      (data) {
        if (refresh) {
          moneyTransactions.assignAll(data);
        } else {
          moneyTransactions.addAll(data);
        }
      },
    );
  }

  Future<void> loadMoreCoin() async {
    if (isLoadingCoin.value || !hasMoreCoin.value) return;
    isLoadingCoin.value = true;

    final result = await _getCoinHistoryUsecase(
      CoinHistoryParams(page: coinPage.value, size: 20),
    );

    isLoadingCoin.value = false;

    result.fold(
      (_) {},
      (data) {
        coinTransactions.addAll(data.items);
        hasMoreCoin.value = coinPage.value < data.totalPages - 1;
        coinPage.value++;
      },
    );
  }
}
