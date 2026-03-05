import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/feature/events/presentation/page/event_detail_page.dart';
import 'package:events_app/feature/events/presentation/widget/event_filter_sheet.dart';
import 'package:events_app/feature/events/presentation/controller/event_page_controller.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(EventPageController());

    void openFilterSheet() async {
      final result = await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (ctx) => EventFilterSheet(controller: c),
      );

      if (result != null) {
        c.applyFilters(result);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sự kiện'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm theo tên hoặc địa điểm',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 12),
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
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                              child: const SizedBox(height: 6, width: 6),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 12),
            Obx(() => Text('${c.filtered.length} kết quả',
                style: const TextStyle(color: Colors.black54))),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                final list = c.filtered;
                if (list.isEmpty)
                  return const Center(child: Text('Không có kết quả phù hợp'));
                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final e = list[index];
                    final seatsLeft = e.slots - e.memberRegister;
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => EventDetailPage(event: e))),
                      // child: UpcomingEnvent(
                      //   title: e.name,
                      //   date: '${e.date} • ${e.hours}',
                      //   location: e.address,
                      //   seatsRemaining: '$seatsLeft chỗ trống',
                      //   onAddToCalendar: () {
                      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //         content: Text('Thêm vào lịch: ${e.name}')));
                      //   },
                      // ),
                      child: Container(),
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
