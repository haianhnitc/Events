import 'package:events_app/feature/organizer/presentation/controller/organizer_event_statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerEventStatisticsPage extends StatefulWidget {
  final int eventId;

  const OrganizerEventStatisticsPage({super.key, required this.eventId});

  @override
  State<OrganizerEventStatisticsPage> createState() =>
      _OrganizerEventStatisticsPageState();
}

class _OrganizerEventStatisticsPageState
    extends State<OrganizerEventStatisticsPage> {
  late OrganizerEventStatisticsController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(OrganizerEventStatisticsController());
    _ctrl.setEventId(widget.eventId);
  }

  @override
  void dispose() {
    Get.delete<OrganizerEventStatisticsController>();
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
        title: const Text('Thống kê sự kiện',
            style: TextStyle(
                color: Color(0xff273143),
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xff64748B)),
            onPressed: () => _ctrl.refresh(),
          ),
        ],
      ),
      body: Obx(() {
        if (_ctrl.isLoadingStats.value && _ctrl.statistics.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: _ctrl.refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopStats(),
                const SizedBox(height: 20),
                _buildRegistrationChart(),
                const SizedBox(height: 20),
                _buildCheckInRate(),
                const SizedBox(height: 20),
                _buildDemographics(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTopStats() {
    final stats = _ctrl.statistics.value;
    final total = stats?.totalRegistered ?? 0;
    final checkedIn = stats?.totalCheckedIn ?? 0;
    final checkedOut = stats?.totalCheckedOut ?? 0;
    final noShow = total - checkedIn;
    final rate = total > 0 ? ((checkedIn / total) * 100) : 0.0;
    final ticketsSold = stats?.totalTicketsSold ?? 0;
    final totalViews = stats?.totalViews ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stats?.eventTitle ?? 'Sự kiện',
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xff273143)),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStatCard('$total', 'Tổng đăng ký', const Color(0xFF06B6D4)),
            const SizedBox(width: 10),
            _buildStatCard('$checkedIn', 'Đã tham dự', const Color(0xFF10B981)),
            const SizedBox(width: 10),
            _buildStatCard('${rate.toStringAsFixed(0)}%', 'Tỷ lệ',
                const Color(0xFF8B5CF6)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildStatCard(
                '$ticketsSold', 'Vé bán ra', const Color(0xFFF59E0B)),
            const SizedBox(width: 10),
            _buildStatCard('$noShow', 'Vắng mặt', Colors.grey.shade600),
            const SizedBox(width: 10),
            _buildStatCard(
                '$totalViews', 'Lượt xem', const Color(0xFFEC4899)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildStatCard(
                '${stats?.totalCtv ?? 0}', 'CTV', const Color(0xFF06B6D4)),
            const SizedBox(width: 10),
            _buildStatCard(
                '${stats?.totalFeedbacks ?? 0}', 'Feedback', const Color(0xFFF59E0B)),
            const SizedBox(width: 10),
            _buildStatCard('$checkedOut', 'Check-out', const Color(0xFF8B5CF6)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationChart() {
    final timeline = _ctrl.analytics.value?.checkInTimeline ?? [];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
              Text('Check-in theo thời gian',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff273143))),
              Spacer(),
              Icon(Icons.show_chart, size: 18, color: Color(0xFF06B6D4)),
            ],
          ),
          const SizedBox(height: 16),
          if (timeline.isEmpty)
            const SizedBox(
              height: 80,
              child: Center(
                child: Text('Chưa có dữ liệu check-in',
                    style: TextStyle(color: Color(0xff94A3B8), fontSize: 13)),
              ),
            )
          else
            SizedBox(
              height: 160,
              child: Row(
                children: timeline.map((item) {
                  final maxCount = timeline
                      .map((e) => e.count ?? 0)
                      .fold<int>(0, (max, c) => c > max ? c : max);
                  final fraction = maxCount > 0
                      ? ((item.count ?? 0) / maxCount).clamp(0.05, 1.0)
                      : 0.05;
                  return _buildTimelineBar(
                    item.time ?? '',
                    fraction,
                    item.count ?? 0,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineBar(String time, double fraction, int count) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Tooltip(
                message: '$count người',
                child: Container(
                  height: 120 * fraction,
                  width: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF06B6D4),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(time,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildCheckInRate() {
    final stats = _ctrl.statistics.value;
    final total = stats?.totalRegistered ?? 0;
    final checkedIn = stats?.totalCheckedIn ?? 0;
    final noShow = total - checkedIn;
    final rate = total > 0 ? (checkedIn / total) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tỷ lệ điểm danh',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff273143))),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: rate,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF06B6D4)),
                      ),
                    ),
                    Text('${(rate * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF06B6D4))),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _buildRateItem(
                        'Đã tham dự', checkedIn, const Color(0xFF10B981)),
                    const SizedBox(height: 8),
                    _buildRateItem('Vắng mặt', noShow, const Color(0xFFEF4444)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRateItem(String label, int count, Color color) {
    return Row(
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
        const Spacer(),
        Text('$count người',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildDemographics() {
    final gender = _ctrl.analytics.value?.genderDistribution;
    final age = _ctrl.analytics.value?.ageDistribution;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Phân bố người tham gia',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff273143))),
          const SizedBox(height: 16),
          if (gender != null) ...[
            if (gender.femalePercentage != null && gender.femalePercentage! > 0)
              _buildDemoRow('Nữ', gender.femalePercentage!.toInt(),
                  const Color(0xFFEC4899)),
            const SizedBox(height: 10),
            if (gender.malePercentage != null && gender.malePercentage! > 0)
              _buildDemoRow('Nam', gender.malePercentage!.toInt(),
                  const Color(0xFF3B82F6)),
            const SizedBox(height: 16),
          ],
          if (age != null && age.isNotEmpty) ...[
            ...age.map((a) {
              final name = a.name ?? '';
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildDemoRow(
                    name, (a.percentage ?? 0).toInt(), const Color(0xFF06B6D4)),
              );
            }),
          ],
          if ((gender == null ||
                  (gender.femalePercentage == null &&
                      gender.malePercentage == null)) &&
              (age == null || age.isEmpty))
            const Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text('Chưa có dữ liệu phân bố',
                    style: TextStyle(color: Color(0xff94A3B8), fontSize: 13)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDemoRow(String label, int percent, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        ),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (percent / 100).clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 40,
          child: Text('$percent%',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff273143))),
        ),
      ],
    );
  }
}
