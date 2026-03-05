import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'notifications_controller.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  final NotificationsController ctrl = Get.put(NotificationsController());

  late final TabController _tabController;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  int _getUnreadCount(String filter) {
    final items = ctrl.items.where((i) => !i.read).toList();
    final now = DateTime.now();
    if (filter == 'recent') {
      return items.where((i) => now.difference(i.timestamp).inDays < 1).length;
    } else if (filter == 'event') {
      return items.where((i) => i.category == 'event').length;
    } else if (filter == 'system') {
      return items.where((i) => i.category == 'system').length;
    }
    return items.length; // all
  }

  Widget _buildTabWithBadge(String text, int count) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          if (count > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF00BFA6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                count.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() => Row(
                children: [
                  const Text('Thông báo',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  if (ctrl.unreadCount > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('${ctrl.unreadCount} chưa đọc',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ],
              )),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Obx(() => TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: const Color(0xFF00BFA6),
                  labelColor: Colors.black87,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    _buildTabWithBadge('Tất cả', _getUnreadCount('all')),
                    _buildTabWithBadge('Mới', _getUnreadCount('recent')),
                    _buildTabWithBadge('Sự kiện', _getUnreadCount('event')),
                    _buildTabWithBadge('Hệ thống', _getUnreadCount('system')),
                  ],
                )),
          ),
          actions: [
            Obx(() => Row(
                  children: [
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () => ctrl.markAllRead(),
                          icon: const Icon(Icons.mark_email_read,
                              color: Color(0xFF00BFA6)),
                          tooltip: 'Đánh dấu tất cả đã đọc',
                        ),
                        if (ctrl.unreadCount > 0)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00BFA6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 14,
                                minHeight: 14,
                              ),
                              child: Text(
                                ctrl.unreadCount > 99
                                    ? '99+'
                                    : ctrl.unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                )),
            const SizedBox(width: 8),
          ],
        ),
        backgroundColor: Colors.grey.shade50,
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildListFor(context, 'all'),
            _buildListFor(context, 'recent'),
            _buildListFor(context, 'event'),
            _buildListFor(context, 'system'),
          ],
        ),
      ),
    );
  }

  Widget _buildListFor(BuildContext context, String filter) {
    return Obx(() {
      final items = ctrl.items;
      List<NotificationItem> filtered = items;
      final now = DateTime.now();
      if (filter == 'recent') {
        filtered =
            items.where((i) => now.difference(i.timestamp).inDays < 1).toList();
      } else if (filter == 'event') {
        filtered = items.where((i) => i.category == 'event').toList();
      } else if (filter == 'system') {
        filtered = items.where((i) => i.category == 'system').toList();
      }

      final searchText = _searchController.text.toLowerCase();
      if (searchText.isNotEmpty) {
        filtered = filtered
            .where((i) =>
                i.title.toLowerCase().contains(searchText) ||
                i.body.toLowerCase().contains(searchText))
            .toList();
      }

      if (filtered.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_off,
                    size: 40, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text('Bạn không có thông báo nào',
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text('Khi có thông báo mới, chúng sẽ xuất hiện ở đây.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
            ],
          ),
        );
      }

      // group: recent (<24h) and earlier
      final recent = filtered
          .where((i) => now.difference(i.timestamp).inHours < 24)
          .toList();
      final earlier = filtered
          .where((i) => now.difference(i.timestamp).inHours >= 24)
          .toList();

      Widget buildSection(String title, List<NotificationItem> list) {
        if (list.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700)),
            ),
            ...list.map((it) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Slidable(
                    key: ValueKey(it.id),
                    endActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) {
                            HapticFeedback.lightImpact();
                            ctrl.markRead(it.id);
                          },
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                          icon: Icons.mark_email_read,
                          label: 'Đã đọc',
                        ),
                        SlidableAction(
                          onPressed: (_) {
                            HapticFeedback.lightImpact();
                            ctrl.add(NotificationItem(
                              id: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              title: 'Nhắc: ${it.title}',
                              body: 'Bạn đã thêm lời nhắc cho "${it.title}"',
                              timestamp: DateTime.now(),
                              category: 'event',
                            ));
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Đã thêm lịch (giả)')));
                          },
                          backgroundColor: const Color(0xFF00BFA6),
                          foregroundColor: Colors.white,
                          icon: Icons.event_available,
                          label: 'Thêm lịch',
                        ),
                        SlidableAction(
                          onPressed: (_) {
                            HapticFeedback.heavyImpact();
                            ctrl.remove(it.id);
                          },
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Xóa',
                        ),
                      ],
                    ),
                    child: _card(it),
                  ),
                ))
          ],
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          // Simulate refresh
          await Future.delayed(const Duration(seconds: 1));
          // In real app, fetch new notifications
          ctrl.add(NotificationItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: 'Thông báo mới',
            body: 'Đã làm mới danh sách thông báo.',
            timestamp: DateTime.now(),
            category: 'system',
          ));
        },
        color: const Color(0xFF00BFA6),
        child: ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 20),
          children: [
            if (filtered.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm thông báo...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),
            // sections
            buildSection('Mới', recent),
            buildSection('Trước đó', earlier),
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }

  Widget _card(NotificationItem it) {
    final category = it.category ?? 'other';
    final color =
        category == 'event' ? const Color(0xFF00BFA6) : Colors.grey.shade600;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(it.read ? 0.02 : 0.06),
              blurRadius: it.read ? 2 : 8,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => ctrl.markRead(it.id),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: color,
                  child: it.imageUrl == null
                      ? Icon(it.category == 'event' ? Icons.event : Icons.info,
                          color: Colors.white)
                      : null,
                  backgroundImage:
                      it.imageUrl != null ? NetworkImage(it.imageUrl!) : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Text(it.title,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: it.read
                                          ? FontWeight.w600
                                          : FontWeight.bold))),
                          const SizedBox(width: 8),
                          Text(_friendlyTime(it.timestamp),
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(it.body,
                          style: TextStyle(color: Colors.grey.shade700),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8)),
                            child: Text((it.category ?? 'other').toUpperCase(),
                                style: TextStyle(
                                    color: color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => ctrl.remove(it.id),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _friendlyTime(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${t.day}/${t.month}';
  }
}
