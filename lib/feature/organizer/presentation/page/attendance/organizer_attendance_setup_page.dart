import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_participant_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/page/attendance/organizer_barcode_scanner_page.dart';
import 'package:events_app/feature/organizer/presentation/page/attendance/organizer_event_qr_fullscreen_page.dart';
import 'package:events_app/feature/organizer/presentation/widget/widgets.dart';
import 'package:events_app/routes/organizer_app_layout_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerAttendanceSetupPage extends StatefulWidget {
  final int eventId;

  const OrganizerAttendanceSetupPage({super.key, required this.eventId});

  @override
  State<OrganizerAttendanceSetupPage> createState() =>
      _OrganizerAttendanceSetupPageState();
}

class _OrganizerAttendanceSetupPageState
    extends State<OrganizerAttendanceSetupPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late OrganizerParticipantListController _participantCtrl;
  String? _eventName;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _participantCtrl = Get.put(OrganizerParticipantListController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _participantCtrl.setEventFilter(widget.eventId);
    });

    final layoutCtrl = Get.find<OrganizerAppLayoutController>();
    layoutCtrl.setEventContext(widget.eventId);

    final eventCtrl = Get.find<OrganizerEventListController>();
    final found =
        eventCtrl.events.firstWhereOrNull((e) => e.eventId == widget.eventId);
    if (found != null) {
      _eventName = found.title;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final evt = eventCtrl.events
            .firstWhereOrNull((e) => e.eventId == widget.eventId);
        if (evt != null && mounted) {
          setState(() => _eventName = evt.title);
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    final layoutCtrl = Get.find<OrganizerAppLayoutController>();
    layoutCtrl.clearEventContext();
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
        title: const Text('Thiết lập điểm danh',
            style: TextStyle(
                color: Color(0xff273143),
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF06B6D4),
            unselectedLabelColor: Colors.grey.shade600,
            indicatorColor: const Color(0xFF06B6D4),
            labelStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: 'Sự kiện miễn phí'),
              Tab(text: 'Sự kiện có vé'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFreeEventTab(),
                _buildPaidEventTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFreeEventTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            icon: Icons.qr_code,
            color: const Color(0xFF06B6D4),
            title: 'Điểm danh tự động',
            description:
                'Tạo mã QR sự kiện — người tham gia tự quét bằng app của họ. Miễn phí và không cần máy quét.',
          ),
          const SizedBox(height: 16),
          _buildEventQRPreview(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => OrganizerEventQrFullscreenPage(
                          eventId: widget.eventId,
                          eventName: _eventName ?? 'Sự kiện',
                          action: 'CHECKIN',
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.login, size: 18, color: Colors.white),
                  label: const Text('QR Check-in',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => OrganizerEventQrFullscreenPage(
                          eventId: widget.eventId,
                          eventName: _eventName ?? 'Sự kiện',
                          action: 'CHECKOUT',
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.logout, size: 18, color: Colors.white),
                  label: const Text('QR Check-out',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaidEventTab() {
    return Obx(() {
      if (_participantCtrl.isLoading.value &&
          _participantCtrl.participants.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      final participants = _participantCtrl.participants
          .where((p) => p.participantType == ParticipantType.attendee)
          .toList();

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(
              icon: Icons.person_search,
              color: const Color(0xFFF59E0B),
              title: 'Quét mã QR từng người',
              description:
                  'Người giữ vé có mã QR riêng. Dùng máy quét để xác minh và điểm danh từng người.',
            ),
            const SizedBox(height: 16),
            const OrganizerSectionHeader(
              title: 'Danh sách người có vé',
              actionLabel: '',
              onActionTap: null,
            ),
            const SizedBox(height: 8),
            if (participants.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Chưa có người mua vé',
                      style: TextStyle(color: Color(0xff94A3B8))),
                ),
              )
            else
              ...participants.map((p) => _buildParticipantQRItem(p)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(() =>
                      OrganizerBarcodeScannerPage(eventId: widget.eventId));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.qr_code_scanner,
                    size: 18, color: Colors.white),
                label: const Text('Mở máy quét QR',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff273143))),
                const SizedBox(height: 4),
                Text(description,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventQRPreview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                Icon(Icons.qr_code_2, size: 100, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 12),
          const Text('Mã QR sự kiện',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff273143))),
          const SizedBox(height: 4),
          Text('Quét để check-in tự động',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildParticipantQRItem(p) {
    final isCtv = p.participantType == ParticipantType.ctv;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), offset: Offset(0, 1), blurRadius: 4)
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFE0F2FE),
            child: Text(
              (p.user?.fullName ?? '?')[0],
              style: const TextStyle(fontSize: 14, color: Color(0xFF06B6D4)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.user?.fullName ?? 'N/A',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff273143)),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  p.participantQrContent ?? 'Chưa có mã',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          if (p.hasCheckedIn == true)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, size: 14, color: Color(0xFF10B981)),
                  SizedBox(width: 4),
                  Text('Đã check-in',
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF10B981),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(Icons.qr_code, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text('Chưa check-in',
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
