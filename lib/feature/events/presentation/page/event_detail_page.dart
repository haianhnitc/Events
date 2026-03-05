import 'package:flutter/material.dart';
import 'package:events_app/feature/home/data/models/event_model.dart';

class EventDetailPage extends StatelessWidget {
  final EventModel event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final seatsLeft = event.slots - event.memberRegister;
    // defensive locals to protect against older hot-reload instances where
    // optional fields might be null at runtime. Cast to dynamic to avoid
    // static null-safety complaints and provide safe defaults.
    final String _venueName = (event as dynamic).venueName ?? '';
    final List<dynamic> _tags = (event as dynamic).tags ?? <dynamic>[];
    final List<dynamic> _speakers = (event as dynamic).speakers ?? <dynamic>[];
    final List<dynamic> _schedule = (event as dynamic).schedule ?? <dynamic>[];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header image with overlay
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(18)),
                    child: Image.asset(
                      event.img,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.18),
                          Colors.black.withOpacity(0.45)
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(18)),
                    ),
                  ),
                ),
                Positioned(
                  left: 8,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.share, color: Colors.white),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.bookmark_border,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(event.category,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 8),
                      Text(event.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ],
            ),

            // Body
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 16, color: Colors.black54),
                          const SizedBox(width: 6),
                          Flexible(
                              child: Text(
                                  _venueName.isNotEmpty
                                      ? '$_venueName, ${event.address}'
                                      : event.address,
                                  style: theme.textTheme.bodyMedium
                                      ?.copyWith(color: Colors.black87))),
                          const Spacer(),
                          Chip(
                              label: Text(event.format,
                                  style: const TextStyle(fontSize: 12))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 16, color: Colors.black54),
                          const SizedBox(width: 6),
                          Text('${event.date} • ${event.hours}',
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: Colors.black54)),
                          const Spacer(),
                          Text('$seatsLeft chỗ',
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: Colors.green.shade700)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Organizer card
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                        color: Colors.grey.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                  backgroundColor: Colors.blue.shade100,
                                  child: Text(event.organization.isNotEmpty
                                      ? event.organization[0]
                                      : 'O')),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(event.organization,
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 6),
                                    Text('Tổ chức',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(color: Colors.black54)),
                                  ],
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.mail_outline),
                                label: const Text('Liên hệ'),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tags
                      if (_tags.isNotEmpty) ...[
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _tags
                              .map((t) => Chip(label: Text(t.toString())))
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Description
                      Text('Mô tả',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text(
                          (event.description ?? '').isNotEmpty
                              ? (event.description ?? '')
                              : (event.certificate.isNotEmpty
                                  ? event.certificate
                                  : 'Mô tả chi tiết về sự kiện sẽ được cập nhật tại đây.'),
                          style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 12),

                      // Speakers
                      if (_speakers.isNotEmpty) ...[
                        Text('Diễn giả',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 84,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _speakers.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, idx) {
                              final s = _speakers[idx] as Map?;
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.grey.shade200,
                                      child: Text(
                                          (s?['name']?.toString().isNotEmpty ==
                                                  true)
                                              ? s!['name']
                                                  .toString()
                                                  .substring(0, 1)
                                              : '?')),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: 96,
                                    child: Text(s?['name']?.toString() ?? '',
                                        style: theme.textTheme.bodySmall,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center),
                                  ),
                                  SizedBox(
                                    width: 96,
                                    child: Text(s?['title']?.toString() ?? '',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(color: Colors.black54),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Schedule
                      if (_schedule.isNotEmpty) ...[
                        Text('Lịch trình',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Column(
                          children: _schedule.map((item) {
                            final map = item as Map?;
                            return ListTile(
                              dense: true,
                              leading: Icon(Icons.access_time,
                                  size: 18, color: Colors.black54),
                              title: Text(map?['title']?.toString() ?? ''),
                              subtitle: Text(map?['time']?.toString() ?? ''),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 18),

                      // Contact & Actions
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.bookmark_border),
                              label: const Text('LƯU'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.event_available),
                              label: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 14.0),
                                child: Text('ĐĂNG KÝ',
                                    style: TextStyle(fontSize: 16)),
                              ),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
