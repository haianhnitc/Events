import 'package:get/get.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final String? imageUrl;
  final String? category;
  bool read;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.imageUrl,
    this.category = 'other',
    this.read = false,
  });
}

class NotificationsController extends GetxController {
  final items = <NotificationItem>[
    NotificationItem(
      id: 'n1',
      title: 'Nhắc: Workshop Flutter',
      body: 'Workshop Flutter bắt đầu sau 30 phút',
      imageUrl: null,
      category: 'event',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      read: false,
    ),
    NotificationItem(
      id: 'n2',
      title: 'Sự kiện: Hackathon',
      body: 'Bạn đã đăng ký Hackathon vào 25/11',
      imageUrl: null,
      category: 'event',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      read: false,
    ),
    NotificationItem(
      id: 'n3',
      title: 'Thông báo hệ thống',
      body: 'Bảo trì hệ thống vào 00:00 hôm nay',
      imageUrl: null,
      category: 'system',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      read: true,
    ),
  ].obs;

  int get unreadCount => items.where((i) => !i.read).length;

  void markAllRead() {
    for (var i in items) {
      i.read = true;
    }
    items.refresh();
  }

  void markRead(String id) {
    final idx = items.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      items[idx].read = true;
      items.refresh();
    }
  }

  void remove(String id) {
    items.removeWhere((e) => e.id == id);
  }

  void add(NotificationItem item) {
    items.insert(0, item);
  }
}
