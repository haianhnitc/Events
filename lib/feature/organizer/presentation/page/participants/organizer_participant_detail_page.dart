import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_manual_checkin_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_participant_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

String _participantTypeName(ParticipantType? type) {
  if (type == null) return 'ATTENDEE';
  switch (type) {
    case ParticipantType.attendee:
      return 'ATTENDEE';
    case ParticipantType.ctv:
      return 'CTV';
  }
}

class OrganizerParticipantDetailPage extends StatefulWidget {
  final int participantId;

  const OrganizerParticipantDetailPage(
      {super.key, required this.participantId});

  @override
  State<OrganizerParticipantDetailPage> createState() =>
      _OrganizerParticipantDetailPageState();
}

class _OrganizerParticipantDetailPageState
    extends State<OrganizerParticipantDetailPage> {
  late OrganizerParticipantDetailController _detailCtrl;
  late OrganizerManualCheckinController _checkInCtrl;

  @override
  void initState() {
    super.initState();
    _detailCtrl = Get.put(OrganizerParticipantDetailController());
    _checkInCtrl = Get.put(OrganizerManualCheckinController());
    _detailCtrl.loadParticipant(widget.participantId);
  }

  @override
  void dispose() {
    Get.delete<OrganizerParticipantDetailController>();
    Get.delete<OrganizerManualCheckinController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff64748B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Chi tiết người tham gia',
            style: TextStyle(
                color: Color(0xff273143),
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xff64748B)),
            onPressed: () => _detailCtrl.loadParticipant(widget.participantId),
          ),
        ],
      ),
      body: Obx(() {
        if (_detailCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final p = _detailCtrl.participant.value;
        if (p == null) {
          return const Center(
            child: Text('Không tìm thấy người tham gia',
                style: TextStyle(color: Color(0xff94A3B8))),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(p),
              const SizedBox(height: 16),
              _buildAttendanceCard(p),
              const SizedBox(height: 16),
              _buildFeedbackSection(),
              const SizedBox(height: 16),
              _buildActionButtons(p),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileCard(p) {
    final user = p.user;
    final name = user?.fullName ?? 'N/A';
    final email = user?.email ?? 'N/A';
    final avatar = user?.avatarUrl;
    final typeName = _participantTypeName(p.participantType);
    final statusName = p.status?.apiValue ?? 'REGISTERED';
    final isCheckedIn = p.hasCheckedIn == true;
    final registeredTime = p.registeredTime != null
        ? AppDateUtils.formatDate(p.registeredTime!)
        : 'N/A';

    String typeLabel =
        typeName == 'ctv' ? 'Cộng tác viên' : 'Người tham dự';
    Color typeColor = const Color(0xFF06B6D4);
    if (typeName == 'ctv') typeColor = const Color(0xFF8B5CF6);

    String statusLabel;
    Color statusColor;
    switch (statusName) {
      case 'ATTENDED':
        statusLabel = 'Đã tham dự';
        statusColor = const Color(0xFF10B981);
        break;
      case 'NOSHOW':
        statusLabel = 'Vắng mặt';
        statusColor = const Color(0xFFEF4444);
        break;
      default:
        statusLabel = 'Đã đăng ký';
        statusColor = const Color(0xff64748B);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: const Color(0xFFE0F2FE),
            backgroundImage: avatar != null ? NetworkImage(avatar) : null,
            child: avatar == null
                ? Text(name[0],
                    style: const TextStyle(
                        fontSize: 24,
                        color: Color(0xFF06B6D4),
                        fontWeight: FontWeight.w700))
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff273143))),
                const SizedBox(height: 4),
                Text(email,
                    style:
                        TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Text('Đăng ký: $registeredTime',
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                if (user?.joinedAt != null)
                  Text(
                      'Tham gia: ${AppDateUtils.formatDate(user!.joinedAt!)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _buildChip(typeLabel, typeColor),
                    _buildChip(statusLabel, statusColor),
                    if (isCheckedIn)
                      _buildChip('Đã check-in', const Color(0xFF10B981)),
                    if (user?.status == UserStatus.disabled)
                      _buildChip('Tài khoản bị vô hiệu', const Color(0xFFEF4444)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildAttendanceCard(p) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.history, size: 18, color: Color(0xFF8B5CF6)),
              SizedBox(width: 8),
              Text('Thông tin điểm danh',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff273143))),
            ],
          ),
          const SizedBox(height: 12),
          _infoRow('Mã QR', p.participantQrContent ?? 'N/A'),
          _infoRow(
              'Check-in',
              p.checkInTime != null
                  ? AppDateUtils.formatDate(p.checkInTime!)
                  : 'Chưa check-in'),
          _infoRow(
              'Check-out',
              p.checkOutTime != null
                  ? AppDateUtils.formatDate(p.checkOutTime!)
                  : 'Chưa check-out'),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff273143))),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.feedback_outlined,
                  size: 18, color: Color(0xFFF59E0B)),
              const SizedBox(width: 8),
              const Text('Phản hồi đã gửi',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff273143))),
              const Spacer(),
              if (_detailCtrl.isLoadingFeedbacks.value)
                const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2)),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (_detailCtrl.isLoadingFeedbacks.value &&
                _detailCtrl.feedbacks.isEmpty) {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.all(12),
                child: Text('Đang tải...',
                    style: TextStyle(color: Color(0xff94A3B8), fontSize: 13)),
              ));
            }
            final fbs = _detailCtrl.feedbacks;
            if (fbs.isEmpty) {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.all(12),
                child: Text('Chưa có phản hồi',
                    style: TextStyle(color: Color(0xff94A3B8), fontSize: 13)),
              ));
            }
            return Column(
              children: fbs.map((fb) {
                final answers = fb.feedbackAnswers ?? [];
                final comment = fb.comment;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (fb.createdTime != null)
                      Text('Gửi: ${AppDateUtils.formatDate(fb.createdTime!)}',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade500)),
                    const SizedBox(height: 8),
                    ...answers.map((a) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: _buildFeedbackAnswer(a),
                      );
                    }),
                    if (comment != null && comment.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.format_quote,
                                size: 14, color: Colors.grey.shade400),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text('"$comment"',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                      fontStyle: FontStyle.italic)),
                            ),
                          ],
                        ),
                      ),
                    const Divider(height: 16),
                  ],
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFeedbackAnswer(a) {
    final typeName = a.questionType?.name ?? 'text';
    String displayValue = a.answerValue ?? '';

    if (typeName == 'rating') {
      final rating = int.tryParse(displayValue) ?? 0;
      return Row(
        children: [
          Expanded(
            child: Text(a.questionText ?? 'N/A',
                style: const TextStyle(fontSize: 13, color: Color(0xff475569))),
          ),
          Row(
            children: List.generate(5, (i) {
              return Icon(
                i < rating ? Icons.star : Icons.star_border,
                size: 14,
                color: const Color(0xFFF59E0B),
              );
            }),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(a.questionText ?? 'N/A',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff273143))),
              const SizedBox(height: 2),
              Text(
                  displayValue.isEmpty
                      ? '(Không có câu trả lời)'
                      : displayValue,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(p) {
    final isCheckedIn = p.hasCheckedIn == true;
    final isCheckOut = p.isCheckOut == true;
    final epId = p.eventParticipantId;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: epId != null && !isCheckedIn
                ? () => _handleCheckIn(epId)
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: (epId != null && !isCheckedIn)
                    ? const Color(0xFF10B981).withOpacity(0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Obx(() => _checkInCtrl.isSubmitting.value
                  ? const Center(
                      child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2)))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            isCheckedIn
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            size: 18,
                            color: (epId != null && !isCheckedIn)
                                ? const Color(0xFF10B981)
                                : Colors.grey),
                        const SizedBox(width: 6),
                        Text(isCheckedIn ? 'Đã check-in' : 'Check-in thủ công',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: (epId != null && !isCheckedIn)
                                    ? const Color(0xFF10B981)
                                    : Colors.grey)),
                      ],
                    )),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: epId != null && isCheckedIn && !isCheckOut
                ? () => _handleCheckOut(epId)
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: (epId != null && isCheckedIn && !isCheckOut)
                    ? Colors.grey.shade100
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout,
                      size: 18,
                      color: (epId != null && isCheckedIn && !isCheckOut)
                          ? const Color(0xff64748B)
                          : Colors.grey.shade400),
                  const SizedBox(width: 6),
                  Text(isCheckOut ? 'Đã check-out' : 'Check-out thủ công',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: (epId != null && isCheckedIn && !isCheckOut)
                              ? const Color(0xff64748B)
                              : Colors.grey.shade400)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleCheckIn(int epId) async {
    final success = await _checkInCtrl.manualCheckIn(epId);
    if (success) {
      _detailCtrl.loadParticipant(widget.participantId);
    }
  }

  void _handleCheckOut(int epId) async {
    final success = await _checkInCtrl.manualCheckOut(epId);
    if (success) {
      _detailCtrl.loadParticipant(widget.participantId);
    }
  }
}
