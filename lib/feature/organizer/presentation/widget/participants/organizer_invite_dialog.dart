import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_invite_manual_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool?> showOrganizerInviteDialog({
  required int eventId,
  required EventRecruitmentType recruitmentType,
  required String eventTitle,
}) async {
  return Get.dialog<bool>(
    _OrganizerInviteDialog(
      eventId: eventId,
      recruitmentType: recruitmentType,
      eventTitle: eventTitle,
    ),
    barrierDismissible: false,
  );
}

class _OrganizerInviteDialog extends StatefulWidget {
  final int eventId;
  final EventRecruitmentType recruitmentType;
  final String eventTitle;

  const _OrganizerInviteDialog({
    required this.eventId,
    required this.recruitmentType,
    required this.eventTitle,
  });

  @override
  State<_OrganizerInviteDialog> createState() => _OrganizerInviteDialogState();
}

class _OrganizerInviteDialogState extends State<_OrganizerInviteDialog> {
  late OrganizerInviteManualController _inviteCtrl;
  final _emailController = TextEditingController();
  ParticipantType _participantType = ParticipantType.attendee;
  String? _emailError;

  @override
  void initState() {
    super.initState();
    _inviteCtrl = Get.put(OrganizerInviteManualController());
    _initDefaultType();
  }

  void _initDefaultType() {
    switch (widget.recruitmentType) {
      case EventRecruitmentType.ctvOnly:
        setState(() => _participantType = ParticipantType.ctv);
        break;
      case EventRecruitmentType.attendeeOnly:
        setState(() => _participantType = ParticipantType.attendee);
        break;
      case EventRecruitmentType.both:
        setState(() => _participantType = ParticipantType.attendee);
        break;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool valid = true;
    setState(() {
      _emailError = null;
      if (_emailController.text.trim().isEmpty) {
        _emailError = 'Vui lòng nhập email';
        valid = false;
      } else if (!_isValidEmail(_emailController.text.trim())) {
        _emailError = 'Email không hợp lệ';
        valid = false;
      }
    });
    return valid;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w.\-]+@[\w.\-]+\.\w{2,}').hasMatch(email);
  }

  Future<void> _handleInvite() async {
    if (!_validate()) return;

    await _inviteCtrl.inviteParticipant(
      eventId: widget.eventId,
      email: _emailController.text.trim(),
      participantType: _participantType,
    );

    if (_inviteCtrl.errorMessage.value.isEmpty) {
      Get.back(result: true);
    }
  }

  String get _recruitmentTypeLabel {
    switch (widget.recruitmentType) {
      case EventRecruitmentType.ctvOnly:
        return 'Sự kiện chỉ tuyển CTV';
      case EventRecruitmentType.attendeeOnly:
        return 'Sự kiện chỉ tuyển người tham dự';
      case EventRecruitmentType.both:
        return 'Sự kiện tuyển cả CTV và người tham dự';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        children: [
          const Icon(
            Icons.person_add_alt_1_outlined,
            size: 40,
            color: Color(0xff06B6D4),
          ),
          const SizedBox(height: 8),
          const Text(
            'Mời người tham gia',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xff273143),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.eventTitle,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xff64748B),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTypeSelector(),
            const SizedBox(height: 16),
            _buildEmailField(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text(
            'Hủy',
            style: TextStyle(color: Color(0xff64748B)),
          ),
        ),
        Obx(() => ElevatedButton(
              onPressed: _inviteCtrl.isSubmitting.value ? null : _handleInvite,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06B6D4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _inviteCtrl.isSubmitting.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text(
                      'Mời',
                      style: TextStyle(color: Colors.white),
                    ),
            )),
      ],
    );
  }

  Widget _buildTypeSelector() {
    final canSelectAttendee =
        widget.recruitmentType == EventRecruitmentType.attendeeOnly ||
            widget.recruitmentType == EventRecruitmentType.both;
    final canSelectCtv = widget.recruitmentType == EventRecruitmentType.ctvOnly ||
        widget.recruitmentType == EventRecruitmentType.both;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Loại',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildTypeOption(
              type: ParticipantType.attendee,
              label: 'Người tham dự',
              icon: Icons.event,
              enabled: canSelectAttendee,
            ),
            const SizedBox(width: 8),
            _buildTypeOption(
              type: ParticipantType.ctv,
              label: 'CTV',
              icon: Icons.group,
              enabled: canSelectCtv,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _recruitmentTypeLabel,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xff64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeOption({
    required ParticipantType type,
    required String label,
    required IconData icon,
    required bool enabled,
  }) {
    final isSelected = _participantType == type && enabled;
    final isDisabled = !enabled;

    return Expanded(
      child: GestureDetector(
        onTap: enabled ? () => setState(() => _participantType = type) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF06B6D4).withOpacity(0.1)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF06B6D4)
                  : isDisabled
                      ? Colors.grey.shade200
                      : Colors.grey.shade200,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isDisabled
                    ? Colors.grey.shade300
                    : isSelected
                        ? const Color(0xFF06B6D4)
                        : Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isDisabled
                      ? Colors.grey.shade300
                      : isSelected
                          ? const Color(0xFF06B6D4)
                          : const Color(0xff273143),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email người được mời',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Nhập email',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            prefixIcon:
                Icon(Icons.email_outlined, size: 18, color: Colors.grey.shade400),
            errorText: _emailError,
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          onChanged: (_) {
            if (_emailError != null) setState(() {});
          },
        ),
      ],
    );
  }
}
