import 'dart:convert';

import 'package:events_app/feature/attendance/presentation/controller/my_qr_controller.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_image_utils.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';
import 'package:events_app/feature/payment/presentation/page/shared_payment_flow_args.dart';
import 'package:events_app/feature/payment/presentation/page/shared_payment_flow_page.dart';
import 'package:events_app/feature/registration/presentation/controller/registration_controller.dart';
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
  final MyTicketController _ticketController =
      MyTicketController.ensureInstance();
  final RegistrationController _regController =
      RegistrationController.ensureInstance();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _ticketController.loadTickets(refresh: true);
    _regController.loadMyRegistrations(refresh: true);
    MyQrController.ensureInstance().loadParticipants();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  EventEntity _ticketToEventEntity(TicketEntity ticket) {
    return EventEntity(
      eventId: ticket.event?.eventId,
      title: ticket.event?.title,
      banner: ticket.event?.banner,
      startTime: ticket.event?.startTime,
      endTime: ticket.event?.endTime,
      price: ticket.event?.price,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xff06B6D4),
        elevation: 0,
        title: const Text(
          'Vé & QR Của Tôi',
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
        if (_ticketController.isLoading.value &&
            _ticketController.tickets.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xff06B6D4),
            ),
          );
        }

        return TabBarView(
          controller: _tabController,
          children: [
            _buildTicketList(_ticketController.usableTickets, 'usable'),
            _buildTicketList(_ticketController.usedTickets, 'used'),
            _buildTicketList(_ticketController.unpaidTickets, 'unpaid'),
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
      onRefresh: () => _ticketController.refreshTickets(),
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
              Icons.payments,
              'Giá vé',
              ticket.event?.price != null
                  ? '${_formatPrice(ticket.event!.price!)}đ'
                  : 'Miễn phí',
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: const Color(0xffF0F0F0),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _showQrBottomSheet(ticket),
              child: Column(
                children: [
                  const Icon(
                    Icons.qr_code_2,
                    size: 18,
                    color: Color(0xff06B6D4),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'QR',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xffB0B4C0),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xff06B6D4).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Lấy QR',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff06B6D4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQrBottomSheet(TicketEntity ticket) {
    final qrController = MyQrController.ensureInstance();
    final participant = _regController.registrations.firstWhereOrNull(
      (p) => p.event?.eventId == ticket.eventId,
    );

    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    if (participant != null && participant.eventParticipantId != null) {
      qrController.loadQrFor(participant);
    }

    Get.bottomSheet(
      Container(
        width: screenW,
        height: screenH * 0.85,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xffE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              ticket.eventTitle ?? 'QR Check-in',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff273143),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (participant == null) ...[
              const Icon(Icons.info_outline,
                  size: 48, color: Color(0xffB0B4C0)),
              const SizedBox(height: 12),
              const Text(
                'Không tìm thấy thông tin đăng ký',
                style: TextStyle(color: Color(0xff67688C)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await qrController.loadParticipants();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff06B6D4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Tải lại'),
              ),
            ] else if (participant.eventParticipantId == null) ...[
              const Icon(Icons.info_outline,
                  size: 48, color: Color(0xffB0B4C0)),
              const SizedBox(height: 12),
              const Text(
                'Không có mã tham gia',
                style: TextStyle(color: Color(0xff67688C)),
              ),
            ] else ...[
              _buildQrContent(
                epId: participant.eventParticipantId,
                qrController: qrController,
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildQrContent({
    required int? epId,
    required MyQrController qrController,
  }) {
    final currentQr = qrController.getQrFor(epId ?? 0);
    final qrContent = currentQr?.qrContent;

    if (qrContent == null || qrContent.isEmpty) {
      return Column(
        children: [
          const Icon(Icons.qr_code_2, size: 48, color: Color(0xffB0B4C0)),
          const SizedBox(height: 12),
          const Text(
            'Chưa có mã QR',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff273143),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'QR sẽ có khi sự kiện bắt đầu',
            style: TextStyle(fontSize: 12, color: Color(0xff67688C)),
          ),
          const SizedBox(height: 16),
          Obx(() => ElevatedButton.icon(
                onPressed: qrController.isLoading.value
                    ? null
                    : () async {
                        await qrController.loadParticipants();
                      },
                icon: qrController.isLoading.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.refresh, size: 18),
                label: Text(
                  qrController.isLoading.value ? 'Đang tải...' : 'Lấy QR',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff06B6D4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )),
        ],
      );
    }

    return Column(
      children: [
        Obx(() {
          final qr = qrController.getQrFor(epId ?? 0);
          final remaining = qr?.expiryTime?.difference(DateTime.now());
          if (remaining == null || remaining.isNegative) {
            return const Text(
              'QR đã hết hạn',
              style: TextStyle(color: Color(0xffEF4444)),
            );
          }
          final mins = remaining.inMinutes;
          final secs = remaining.inSeconds % 60;
          return Text(
            'Hết hạn sau ${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xffF59E0B),
              fontWeight: FontWeight.w500,
            ),
          );
        }),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _buildQrImage(qrContent),
        ),
        const SizedBox(height: 12),
        const Text(
          'Quét mã QR để check-in',
          style: TextStyle(fontSize: 12, color: Color(0xff67688C)),
        ),
      ],
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
                onPressed: () async {
                  final price = ticket.event?.price ?? 0;
                  final result =
                      await Get.to<bool>(() => SharedPaymentCheckoutPage(
                            args: SharedPaymentFlowArgs.forTicket(
                              ticketId: ticket.ticketId!,
                              originalAmount: price,
                              event: _ticketToEventEntity(ticket),
                            ),
                          ));
                  if (result == true) {
                    _ticketController.loadTickets(refresh: true);
                  }
                },
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

  Widget _buildQrImage(String? qrContent) {
    if (qrContent == null || qrContent.isEmpty) {
      return Container(
        width: 280,
        height: 280,
        color: const Color(0xffF0F0F0),
        child: const Icon(
          Icons.qr_code,
          size: 140,
          color: Color(0xffB0B4C0),
        ),
      );
    }

    try {
      return Image.memory(
        base64Decode(qrContent),
        width: 280,
        height: 280,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 280,
            height: 280,
            color: const Color(0xffF0F0F0),
            child: const Icon(
              Icons.qr_code,
              size: 140,
              color: Color(0xffB0B4C0),
            ),
          );
        },
      );
    } catch (_) {
      return Container(
        width: 280,
        height: 280,
        color: const Color(0xffF0F0F0),
        child: const Icon(
          Icons.qr_code,
          size: 140,
          color: Color(0xffB0B4C0),
        ),
      );
    }
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
