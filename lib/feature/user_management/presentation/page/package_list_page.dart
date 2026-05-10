import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/user_management/domain/entity/user_package_entity.dart';
import 'package:events_app/feature/user_management/presentation/controller/package_list_controller.dart';

class PackageListPage extends StatefulWidget {
  const PackageListPage({super.key});

  @override
  State<PackageListPage> createState() => _PackageListPageState();
}

class _PackageListPageState extends State<PackageListPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late final PackageListController ctrl;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ctrl = Get.put(PackageListController(), tag: 'package_list');
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(_onTabChanged);
    ctrl.onTabChanged(0);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ctrl.loadMyPackages(refresh: true);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      ctrl.onTabChanged(_tabController.index);
    }
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
        title: const Text(
          'Gói dịch vụ',
          style: TextStyle(
            color: Color(0xff273143),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF06B6D4),
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: const Color(0xFF06B6D4),
          labelStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Gói có sẵn'),
            Tab(text: 'Gói của tôi'),
            Tab(text: 'Đã hết hạn'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAvailableTab(),
          _buildMyPackagesTab(),
          _buildExpiredTab(),
        ],
      ),
    );
  }

  Widget _buildAvailableTab() {
    return Obx(() {
      if (ctrl.isLoadingAvailable.value && ctrl.availablePackages.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (ctrl.availablePackages.isEmpty) {
        return _buildEmptyState(
          'Chưa có gói dịch vụ',
          'Danh sách gói dịch vụ đang trống.',
        );
      }

      return RefreshIndicator(
        onRefresh: () => ctrl.loadAvailablePackages(refresh: true),
        notificationPredicate: (notification) => notification.depth == 1,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification &&
                notification.metrics.extentAfter < 80 &&
                ctrl.availablePackages.isNotEmpty &&
                !ctrl.isLoadingAvailable.value &&
                ctrl.hasMoreAvailable.value) {
              ctrl.loadAvailablePackages();
            }
            return false;
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ctrl.availablePackages.length +
                (ctrl.hasMoreAvailable.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= ctrl.availablePackages.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return _buildAvailablePackageItem(ctrl.availablePackages[index]);
            },
          ),
        ),
      );
    });
  }

  Widget _buildMyPackagesTab() {
    return Obx(() {
      final activePackages =
          ctrl.myPackages.where((p) => p.status == UserPackageStatus.active).toList();

      if (ctrl.isLoadingMyPackages.value && ctrl.myPackages.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (activePackages.isEmpty) {
        return _buildEmptyState(
          'Chưa mua gói nào',
          'Bạn chưa mua gói dịch vụ nào.',
        );
      }

      return RefreshIndicator(
        onRefresh: () => ctrl.loadMyPackages(refresh: true),
        notificationPredicate: (notification) => notification.depth == 1,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification &&
                notification.metrics.extentAfter < 80 &&
                activePackages.isNotEmpty &&
                !ctrl.isLoadingMyPackages.value &&
                ctrl.hasMoreMyPackages.value) {
              ctrl.loadMyPackages();
            }
            return false;
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: activePackages.length +
                (ctrl.hasMoreMyPackages.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= activePackages.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return _buildMyPackageItem(activePackages[index]);
            },
          ),
        ),
      );
    });
  }

  Widget _buildExpiredTab() {
    return Obx(() {
      if (ctrl.isLoadingExpired.value && ctrl.expiredPackages.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (ctrl.expiredPackages.isEmpty) {
        return _buildEmptyState(
          'Không có gói hết hạn',
          'Tất cả gói của bạn vẫn còn hiệu lực.',
        );
      }

      return RefreshIndicator(
        onRefresh: () => ctrl.loadExpiredPackages(refresh: true),
        notificationPredicate: (notification) => notification.depth == 1,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification &&
                notification.metrics.extentAfter < 80 &&
                ctrl.expiredPackages.isNotEmpty &&
                !ctrl.isLoadingExpired.value &&
                ctrl.hasMoreExpired.value) {
              ctrl.loadExpiredPackages();
            }
            return false;
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ctrl.expiredPackages.length +
                (ctrl.hasMoreExpired.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= ctrl.expiredPackages.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return _buildMyPackageItem(ctrl.expiredPackages[index], expired: true);
            },
          ),
        ),
      );
    });
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailablePackageItem(package) {
    final price = package.price ?? 0;
    final duration = package.duration ?? package.durationDays ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.card_membership,
                  color: Color(0xFF06B6D4),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.packageName ?? package.name ?? 'Không có tên',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff273143),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$duration ngày',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatCurrency(price),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF06B6D4),
                    ),
                  ),
                  const Text(
                    '/ gói',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xff67688C),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (package.description != null &&
              package.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              package.description!,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: Obx(() => _buildPackageButton(package)),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageButton(package) {
    final pkgId = package.packageId;
    final owned = pkgId != null &&
        ctrl.myPackages.any((p) => p.packageId == pkgId);

    if (owned) {
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9CA3AF),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          disabledBackgroundColor: const Color(0xFF9CA3AF),
          disabledForegroundColor: Colors.white,
        ),
        child: const Text(
          'Đã sở hữu',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      );
    }

    return ElevatedButton(
      onPressed: () => ctrl.onPurchasePackage(package),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF06B6D4),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
      ),
      child: const Text(
        'Mua gói này',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildMyPackageItem(UserPackageEntity package,
      {bool expired = false}) {
    final status = package.status;
    final statusColor = expired || status == UserPackageStatus.expired
        ? const Color(0xffEF4444)
        : const Color(0xff22C55E);
    final statusText = expired || status == UserPackageStatus.expired
        ? 'Đã hết hạn'
        : 'Đang hoạt động';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: expired
            ? Border.all(color: const Color(0xffEF4444).withValues(alpha: 0.3))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  expired ? Icons.timer_off : Icons.verified,
                  color: statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.packageName ?? 'Không có tên',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff273143),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mua ngày: ${_formatDate(package.createdTime)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildPackageInfo(
                  'Bắt đầu',
                  _formatDate(package.startTime ?? package.createdTime),
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: Colors.grey.shade200,
              ),
              Expanded(
                child: _buildPackageInfo(
                  'Hết hạn',
                  _formatDate(package.endTime),
                ),
              ),
            ],
          ),
          if (package.autoRenew == true) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.autorenew, size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  'Tự động gia hạn',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ],
          if (expired) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => ctrl.onRenewPackage(package),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF06B6D4),
                  side: const BorderSide(color: Color(0xFF06B6D4)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Gia hạn ngay',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPackageInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
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
    );
  }

  String _formatCurrency(int amount) {
    if (amount == 0) return 'Miễn phí';
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}tr';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}k';
    }
    return '$amount đ';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.day}/${date.month}/${date.year}';
  }
}
