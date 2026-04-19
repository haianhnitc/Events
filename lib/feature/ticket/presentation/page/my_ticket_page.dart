import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_image_utils.dart';
import 'package:events_app/feature/ticket/domain/entity/ticket_entity.dart';
import 'package:events_app/feature/ticket/presentation/controller/my_ticket_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTicketPage extends StatefulWidget {
  const MyTicketPage({super.key});

  @override
  State<MyTicketPage> createState() => _MyTicketPageState();
}

class _MyTicketPageState extends State<MyTicketPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MyTicketController _controller = MyTicketController.ensureInstance();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xff06B6D4),
        elevation: 0,
        title: const Text(
          'Vé Của Tôi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Vé sử dụng'),
            Tab(text: 'Đã dùng'),
            Tab(text: 'Chưa thanh toán'),
          ],
        ),
      ),
      body: Obx(() {
        if (_controller.isLoading.value && _controller.tickets.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xff06B6D4),
            ),
          );
        }

        return TabBarView(
          controller: _tabController,
          children: [
            _buildTicketList(_controller.usableTickets, 'usable'),
            _buildTicketList(_controller.usedTickets, 'used'),
            _buildTicketList(_controller.unpaidTickets, 'unpaid'),
          ],
        );
      }),
    );
  }

  Widget _buildTicketList(List<TicketEntity> tickets, String type) {
    if (tickets.isEmpty) {
      return _buildEmptyState(type);
    }

    return RefreshIndicator(
      onRefresh: () => _controller.refreshTickets(),
      color: const Color(0xff06B6D4),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          return _buildTicketCard(tickets[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState(String type) {
    String message;
    IconData icon;

    switch (type) {
      case 'usable':
        icon = Icons.confirmation_number_outlined;
        message = 'Chưa có vé nào có thể sử dụng';
        break;
      case 'used':
        icon = Icons.check_circle_outline;
        message = 'Chưa có vé nào đã sử dụng';
        break;
      case 'unpaid':
        icon = Icons.receipt_long_outlined;
        message = 'Không có vé chưa thanh toán';
        break;
      default:
        icon = Icons.confirmation_number_outlined;
        message = 'Không có vé nào';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xffF0F0F0),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              icon,
              size: 40,
              color: const Color(0xffB0B4C0),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xff67688C),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(TicketEntity ticket) {
    final isUsable = ticket.isUsable;
    final isUsed = ticket.isUsed;
    final isUnpaid = ticket.isUnpaid;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTicketHeader(ticket, isUsable, isUsed, isUnpaid),
          const Divider(height: 1, color: Color(0xffF0F0F0)),
          _buildTicketBody(ticket),
          if (isUsable || isUnpaid)
            _buildTicketActions(ticket, isUsable, isUnpaid),
        ],
      ),
    );
  }

  Widget _buildTicketHeader(
      TicketEntity ticket, bool isUsable, bool isUsed, bool isUnpaid) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (isUsed) {
      statusColor = const Color(0xffB0B4C0);
      statusText = 'Đã sử dụng';
      statusIcon = Icons.check_circle;
    } else if (isUnpaid) {
      statusColor = const Color(0xffF59E0B);
      statusText = 'Chưa thanh toán';
      statusIcon = Icons.payment;
    } else {
      statusColor = const Color(0xff00A63E);
      statusText = 'Có thể sử dụng';
      statusIcon = Icons.verified;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 56,
              height: 56,
              child: AppImageUtils.buildNetworkImage(
                imageUrl: ticket.eventBanner,
                placeholder: AppImageUtils.buildImagePlaceholder(
                  icon: Icons.event,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket.eventTitle ?? 'Sự kiện',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff273143),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (ticket.issuedTime != null)
                  Text(
                    'Mua ngày: ${AppDateUtils.formatDateOnly(ticket.issuedTime)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff67688C),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  statusIcon,
                  size: 14,
                  color: statusColor,
                ),
                const SizedBox(width: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketBody(TicketEntity ticket) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildTicketInfo(
              Icons.confirmation_number,
              'Mã vé',
              '#${ticket.ticketId ?? '---'}',
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: const Color(0xffF0F0F0),
          ),
          Expanded(
            child: _buildTicketInfo(
              Icons.event,
              'Sự kiện',
              ticket.event?.title ?? '---',
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: const Color(0xffF0F0F0),
          ),
          Expanded(
            child: _buildTicketInfo(
              Icons.payments,
              'Giá vé',
              ticket.event?.price != null
                  ? '${_formatPrice(ticket.event!.price!)}đ'
                  : 'Miễn phí',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketInfo(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color(0xff06B6D4),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xffB0B4C0),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xff273143),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTicketActions(
      TicketEntity ticket, bool isUsable, bool isUnpaid) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          if (isUnpaid) ...[
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _controller.payTicket(ticket.ticketId!),
                icon: const Icon(Icons.payment, size: 18),
                label: const Text('Thanh toán'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff06B6D4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

String _formatPrice(int price) {
  final str = price.toString();
  final result = StringBuffer();
  for (var i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) {
      result.write('.');
    }
    result.write(str[i]);
  }
  return result.toString();
}
