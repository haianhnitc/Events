import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/ticket/domain/entity/ticket_entity.dart';
import 'package:events_app/feature/organizer/participant/domain/usecase/organizer_participant_usecase.dart';
import 'package:events_app/feature/organizer/participant/domain/usecase/organizer_participant_params.dart';

class OrganizerTicketListController extends GetxController {
  GetOrganizerTicketsUsecase get _getTicketsUsecase =>
      networkGetIt<GetOrganizerTicketsUsecase>();

  final RxList<TicketEntity> tickets = <TicketEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxInt currentPage = 0.obs;
  final RxBool hasMore = true.obs;
  final Rx<int?> filterEventId = Rx<int?>(null);

  Future<void> loadTickets({bool refresh = false}) async {
    if (isLoading.value) return;
    if (refresh) {
      currentPage.value = 0;
      hasMore.value = true;
    }
    if (!hasMore.value && !refresh) return;

    isLoading.value = true;
    final result = await _getTicketsUsecase(GetOrganizerTicketsParams(
      eventId: filterEventId.value,
      page: currentPage.value,
      size: 20,
    ));
    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
      },
      (data) {
        if (refresh) {
          tickets.assignAll(data);
        } else {
          tickets.addAll(data);
        }
        hasMore.value = data.length >= 20;
        currentPage.value++;
        isLoading.value = false;
      },
    );
  }

  Future<void> refreshTickets() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;
    await loadTickets(refresh: true);
    isRefreshing.value = false;
  }

  Future<void> loadMore() async {
    if (!hasMore.value) return;
    await loadTickets();
  }

  void setEventFilter(int? eventId) {
    filterEventId.value = eventId;
    loadTickets(refresh: true);
  }

  int get unpaidCount => tickets.where((t) => t.isUnpaid).length;
  int get issuedCount => tickets.where((t) => t.isUsable).length;
  int get usedCount => tickets.where((t) => t.isUsed).length;

  void _handleFailure(FailureEntity failure) {
    failure.when(
      serverFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message ?? 'Lấy danh sách vé thất bại'),
      dataParsingFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không đọc được dữ liệu'),
      noConnectionFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không có kết nối mạng'),
      systemFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message ?? 'Lỗi hệ thống'),
    );
  }
}
