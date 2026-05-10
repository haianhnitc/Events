import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/attendance/domain/entity/event_attendance_log_entity.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_participant_list_controller.dart';
import 'package:events_app/feature/organizer/attendance/domain/usecase/organizer_attendance_usecase.dart';
import 'package:events_app/feature/organizer/attendance/domain/usecase/organizer_attendance_params.dart';

class OrganizerAttendanceListController extends GetxController {
  GetOrganizerAttendanceLogsUsecase get _getAttendanceLogsUsecase =>
      networkGetIt<GetOrganizerAttendanceLogsUsecase>();

  final RxList<EventAttendanceLogEntity> attendanceLogs =
      <EventAttendanceLogEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxInt currentPage = 0.obs;
  final RxBool hasMore = true.obs;
  final Rx<int?> filterEventId = Rx<int?>(null);

  Future<void> loadAttendanceLogs({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 0;
      hasMore.value = true;
      attendanceLogs.clear();
    }
    if (!hasMore.value && !refresh) return;

    isLoading.value = true;
    final result =
        await _getAttendanceLogsUsecase(GetOrganizerAttendanceLogsParams(
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
          attendanceLogs.assignAll(data);
        } else {
          attendanceLogs.addAll(data);
        }
        hasMore.value = data.length >= 20;
        currentPage.value++;
        isLoading.value = false;
      },
    );
  }

  Future<void> refreshLogs() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;
    await loadAttendanceLogs(refresh: true);
    isRefreshing.value = false;
  }

  Future<void> loadMore() async {
    if (!hasMore.value) return;
    await loadAttendanceLogs();
  }

  void setEventFilter(int? eventId) {
    filterEventId.value = eventId;
    loadAttendanceLogs(refresh: true);
  }

  int get totalCheckIns =>
      attendanceLogs.where((l) => l.type == AttendanceLogType.checkIn).length;

  int get totalCheckOuts =>
      attendanceLogs.where((l) => l.type == AttendanceLogType.checkOut).length;

  List<EventAttendanceLogEntity> get allParticipantsAndLogs {
    final participantCtrl = Get.find<OrganizerParticipantListController>();
    final checkedIds = attendanceLogs
        .map((l) => l.eventParticipant?.eventParticipantId)
        .toSet();

    final unlogged = participantCtrl.participants
        .where((p) => !checkedIds.contains(p.eventParticipantId))
        .map((p) => _participantToLog(p))
        .toList();

    return [...unlogged, ...attendanceLogs];
  }

  EventAttendanceLogEntity _participantToLog(ParticipantEntity p) {
    return EventAttendanceLogEntity(
      eventParticipant: p,
      eventAttendanceLogId: null,
      type: AttendanceLogType.checkOut,
      scanMethod: null,
      createdTime: null,
      scannedByUser: null,
    );
  }

  void _handleFailure(FailureEntity failure) {
    AuthController.handleFailure(failure);
  }
}
