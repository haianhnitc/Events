import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_image_utils.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/registration/presentation/controller/registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyRegistrationPage extends StatefulWidget {
  const MyRegistrationPage({super.key});

  @override
  State<MyRegistrationPage> createState() => _MyRegistrationPageState();
}

class _MyRegistrationPageState extends State<MyRegistrationPage> {
  final RegistrationController _controller = RegistrationController.ensureInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xff06B6D4),
        elevation: 0,
        title: const Text(
          'Đăng Ký Của Tôi',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _controller.loadMyRegistrations(refresh: true),
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value && _controller.registrations.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xff06B6D4),
            ),
          );
        }

        final registrations = _controller.registrations;

        if (registrations.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () => _controller.loadMyRegistrations(refresh: true),
          color: const Color(0xff06B6D4),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: registrations.length,
            itemBuilder: (context, index) {
              return _buildRegistrationCard(registrations[index]);
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
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
            child: const Icon(
              Icons.event_available,
              size: 40,
              color: Color(0xffB0B4C0),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Chưa có đăng ký nào',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xff67688C),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Đăng ký tham gia sự kiện để xem tại đây',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xffB0B4C0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationCard(ParticipantEntity participant) {
    final isAttended = participant.status == ParticipantStatus.attended;
    final isNoShow = participant.status == ParticipantStatus.noShow;
    final hasTicket = participant.ticketId != null;
    final hasFeedback = participant.hasFeedback == true;

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
          _buildRegistrationHeader(participant, isAttended, isNoShow, hasTicket, hasFeedback),
          const Divider(height: 1, color: Color(0xffF0F0F0)),
          _buildRegistrationInfo(participant),
          if (!isNoShow) _buildRegistrationActions(participant, isAttended, hasTicket, hasFeedback),
        ],
      ),
    );
  }

  Widget _buildRegistrationHeader(
    ParticipantEntity participant,
    bool isAttended,
    bool isNoShow,
    bool hasTicket,
    bool hasFeedback,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 72,
              height: 72,
              child: participant.event?.banner != null
                  ? AppImageUtils.buildNetworkImage(
                      imageUrl: participant.event!.banner!,
                      placeholder: AppImageUtils.buildImagePlaceholder(
                        icon: Icons.event,
                      ),
                      fit: BoxFit.cover,
                    )
                  : AppImageUtils.buildImagePlaceholder(
                      icon: Icons.event,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: participant.participantType == ParticipantType.ctv
                            ? const Color(0xffDB0025).withValues(alpha: 0.1)
                            : const Color(0xff06B6D4).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        participant.participantType == ParticipantType.ctv ? 'CTV' : 'Người tham dự',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: participant.participantType == ParticipantType.ctv
                              ? const Color(0xffDB0025)
                              : const Color(0xff06B6D4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusChip(participant.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  participant.event?.title ?? 'Sự kiện',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff273143),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ParticipantStatus? status) {
    if (status == ParticipantStatus.noShow) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xffEF4444).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'Không tham dự',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xffEF4444),
          ),
        ),
      );
    }

    if (status == ParticipantStatus.attended) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xff22C55E).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'Đã tham dự',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xff22C55E),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xffF59E0B).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        'Đã đăng ký',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Color(0xffF59E0B),
        ),
      ),
    );
  }

  Widget _buildRegistrationInfo(ParticipantEntity participant) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoRow(
            Icons.schedule,
            'Thời gian đăng ký',
            AppDateUtils.formatDateTime(participant.registeredTime),
          ),
          if (participant.checkInTime != null) ...[
            const SizedBox(height: 10),
            _buildInfoRow(
              Icons.login,
              'Check-in lúc',
              AppDateUtils.formatDateTime(participant.checkInTime),
            ),
          ],
          if (participant.checkOutTime != null) ...[
            const SizedBox(height: 10),
            _buildInfoRow(
              Icons.logout,
              'Check-out lúc',
              AppDateUtils.formatDateTime(participant.checkOutTime),
            ),
          ],
          if (participant.ticketId != null) ...[
            const SizedBox(height: 10),
            _buildInfoRow(
              Icons.confirmation_number,
              'Mã vé',
              '#${participant.ticketId}',
            ),
          ],
          if (participant.hasFeedback == true && participant.feedbackSubmittedTime != null) ...[
            const SizedBox(height: 10),
            _buildInfoRow(
              Icons.rate_review,
              'Đã đánh giá',
              AppDateUtils.formatDateTime(participant.feedbackSubmittedTime),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xff06B6D4).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(
            icon,
            size: 18,
            color: const Color(0xff06B6D4),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
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
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegistrationActions(
    ParticipantEntity participant,
    bool isAttended,
    bool hasTicket,
    bool hasFeedback,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          if (hasTicket && !isAttended)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _navigateToMyTicket(),
                icon: const Icon(Icons.confirmation_number, size: 18),
                label: const Text('Xem vé'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xff06B6D4),
                  side: const BorderSide(color: Color(0xff06B6D4)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          if (hasTicket && !isAttended) const SizedBox(width: 10),
          if (isAttended && !hasFeedback)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _navigateToFeedback(participant.eventId!),
                icon: const Icon(Icons.rate_review, size: 18),
                label: const Text('Đánh giá'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff06B6D4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          if (isAttended && hasFeedback)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xffDCFCE7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 18,
                      color: Color(0xff22C55E),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Đã đánh giá',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff22C55E),
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

  void _navigateToMyTicket() {
    Get.toNamed('/my-ticket');
  }

  void _navigateToFeedback(int eventId) {
    Get.toNamed('/feedback', arguments: {'eventId': eventId});
  }
}
