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
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;

  final items = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  int get unreadCount => items.where((i) => !i.read).length;

  Future<void> loadNotifications() async {
    if (isLoading.value) return;
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 600));

    items.assignAll(_buildMockData());

    isLoading.value = false;
  }

  Future<void> refreshNotifications() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;

    await Future.delayed(const Duration(milliseconds: 800));

    items.assignAll(_buildMockData());

    isRefreshing.value = false;
  }

  List<NotificationItem> _buildMockData() {
    final now = DateTime.now();
    return [
      NotificationItem(
        id: 'n1',
        title: 'Nhắc: Workshop Flutter',
        body: 'Workshop Flutter bắt đầu sau 30 phút nữa. Hãy chuẩn bị sẵn sàng!',
        timestamp: now.subtract(const Duration(minutes: 10)),
        category: 'event',
        read: false,
      ),
      NotificationItem(
        id: 'n2',
        title: 'Xác nhận đăng ký sự kiện',
        body: 'Bạn đã đăng ký thành công sự kiện "Tech Summit 2026" diễn ra ngày 25/11.',
        timestamp: now.subtract(const Duration(hours: 3)),
        category: 'event',
        read: false,
      ),
      NotificationItem(
        id: 'n3',
        title: 'Nhận thưởng coin',
        body: 'Bạn đã nhận được 10 coin từ việc đọc tin tức. Cảm ơn bạn đã tham gia!',
        timestamp: now.subtract(const Duration(hours: 8)),
        category: 'system',
        read: true,
      ),
      NotificationItem(
        id: 'n4',
        title: 'Thông báo hệ thống',
        body: 'Hệ thống sẽ bảo trì vào lúc 00:00 - 02:00 ngày mai. Vui lòng lưu công việc trước đó.',
        timestamp: now.subtract(const Duration(days: 1)),
        category: 'system',
        read: true,
      ),
      NotificationItem(
        id: 'n5',
        title: 'Đơn ứng tuyển CTV được duyệt',
        body: 'Chúc mừng! Đơn ứng tuyển CTV của bạn đã được chấp nhận.',
        timestamp: now.subtract(const Duration(days: 2)),
        category: 'system',
        read: true,
      ),
    ];
  }

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
