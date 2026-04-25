import 'package:get/get.dart';
import 'package:events_app/data_mock/notification_mock.dart';

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

  NotificationItem copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? timestamp,
    String? imageUrl,
    String? category,
    bool? read,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      read: read ?? this.read,
    );
  }
}

class NotificationsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool hasMore = true.obs;
  final RxString errorMessage = ''.obs;

  final items = <NotificationItem>[].obs;
  int _currentPage = 0;
  static const int _pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  int get unreadCount => items.where((i) => !i.read).length;

  Future<void> loadNotifications({bool refresh = false}) async {
    if (isLoading.value) return;

    if (refresh) {
      _currentPage = 0;
      hasMore.value = true;
      items.clear();
      errorMessage.value = '';
    }

    if (!hasMore.value && !refresh) return;

    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 500));

    final start = _currentPage * _pageSize;
    final end = start + _pageSize;
    final pageData = notificationMock.sublist(
      start,
      end > notificationMock.length ? notificationMock.length : end,
    );

    if (pageData.isEmpty) {
      hasMore.value = false;
    } else {
      if (refresh) {
        items.assignAll(pageData);
      } else {
        items.addAll(pageData);
      }
      _currentPage++;
      hasMore.value = end < notificationMock.length;
    }

    isLoading.value = false;
  }

  Future<void> refreshNotifications() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;
    await loadNotifications(refresh: true);
    isRefreshing.value = false;
  }

  Future<void> loadMore() async {
    if (isLoading.value || !hasMore.value) return;
    await loadNotifications();
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
