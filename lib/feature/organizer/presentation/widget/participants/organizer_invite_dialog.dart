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
  final _focusNode = FocusNode();
  ParticipantType _participantType = ParticipantType.attendee;
  String? _emailError;
  bool _isSuccess = false;

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
    _focusNode.dispose();
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

    if (_inviteCtrl.errorMessage.value.isEmpty && mounted) {
      setState(() => _isSuccess = true);
      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) Get.back(result: true);
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
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildEventBanner(),
                  const SizedBox(height: 20),
                  _buildTypeSelector(),
                  const SizedBox(height: 16),
                  _buildEmailField(),
                  const SizedBox(height: 20),
                  _buildActions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          height: 100,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Center(
            child: _isSuccess
                ? const Icon(Icons.check_circle_outline,
                    size: 48, color: Colors.white)
                : const Icon(Icons.person_add_rounded,
                    size: 44, color: Colors.white),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: _isSuccess
              ? const SizedBox.shrink()
              : GestureDetector(
                  onTap: () => Get.back(result: false),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.close, size: 18, color: Colors.white),
                  ),
                ),
        ),
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                _isSuccess ? 'Thành công!' : 'Mời người tham gia',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDFA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF99F6E4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.event_outlined, size: 16, color: Color(0xFF14B8A6)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.eventTitle,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F766E),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelector() {
    final canSelectAttendee =
        widget.recruitmentType == EventRecruitmentType.attendeeOnly ||
            widget.recruitmentType == EventRecruitmentType.both;
    final canSelectCtv =
        widget.recruitmentType == EventRecruitmentType.ctvOnly ||
            widget.recruitmentType == EventRecruitmentType.both;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Loại người tham gia',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Color(0xFF94A3B8),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              _recruitmentTypeLabel,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildTypeCard(
                type: ParticipantType.attendee,
                label: 'Người tham dự',
                icon: Icons.event_available_outlined,
                color: const Color(0xFF06B6D4),
                enabled: canSelectAttendee,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildTypeCard(
                type: ParticipantType.ctv,
                label: 'Cộng tác viên',
                icon: Icons.rocket_launch_outlined,
                color: const Color(0xFF8B5CF6),
                enabled: canSelectCtv,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeCard({
    required ParticipantType type,
    required String label,
    required IconData icon,
    required Color color,
    required bool enabled,
  }) {
    final isSelected = _participantType == type && enabled;
    final isDisabled = !enabled;

    return GestureDetector(
      onTap: enabled ? () => setState(() => _participantType = type) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.08)
              : isDisabled
                  ? const Color(0xFFF8FAFC)
                  : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? color
                : isDisabled
                    ? const Color(0xFFE2E8F0)
                    : const Color(0xFFE2E8F0),
            width: isSelected ? 1.8 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withOpacity(0.15)
                    : isDisabled
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDisabled
                    ? const Color(0xFFCBD5E1)
                    : isSelected
                        ? color
                        : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isDisabled
                    ? const Color(0xFFCBD5E1)
                    : isSelected
                        ? color
                        : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email người được mời',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          focusNode: _focusNode,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _handleInvite(),
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Nhập email người được mời',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            prefixIcon: Icon(Icons.mail_outline_rounded,
                size: 20, color: Colors.grey.shade400),
            errorText: _emailError,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFFEF4444), width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFFEF4444), width: 1.5),
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF06B6D4), width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          onChanged: (_) {
            if (_emailError != null) setState(() {});
          },
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Obx(() {
      if (_isSuccess) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 18, color: Color(0xFF10B981)),
              SizedBox(width: 8),
              Text(
                'Đã thêm người tham gia thành công',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF059669),
                ),
              ),
            ],
          ),
        );
      }

      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Get.back(result: false),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Hủy',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _inviteCtrl.isSubmitting.value ? null : _handleInvite,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06B6D4),
                disabledBackgroundColor: const Color(0xFFBAE6FD),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _inviteCtrl.isSubmitting.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_add_outlined,
                            size: 18, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Mời',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      );
    });
  }
}
