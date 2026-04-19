import 'dart:async';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/news/data/model/news_claim_response_model.dart';
import 'package:events_app/feature/news/domain/entity/news_entity.dart';
import 'package:events_app/feature/news/domain/usecase/news_usecase.dart';
import 'package:get/get.dart';

class NewsDetailController extends GetxController {
  final ClaimNewsUsecase? _claimNewsUsecase;
  final NewsEntity news;

  NewsDetailController({
    ClaimNewsUsecase? claimNewsUsecase,
    required this.news,
  }) : _claimNewsUsecase = claimNewsUsecase;

  static const int _claimIntervalSeconds = 60;
  static const int _idlePauseSeconds = 10;

  final RxDouble progress = 0.0.obs;
  final RxInt secondsRemaining = _claimIntervalSeconds.obs;
  final RxInt sessionCoins = 0.obs;
  final RxBool hasStartedReading = false.obs;
  final RxInt cooldownSeconds = 0.obs;
  final RxBool isExhausted = false.obs;
  final RxBool isIdle = false.obs;
  final RxBool isClaiming = false.obs;

  Timer? _tickTimer;
  Timer? _idleTimer;
  int _elapsedSeconds = 0;

  bool get canEarnCoin {
    if (isExhausted.value) return false;
    if ((news.rewardPerMinute ?? 0) <= 0) return false;
    return true;
  }

  bool get isLoggedIn {
    try {
      final auth = Get.find<AuthController>();
      return auth.currentUser.value != null;
    } catch (_) {
      return false;
    }
  }

  void startReading() {
    if (hasStartedReading.value) return;
    hasStartedReading.value = true;
    _startTimer();
    onUserActivity();
  }

  void _startTimer() {
    _tickTimer?.cancel();
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isIdle.value || isClaiming.value || isExhausted.value) return;
      _elapsedSeconds++;
      progress.value = _elapsedSeconds / _claimIntervalSeconds;
      secondsRemaining.value = _claimIntervalSeconds - _elapsedSeconds;

      if (_elapsedSeconds >= _claimIntervalSeconds) {
        _triggerClaim();
      }
    });
  }

  void _stopTimer() {
    _tickTimer?.cancel();
    _tickTimer = null;
  }

  void onUserActivity() {
    if (isExhausted.value) return;

    isIdle.value = false;
    _idleTimer?.cancel();

    if (canEarnCoin && hasStartedReading.value && !isClaiming.value) {
      _startTimer();
    }

    _idleTimer = Timer(const Duration(seconds: _idlePauseSeconds), () {
      if (!isExhausted.value && hasStartedReading.value) {
        isIdle.value = true;
        _stopTimer();
      }
    });
  }

  Future<void> _triggerClaim() async {
    if (!canEarnCoin) {
      _resetProgress();
      return;
    }
    await _performClaim();
  }

  Future<void> claimManually() async {
    if (!hasStartedReading.value) {
      startReading();
      return;
    }
    if (_elapsedSeconds < _claimIntervalSeconds) {
      AppSnackbarUtils.showInfo('Thông báo', 'Vui lòng đọc thêm ${_claimIntervalSeconds - _elapsedSeconds} giây để nhận coin');
      return;
    }
    await _performClaim();
  }

  Future<void> _performClaim() async {
    if (news.newsId == null) {
      _resetProgress();
      return;
    }
    if (!isLoggedIn) {
      AppSnackbarUtils.showInfo('Thông báo', 'Vui lòng đăng nhập để nhận coin');
      _resetProgress();
      return;
    }
    if (_claimNewsUsecase == null) {
      _resetProgress();
      return;
    }

    isClaiming.value = true;
    _stopTimer();
    _idleTimer?.cancel();

    final result = await _claimNewsUsecase.call(news.newsId ?? 0);

    result.fold(
      (failure) => _handleClaimFailure(failure),
      (response) => _handleClaimSuccess(response),
    );

    isClaiming.value = false;
  }

  void _handleClaimSuccess(NewsClaimResponseModel response) {
    if (response.exhausted == true || (response.coinsEarned ?? 0) <= 0) {
      isExhausted.value = true;
      _stopTimer();
      AppSnackbarUtils.showInfo('Thông báo', 'Quỹ thưởng đã hết');
      return;
    }

    final earned = response.coinsEarned ?? 0;
    sessionCoins.value += earned;
    AppSnackbarUtils.showSuccess('Nhận coin', '+$earned E-Coin');

    final remaining = response.remainingRewardCoin ?? 0;
    if (remaining <= 0) {
      isExhausted.value = true;
      _stopTimer();
    } else {
      _resetProgress();
    }
  }

  void _handleClaimFailure(FailureEntity failure) {
    failure.when(
      serverFailure: (code, message) {
        if (message.toLowerCase().contains('giay') || message.toLowerCase().contains('giây')) {
          final match = RegExp(r'(\d+)').firstMatch(message);
          if (match != null) {
            final seconds = int.tryParse(match.group(1) ?? '0') ?? 0;
            cooldownSeconds.value = seconds;
            _stopTimer();
            _startCooldownTimer(seconds);
            AppSnackbarUtils.showInfo('Thông báo', 'Vui lòng chờ $seconds giây trước khi nhận tiếp');
          } else {
            AppSnackbarUtils.showError('Lỗi', message);
            _resetProgress();
          }
        } else {
          AppSnackbarUtils.showError('Lỗi', message);
          _resetProgress();
        }
      },
      dataParsingFailure: () {
        AppSnackbarUtils.showError('Lỗi', 'Không đọc được dữ liệu');
        _resetProgress();
      },
      noConnectionFailure: () {
        AppSnackbarUtils.showError('Lỗi', 'Không có kết nối mạng');
        _resetProgress();
      },
      systemFailure: (_, message) {
        AppSnackbarUtils.showError('Lỗi', message);
        _resetProgress();
      },
    );
  }

  void _startCooldownTimer(int seconds) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (cooldownSeconds.value <= 1) {
        cooldownSeconds.value = 0;
        timer.cancel();
        if (!isExhausted.value && canEarnCoin) {
          _resetProgress();
        }
      } else {
        cooldownSeconds.value--;
      }
    });
  }

  void _resetProgress() {
    _elapsedSeconds = 0;
    progress.value = 0.0;
    secondsRemaining.value = _claimIntervalSeconds;
    isIdle.value = false;
    if (canEarnCoin && hasStartedReading.value) {
      _startTimer();
    }
  }

  @override
  void onClose() {
    _stopTimer();
    _idleTimer?.cancel();
    super.onClose();
  }
}
