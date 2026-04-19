import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/organizer/participant/domain/usecase/organizer_participant_usecase.dart';
import 'package:events_app/feature/organizer/participant/domain/usecase/organizer_participant_params.dart';

class OrganizerParticipantListController extends GetxController {
  GetOrganizerParticipantsUsecase get _getParticipantsUsecase =>
      networkGetIt<GetOrganizerParticipantsUsecase>();
  DeleteOrganizerParticipantUsecase get _deleteParticipantUsecase =>
      networkGetIt<DeleteOrganizerParticipantUsecase>();

  final RxList<ParticipantEntity> participants = <ParticipantEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxInt currentPage = 0.obs;
  final RxBool hasMore = true.obs;
  final Rx<String?> filterType = Rx<String?>(null);
  final Rx<int?> filterEventId = Rx<int?>(null);

  Future<void> loadParticipants({bool refresh = false}) async {
    if (isLoading.value) return;
    if (refresh) {
      currentPage.value = 0;
      hasMore.value = true;
    }
    if (!hasMore.value && !refresh) return;

    isLoading.value = true;
    final result = await _getParticipantsUsecase(GetOrganizerParticipantsParams(
      eventId: filterEventId.value,
      participantType: filterType.value,
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
          participants.assignAll(data);
        } else {
          participants.addAll(data);
        }
        hasMore.value = data.length >= 20;
        currentPage.value++;
        isLoading.value = false;
      },
    );
  }

  Future<void> refreshParticipants() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;
    await loadParticipants(refresh: true);
    isRefreshing.value = false;
  }

  Future<void> loadMore() async {
    if (!hasMore.value) return;
    await loadParticipants();
  }

  Future<void> deleteParticipant(int participantId) async {
    final result = await _deleteParticipantUsecase(participantId);
    result.fold(
      (failure) => _handleFailure(failure),
      (_) {
        AppSnackbarUtils.showSuccess('Thành công', 'Xóa người tham gia thành công');
        participants.removeWhere((p) => p.eventParticipantId == participantId);
      },
    );
  }

  void setEventFilter(int? eventId) {
    filterEventId.value = eventId;
    loadParticipants(refresh: true);
  }

  void setTypeFilter(String? type) {
    filterType.value = type;
    loadParticipants(refresh: true);
  }

  int get attendeeCount =>
      participants.where((p) => p.participantType?.name == 'attendee').length;

  int get ctvCount =>
      participants.where((p) => p.participantType?.name == 'ctv').length;

  int get checkedInCount =>
      participants.where((p) => p.hasCheckedIn == true).length;

  void _handleFailure(FailureEntity failure) {
    failure.when(
      serverFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message ?? 'Lấy danh sách thất bại'),
      dataParsingFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không đọc được dữ liệu'),
      noConnectionFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không có kết nối mạng'),
      systemFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message ?? 'Lỗi hệ thống'),
    );
  }
}
