import 'package:events_app/feature/event_management/presentation/controller/event_page_controller.dart';
import 'package:events_app/feature/event_management/presentation/page/event_detail_page.dart';
import 'package:events_app/feature/event_management/presentation/widget/event_filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(EventPageController());

    Future<void> openFilterSheet() async {
      final result = await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => EventFilterSheet(controller: c),
      );

      if (result != null) {
        c.applyFilters(result);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Su kien'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tim theo ten hoac mo ta',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 12,
                      ),
                    ),
                    onChanged: c.setQuery,
                  ),
                ),
                const SizedBox(width: 8),
                Obx(() {
                  final active = c.hasActiveFilters;
                  return IconButton(
                    onPressed: openFilterSheet,
                    icon: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        const Icon(Icons.filter_list, size: 28),
                        if (active)
                          const Positioned(
                            right: 0,
                            top: 0,
                            child: CircleAvatar(
                                radius: 4, backgroundColor: Colors.red),
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 12),
            Obx(
              () => Align(
                alignment: Alignment.centerLeft,
                child: Text('${c.filtered.length} ket qua'),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                final list = c.filtered;
                if (list.isEmpty) {
                  return const Center(child: Text('Khong co ket qua phu hop'));
                }

                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final e = list[index];
                    final venue = c.getVenue(e.venueId);
                    return Card(
                      child: ListTile(
                        title: Text(e.title ?? 'Untitled event'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${e.recruitmentType?.name ?? '-'} | ${e.status?.name ?? '-'}'),
                            if (venue != null && venue.name != null)
                              Text(
                                '📍 ${venue.name}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EventDetailPage(event: e),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
