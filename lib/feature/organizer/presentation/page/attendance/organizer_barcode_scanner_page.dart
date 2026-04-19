import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_manual_checkin_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_participant_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/page/attendance/organizer_barcode_format_page.dart';
import 'package:events_app/feature/organizer/presentation/page/attendance/organizer_qr_scanner_page.dart';
import 'package:events_app/feature/organizer/presentation/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerBarcodeScannerPage extends StatefulWidget {
  final int? eventId;

  const OrganizerBarcodeScannerPage({super.key, this.eventId});

  @override
  State<OrganizerBarcodeScannerPage> createState() =>
      _OrganizerBarcodeScannerPageState();
}

class _OrganizerBarcodeScannerPageState
    extends State<OrganizerBarcodeScannerPage> {
  final _manualCodeController = TextEditingController();
  bool _flashOn = false;

  late OrganizerEventListController _eventCtrl;
  late OrganizerParticipantListController _participantCtrl;
  late OrganizerManualCheckinController _checkInCtrl;
  EventSummaryEntity? _selectedEvent;

  @override
  void initState() {
    super.initState();
    _eventCtrl = Get.find<OrganizerEventListController>();
    _participantCtrl = Get.put(OrganizerParticipantListController());
    _checkInCtrl = Get.put(OrganizerManualCheckinController());

    if (widget.eventId != null) {
      final event = _eventCtrl.events.firstWhereOrNull(
          (e) => e.eventId == widget.eventId);
      if (event != null) {
        _selectedEvent = event;
        _participantCtrl.setEventFilter(widget.eventId);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final found = _eventCtrl.events.firstWhereOrNull(
              (e) => e.eventId == widget.eventId);
          if (found != null && mounted) {
            setState(() => _selectedEvent = found);
            _participantCtrl.setEventFilter(widget.eventId);
          }
        });
      }
    } else if (_eventCtrl.events.isNotEmpty) {
      _selectedEvent = _eventCtrl.events.first;
      _participantCtrl.setEventFilter(_selectedEvent!.eventId!);
    }
  }

  @override
  void dispose() {
    _manualCodeController.dispose();
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
        title: const Text('Quét mã vạch',
            style: TextStyle(
                color: Color(0xff273143),
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_flashOn ? Icons.flashlight_on : Icons.flashlight_off,
                color: const Color(0xff64748B)),
            tooltip: 'Bật/tắt đèn flash',
            onPressed: () => setState(() => _flashOn = !_flashOn),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: Color(0xff64748B)),
            tooltip: 'Hướng dẫn mã vạch',
            onPressed: () => Get.to(() => const OrganizerBarcodeFormatPage()),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sự kiện',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff475569))),
                const SizedBox(height: 6),
                Obx(() {
                  final events = _eventCtrl.events;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<EventSummaryEntity>(
                        value: _selectedEvent,
                        hint: Text('Chọn sự kiện',
                            style: TextStyle(
                                color: Colors.grey.shade400, fontSize: 14)),
                        isExpanded: true,
                        items: events
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.title ?? 'N/A',
                                      overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                        onChanged: (e) {
                          setState(() => _selectedEvent = e);
                          _participantCtrl.setEventFilter(e?.eventId);
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildScannerView(),
                  const SizedBox(height: 16),
                  _buildManualEntry(),
                  const SizedBox(height: 16),
                  _buildParticipantList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerView() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_alt_outlined,
                    size: 60, color: Colors.white.withOpacity(0.3)),
                const SizedBox(height: 12),
                Text('Camera đang bật',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5), fontSize: 14)),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFF59E0B), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Positioned(top: -1, left: -1, child: _buildCorner(true, true)),
                  Positioned(top: -1, right: -1, child: _buildCorner(true, false)),
                  Positioned(bottom: -1, left: -1, child: _buildCorner(false, true)),
                  Positioned(bottom: -1, right: -1, child: _buildCorner(false, false)),
                ],
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('BARCODE SCANNER',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(bool top, bool left) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border(
          top: top ? const BorderSide(color: Color(0xFFF59E0B), width: 3) : BorderSide.none,
          bottom: !top ? const BorderSide(color: Color(0xFFF59E0B), width: 3) : BorderSide.none,
          left: left ? const BorderSide(color: Color(0xFFF59E0B), width: 3) : BorderSide.none,
          right: !left ? const BorderSide(color: Color(0xFFF59E0B), width: 3) : BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildManualEntry() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.keyboard, size: 18, color: Color(0xFF8B5CF6)),
              SizedBox(width: 8),
              Text('Nhập mã thủ công',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff273143))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OrganizerSearchField(
                  controller: _manualCodeController,
                  hintText: 'Nhập mã vé (VD: #TK-001)',
                  onChanged: (v) => setState(() {}),
                  onClear: () {
                    _manualCodeController.clear();
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(width: 10),
              Obx(() => ElevatedButton(
                    onPressed: _manualCodeController.text.isEmpty || _checkInCtrl.isSubmitting.value
                        ? null
                        : () => _handleManualCheckin(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: _checkInCtrl.isSubmitting.value
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Xác nhận',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  void _handleManualCheckin() async {
    if (_selectedEvent == null) return;

    final code = _manualCodeController.text.trim();
    if (code.isEmpty) return;

    final participant = _participantCtrl.participants.firstWhereOrNull(
      (p) => p.participantQrContent == code || p.participantQrContent?.contains(code) == true,
    );

    if (participant == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không tìm thấy người tham gia với mã này'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (participant.eventParticipantId == null) return;

    await _checkInCtrl.manualCheckIn(participant.eventParticipantId!);
    _manualCodeController.clear();
  }

  Widget _buildParticipantList() {
    return Obx(() {
      if (_participantCtrl.isLoading.value && _participantCtrl.participants.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      final participants = _participantCtrl.participants;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.people_outline, size: 18, color: Color(0xff64748B)),
                const SizedBox(width: 8),
                const Text('Danh sách người tham gia',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff273143))),
                const Spacer(),
                Text('${participants.length} người',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
            const SizedBox(height: 8),
            if (participants.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Chưa có người tham gia nào',
                      style: TextStyle(color: Color(0xff94A3B8))),
                ),
              )
            else
              ...participants.map((p) => _buildParticipantItem(p)),
          ],
        ),
      );
    });
  }

  Widget _buildParticipantItem(ParticipantEntity p) {
    final user = p.user;
    final name = user?.fullName ?? 'N/A';
    final code = p.participantQrContent ?? 'N/A';
    final isCheckedIn = p.hasCheckedIn == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFE0F2FE),
            child: Text(
              name[0],
              style: const TextStyle(fontSize: 14, color: Color(0xFF06B6D4)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff273143))),
                Text(code,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
          if (isCheckedIn)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('Đã check-in',
                  style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.w600)),
            )
          else
            GestureDetector(
              onTap: p.eventParticipantId != null
                  ? () async {
                      await _checkInCtrl.manualCheckIn(p.eventParticipantId!);
                      _participantCtrl.refreshParticipants();
                    }
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: _checkInCtrl.isSubmitting.value
                    ? const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Check-in',
                        style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF8B5CF6),
                            fontWeight: FontWeight.w600)),
              ),
            ),
        ],
      ),
    );
  }
}
