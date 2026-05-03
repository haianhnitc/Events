import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class ActionButtonState {
  final String label;
  final bool isEnabled;

  const ActionButtonState({
    required this.label,
    required this.isEnabled,
  });
}

class EventActionUtils {
  static ActionButtonState getEventRegisterState({
    required EventStatus? status,
    required DateTime? registerOpenTime,
    required DateTime? endTime,
    required int? capacity,
    required int? totalParticipants,
    required UserEventState? userEventState,
    DateTime? now,
  }) {
    final currentTime = now ?? DateTime.now();

    if (userEventState == UserEventState.attendee) {
      return const ActionButtonState(label: 'Đã đăng ký', isEnabled: false);
    }
    if (userEventState == UserEventState.ctv) {
      return const ActionButtonState(label: 'Bạn là CTV', isEnabled: false);
    }
    if (userEventState == UserEventState.ctvApplied) {
      return const ActionButtonState(
        label: 'Đã ứng tuyển CTV',
        isEnabled: false,
      );
    }

    if (status == EventStatus.draft) {
      return const ActionButtonState(
        label: 'Chưa mở đăng ký',
        isEnabled: false,
      );
    }
    if (status == EventStatus.cancelled) {
      return const ActionButtonState(label: 'Đã hủy', isEnabled: false);
    }
    if (status == EventStatus.closed) {
      return const ActionButtonState(label: 'Đã kết thúc', isEnabled: false);
    }
    if (status == EventStatus.locked) {
      return const ActionButtonState(label: 'Đang bị khóa', isEnabled: false);
    }

    if (endTime != null && currentTime.isAfter(endTime)) {
      return const ActionButtonState(label: 'Đã kết thúc', isEnabled: false);
    }

    if (registerOpenTime != null && currentTime.isBefore(registerOpenTime)) {
      return const ActionButtonState(
        label: 'Chưa mở đăng ký',
        isEnabled: false,
      );
    }

    final safeCapacity = capacity ?? 0;
    final safeParticipants = totalParticipants ?? 0;
    if (safeCapacity > 0 && safeParticipants >= safeCapacity) {
      return const ActionButtonState(label: 'Hết chỗ', isEnabled: false);
    }

    return const ActionButtonState(label: 'Đăng ký', isEnabled: true);
  }

  static ActionButtonState getCtvApplyState({
    required bool? isOpen,
    required int? quantity,
    int? recruitedCtvCount,
    required UserEventState? userEventState,
  }) {
    if (userEventState == UserEventState.ctv) {
      return const ActionButtonState(label: 'Đã là CTV', isEnabled: false);
    }
    if (userEventState == UserEventState.ctvApplied) {
      return const ActionButtonState(label: 'Đã ứng tuyển', isEnabled: false);
    }
    if (userEventState == UserEventState.attendee) {
      return const ActionButtonState(
        label: 'Đã đăng ký tham dự',
        isEnabled: false,
      );
    }

    if (isOpen == false) {
      return const ActionButtonState(label: 'Đã đóng tuyển', isEnabled: false);
    }

    final safeQuantity = quantity ?? 0;
    final safeRecruited = recruitedCtvCount ?? 0;
    if (safeQuantity > 0 && safeRecruited >= safeQuantity) {
      return const ActionButtonState(label: 'Hết chỗ', isEnabled: false);
    }

    return const ActionButtonState(label: 'Ứng tuyển', isEnabled: true);
  }
}
