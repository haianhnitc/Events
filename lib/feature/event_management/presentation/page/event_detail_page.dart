import 'package:events_app/feature/event_management/data/model/event_model.dart';
import 'package:events_app/feature/event_management/presentation/controller/event_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailPage extends StatelessWidget {
  final EventModel event;

  const EventDetailPage({super.key, required this.event});

  String _fmt(DateTime? dt) {
    if (dt == null) return '-';
    final d = dt.toLocal();
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EventPageController>();
    final venue = controller.getVenue(event.venueId);
    final organizer = controller.getUser(event.userId);

    return Scaffold(
      appBar: AppBar(title: Text(event.title ?? 'Event detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('Thong tin su kien'),
          _kv('Ten su kien', event.title ?? '-'),
          _kv('Mo ta', event.description ?? '-'),
          _kv('Trang thai', event.status?.name ?? '-'),
          _kv('Loai tuyen dung', event.recruitmentType?.name ?? '-'),
          const SizedBox(height: 20),
          _section('Thoi gian'),
          _kv('Mo dang ky', _fmt(event.registerOpenTime)),
          _kv('Bat dau', _fmt(event.startTime)),
          _kv('Ket thuc', _fmt(event.endTime)),
          const SizedBox(height: 20),
          if (venue != null) ...[
            _section('Dia diem'),
            _kv('Ten dia diem', venue.name ?? '-'),
            _kv('Dia chi', venue.address ?? '-'),
            _kv('Suc chua', '${venue.capacity ?? 0} nguoi'),
            if (venue.mapUrl != null && venue.mapUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextButton.icon(
                  onPressed: () => _openMap(venue.mapUrl!),
                  icon: const Icon(Icons.map),
                  label: const Text('Xem ban do'),
                ),
              ),
            const SizedBox(height: 20),
          ],
          if (organizer != null) ...[
            _section('Nguoi to chuc'),
            _kv('Email', organizer.email),
            _kv('So dien thoai', organizer.phoneNumber ?? '-'),
            _kv('Vai tro', organizer.role?.name ?? '-'),
          ],
          const SizedBox(height: 10),
          _kv('Tao luc', _fmt(event.createdTime)),
        ],
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }

  Widget _kv(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _openMap(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
