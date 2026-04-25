import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/feature/portfolio/domain/entity/portfolio_detail_entity.dart';
import 'package:events_app/feature/portfolio/domain/entity/portfolio_event_entity.dart';
import 'package:events_app/feature/user_management/presentation/controller/portfolio_detail_controller.dart';

class PortfolioDetailPage extends StatelessWidget {
  final int portfolioId;

  const PortfolioDetailPage({super.key, required this.portfolioId});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(
      PortfolioDetailController()..initWithId(portfolioId),
    );

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
          'Chi tiết hồ sơ',
          style: TextStyle(
            color: Color(0xff273143),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF06B6D4)),
          );
        }

        final portfolio = ctrl.portfolio.value;
        if (portfolio == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text(
                  'Không tải được dữ liệu',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(portfolio, ctrl.isPublished),
              const SizedBox(height: 16),
              _buildStats(portfolio),
              if (portfolio.description != null && portfolio.description!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildDescription(portfolio),
              ],
              const SizedBox(height: 16),
              _buildOwnerInfo(portfolio),
              const SizedBox(height: 16),
              _buildItemsSection(portfolio),
              const SizedBox(height: 16),
              _buildMetaInfo(portfolio, ctrl.isOwner),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(PortfolioDetailEntity p, bool isPublished) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
            blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: p.thumbnail != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          p.thumbnail!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.folder_rounded,
                            color: Color(0xFF06B6D4),
                            size: 28,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.folder_rounded,
                        color: Color(0xFF06B6D4),
                        size: 28,
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title ?? 'Không có tiêu đề',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff273143),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isPublished
                            ? Colors.green.shade50
                            : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isPublished ? 'Đã xuất bản' : 'Chưa xuất bản',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isPublished
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (p.itemCount != null && p.itemCount! > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.event_rounded, size: 14, color: Color(0xFF06B6D4)),
                  const SizedBox(width: 4),
                  Text(
                    '${p.itemCount} sự kiện',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF06B6D4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStats(PortfolioDetailEntity p) {
    return Container(
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
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              Icons.visibility_rounded,
              '${p.viewCount ?? 0}',
              'Lượt xem',
              const Color(0xFF06B6D4),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade200,
          ),
          Expanded(
            child: _buildStatItem(
              Icons.download_rounded,
              '${p.downloadCount ?? 0}',
              'Lượt tải',
              const Color(0xFF7B2FBE),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade200,
          ),
          Expanded(
            child: _buildStatItem(
              Icons.attach_money_rounded,
              _formatCurrency(p.price ?? 0),
              'Giá',
              const Color(0xFF22C55E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(PortfolioDetailEntity p) {
    return Container(
      width: double.infinity,
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
          const Row(
            children: [
              Icon(Icons.description_outlined,
                  size: 18, color: Color(0xff64748B)),
              SizedBox(width: 6),
              Text(
                'Mô tả',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff273143),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            p.description ?? '',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerInfo(PortfolioDetailEntity p) {
    final owner = p.user;
    final ownerName = owner?.fullName ?? 'Không xác định';

    return Container(
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
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
            ),
            child: owner?.avatarUrl != null
                ? ClipOval(
                    child: Image.network(
                      owner!.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _buildAvatarPlaceholder(ownerName),
                    ),
                  )
                : _buildAvatarPlaceholder(ownerName),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ownerName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff273143),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Chủ sở hữu',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder(String name) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Center(
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF06B6D4),
        ),
      ),
    );
  }

  Widget _buildItemsSection(PortfolioDetailEntity p) {
    final items = p.items;
    if (items == null || items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
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
              const Icon(Icons.event_rounded, size: 18, color: Color(0xff64748B)),
              const SizedBox(width: 6),
              Text(
                'Sự kiện trong hồ sơ (${items.length})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff273143),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => _buildEventItem(item)),
        ],
      ),
    );
  }

  Widget _buildEventItem(PortfolioEventEntity item) {
    final isAttended = item.participantStatus == 'ATTENDED';
    final isCtv = item.participantType == 'CTV';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (item.eventBanner != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.eventBanner!,
                    width: 48, height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.event, size: 20, color: Color(0xFF06B6D4)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.displayTitle ?? item.eventTitle ?? 'Không có tiêu đề',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff273143),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: isCtv ? Colors.purple.shade50 : Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.participantType ?? '',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isCtv ? Colors.purple.shade700 : Colors.blue.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (item.participantStatus != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: isAttended ? Colors.green.shade50 : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.participantStatus ?? '',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isAttended ? Colors.green.shade700 : Colors.orange.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (item.displayRole != null && item.displayRole!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.badge_outlined, size: 12, color: Color(0xff64748B)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    item.displayRole!,
                    style: const TextStyle(fontSize: 12, color: Color(0xff64748B)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          if (item.displayNote != null && item.displayNote!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.notes_outlined, size: 12, color: Color(0xff64748B)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    item.displayNote!,
                    style: const TextStyle(fontSize: 12, color: Color(0xff64748B)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              if (item.hasCheckIn == true) ...[
                _buildBadge(Icons.check_circle_outline, 'Đã checkin', Colors.green),
                const SizedBox(width: 6),
              ],
              if (item.hasFeedback == true) ...[
                _buildBadge(Icons.star_outline, 'Đã feedback', Colors.amber),
                const SizedBox(width: 6),
              ],
              if (item.youthUnionPoints != null && item.youthUnionPoints! > 0) ...[
                _buildBadge(Icons.emoji_events_outlined, '${item.youthUnionPoints} điểm', Colors.orange),
                const SizedBox(width: 6),
              ],
              if (item.coinReward != null && item.coinReward! > 0) ...[
                _buildBadge(Icons.monetization_on_outlined, '${item.coinReward} coin', Colors.green),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaInfo(PortfolioDetailEntity p, bool isOwner) {
    return Container(
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
        children: [
          _buildMetaRow('Mã hồ sơ', p.portfolioCode ?? '—'),
          Divider(height: 20, color: Colors.grey.shade200),
          _buildMetaRow('Ngày tạo', _formatTimeAgo(p.createdTime)),
          if (isOwner && p.publishTime != null) ...[
            Divider(height: 20, color: Colors.grey.shade200),
            _buildMetaRow('Xuất bản', _formatDateTime(p.publishTime)),
          ],
        ],
      ),
    );
  }

  Widget _buildMetaRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
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

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return '—';
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _formatTimeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} tháng trước';
    if (diff.inDays > 0) return '${diff.inDays} ngày trước';
    if (diff.inHours > 0) return '${diff.inHours} giờ trước';
    if (diff.inMinutes > 0) return '${diff.inMinutes} phút trước';
    return 'Vừa xong';
  }
}
