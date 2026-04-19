import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_ticket_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/widget/widgets.dart';
import 'package:events_app/feature/ticket/domain/entity/ticket_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerTicketListPage extends StatefulWidget {
  final int eventId;

  const OrganizerTicketListPage({super.key, required this.eventId});

  @override
  State<OrganizerTicketListPage> createState() => _OrganizerTicketListPageState();
}

class _OrganizerTicketListPageState extends State<OrganizerTicketListPage>
    with SingleTickerProviderStateMixin {
  late OrganizerTicketListController _ctrl;
  late OrganizerEventListController _eventCtrl;
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _eventCtrl = Get.find<OrganizerEventListController>();
    _ctrl = Get.put(OrganizerTicketListController());
    _ctrl.setEventFilter(widget.eventId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
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
        title: const Text('Quản lý vé',
            style: TextStyle(
                color: Color(0xff273143),
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF06B6D4),
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: const Color(0xFF06B6D4),
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          tabs: [
            Obx(() => Tab(text: 'Tất cả (${_ctrl.tickets.length})')),
            Obx(() => Tab(text: 'Đã bán (${_ctrl.issuedCount})')),
            Obx(() => Tab(text: 'Chưa TT (${_ctrl.unpaidCount})')),
            Obx(() => Tab(text: 'Đã dùng (${_ctrl.usedCount})')),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSummaryCards(),
                const SizedBox(height: 12),
                OrganizerSearchField(
                  controller: _searchController,
                  hintText: 'Tìm theo tên, mã vé...',
                  onChanged: (v) => setState(() => _searchQuery = v),
                  onClear: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTicketList(null),
                _buildTicketList(TicketStatus.issued),
                _buildTicketList(TicketStatus.unpaid),
                _buildTicketList(TicketStatus.used),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(child: _buildSummaryCard('${_ctrl.issuedCount}', 'Đã bán', const Color(0xFF10B981))),
        const SizedBox(width: 10),
        Expanded(child: _buildSummaryCard('${_ctrl.unpaidCount}', 'Chưa TT', const Color(0xFFF59E0B))),
        const SizedBox(width: 10),
        Expanded(child: _buildSummaryCard('${_ctrl.usedCount}', 'Đã dùng', const Color(0xFF64748B))),
      ],
    );
  }

  Widget _buildSummaryCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 6)
        ],
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildTicketList(TicketStatus? filterStatus) {
    if (_ctrl.isLoading.value && _ctrl.tickets.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    var filtered = _ctrl.tickets.toList();
    if (filterStatus != null) {
      filtered = filtered.where((t) => t.status == filterStatus).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered.where((t) {
        final name = t.eventTitle?.toLowerCase() ?? '';
        final ticketId = t.ticketId?.toString() ?? '';
        return name.contains(q) || ticketId.contains(q);
      }).toList();
    }

    if (filtered.isEmpty) {
      return OrganizerEmptyState(
        message: 'Chưa có vé nào',
        description: 'Danh sách vé sẽ xuất hiện khi có người đăng ký',
        icon: Icons.confirmation_number_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: _ctrl.refreshTickets,
      color: const Color(0xFF06B6D4),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          return _buildTicketCard(filtered[index]);
        },
      ),
    );
  }

  Widget _buildTicketCard(TicketEntity t) {
    final statusName = t.status?.name ?? '';
    final statusColor = statusName == 'issued'
        ? const Color(0xFF10B981)
        : statusName == 'unpaid'
            ? const Color(0xFFF59E0B)
            : const Color(0xFF64748B);
    final statusLabel = statusName == 'issued'
        ? 'Đã bán'
        : statusName == 'unpaid'
            ? 'Chưa thanh toán'
            : statusName == 'used'
                ? 'Đã dùng'
                : statusName;
    final issuedDate = t.issuedTime != null
        ? AppDateUtils.formatDate(t.issuedTime!)
        : 'N/A';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 6)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showTicketDetail(t),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.confirmation_number_outlined,
                      color: Color(0xFF06B6D4)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.eventTitle ?? 'N/A',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff273143)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Mã vé: #${t.ticketId ?? 'N/A'} • $issuedDate',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(statusLabel,
                            style: TextStyle(
                                fontSize: 10,
                                color: statusColor,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                if (statusName == 'unpaid')
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.payment, size: 20, color: Color(0xFFF59E0B)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTicketDetail(TicketEntity ticket) {
    final price = ticket.event?.price;
    final priceLabel = price == null || price == 0
        ? 'Miễn phí'
        : '${price.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          )}đ';

    final statusName = ticket.status?.name ?? '';
    final statusLabel = switch (statusName) {
      'unpaid' => 'Chưa thanh toán',
      'issued' => 'Đã thanh toán',
      'used' => 'Đã sử dụng',
      'expired' => 'Đã hết hạn',
      _ => statusName,
    };
    final statusColor = switch (statusName) {
      'unpaid' => const Color(0xFFF59E0B),
      'issued' => const Color(0xFF10B981),
      'used' => const Color(0xFF06B6D4),
      'expired' => const Color(0xFF64748B),
      _ => const Color(0xFF64748B),
    };

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.confirmation_number_outlined,
                      color: Color(0xFF06B6D4)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.eventTitle ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff273143),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Mã vé: #${ticket.ticketId ?? 'N/A'}',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _detailRow('Sự kiện', ticket.eventTitle ?? 'N/A'),
            _detailRow('Giá vé', priceLabel),
            _detailRow('Mã vé', '#${ticket.ticketId ?? 'N/A'}'),
            _detailRow(
              'Ngày mua',
              ticket.issuedTime != null
                  ? AppDateUtils.formatDate(ticket.issuedTime!)
                  : 'N/A',
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff273143))),
          ),
        ],
      ),
    );
  }
}
