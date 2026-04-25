import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/feature/user_management/domain/entity/rank_entity.dart';
import 'package:events_app/feature/user_management/presentation/controller/rank_list_controller.dart';

class RankListPage extends StatelessWidget {
  const RankListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(RankListController());

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: Column(
        children: [
          _buildHeader(ctrl),
          _buildLevelFilter(ctrl),
          Expanded(child: _buildRankList(ctrl)),
        ],
      ),
    );
  }

  Widget _buildHeader(RankListController ctrl) {
    return Obx(() {
    final my = ctrl.myRank.value;
    final avatarUrl = ctrl.currentAvatarUrl;
    final userName = ctrl.currentUserName ?? '';

      return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF06B6D4), Color(0xFF155DFC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(Get.context!),
                    ),
                    const Expanded(
                      child: Text(
                        'Bảng xếp hạng',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: avatarUrl != null && avatarUrl.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                avatarUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _buildHeaderAvatarPlaceholder(userName),
                              ),
                            )
                          : _buildHeaderAvatarPlaceholder(userName),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          if (my != null)
                            Text(
                              '#${my.ranking ?? '—'}  •  ${my.levelName ?? 'Chưa có'}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.85),
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          else
                            Text(
                              'Chưa có xếp hạng',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (my != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${my.totalCoin ?? 0}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeaderAvatarPlaceholder(String name) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Center(
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLevelFilter(RankListController ctrl) {
    return Container(
      height: 44,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: ctrl.levelFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final level = ctrl.levelFilters[index];
          return Obx(() {
            final isSelected = ctrl.selectedLevel.value == level['label'];
            return GestureDetector(
              onTap: () => ctrl.onLevelChanged(level['label']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF06B6D4) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF06B6D4) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Text(
                  level['label']!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xff64748B),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildRankList(RankListController ctrl) {
    return Obx(() {
      if (ctrl.isLoading.value && ctrl.ranks.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF06B6D4)),
        );
      }

      if (ctrl.ranks.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.leaderboard_outlined, size: 64, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text(
                'Chưa có dữ liệu xếp hạng',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => ctrl.loadRanks(refresh: true),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: ctrl.ranks.length + (ctrl.hasMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= ctrl.ranks.length) {
              ctrl.loadRanks();
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF06B6D4),
                    ),
                  ),
                ),
              );
            }
            return _buildRankItem(ctrl.ranks[index], ctrl);
          },
        ),
      );
    });
  }

  Widget _buildRankItem(RankEntity rank, RankListController ctrl) {
    final myUserId = ctrl.currentUserId;
    final isMe = rank.userId == myUserId;
    final isTop3 = rank.ranking != null && rank.ranking! <= 3;

    return GestureDetector(
      onTap: () => ctrl.showUserDetail(rank),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: isMe ? Border.all(color: const Color(0xFF06B6D4), width: 1.5) : null,
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
              width: 48,
              height: 80,
              decoration: BoxDecoration(
                color: _getRankBadgeColor(rank.ranking).withValues(alpha: 0.15),
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
              ),
              child: Center(
                child: Text(
                  '${rank.ranking ?? '—'}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isTop3 ? _getRankBadgeColor(rank.ranking) : Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  _buildAvatar(rank),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                rank.user?.fullName ?? 'Không tên',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isMe ? const Color(0xFF06B6D4) : const Color(0xff273143),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isMe) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Bạn',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF06B6D4),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getLevelColor(rank.level).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                rank.levelName ?? 'Chưa có',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _getLevelColor(rank.level),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.monetization_on, size: 12, color: Colors.grey.shade400),
                                const SizedBox(width: 3),
                                Text(
                                  '${rank.totalCoin ?? 0}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
  }

  Widget _buildAvatar(RankEntity rank) {
    final avatarUrl = rank.user?.avatarUrl;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getLevelColor(rank.level).withValues(alpha: 0.1),
      ),
      child: avatarUrl != null && avatarUrl.isNotEmpty
          ? ClipOval(
              child: Image.network(
                avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(rank),
              ),
            )
          : _buildAvatarPlaceholder(rank),
    );
  }

  Widget _buildAvatarPlaceholder(RankEntity rank) {
    final name = rank.user?.fullName ?? '?';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Center(
      child: Text(
        initial,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: _getLevelColor(rank.level),
        ),
      ),
    );
  }

  Color _getLevelColor(int? level) {
    switch (level) {
      case 5:
        return const Color(0xff7B2FBE);
      case 4:
        return const Color(0xffFF6B35);
      case 3:
        return const Color(0xff06B6D4);
      case 2:
        return const Color(0xff00A63E);
      default:
        return const Color(0xff94A3B8);
    }
  }

  Color _getRankBadgeColor(int? ranking) {
    if (ranking == 1) return const Color(0xffFFD700);
    if (ranking == 2) return const Color(0xffC0C0C0);
    if (ranking == 3) return const Color(0xffCD7F32);
    return Colors.grey.shade200;
  }
}
