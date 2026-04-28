import 'package:events_app/common/path/asset_path.dart';
import 'package:events_app/feature/home/presentation/controller/home_controller.dart';
import 'package:events_app/feature/user_management/domain/entity/rank_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class RankingCard extends StatelessWidget {
  final RankEntity? rank;
  final VoidCallback? onTap;

  const RankingCard({
    super.key,
    this.rank,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.white.withOpacity(0.1),
                offset: const Offset(0, 10),
                blurRadius: 15,
                spreadRadius: -3)
          ],
          color: const Color(0xffFAA5AB).withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned(
                top: 0,
                right: 0,
                child: SvgPicture.asset(
                  AssetPath.rankingIcon,
                  height: 96,
                  width: 96,
                  color: const Color(0xff273143).withOpacity(0.05),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 56,
                  width: 56,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  child: Center(
                    child: SvgPicture.asset(AssetPath.rankingIcon),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bảng xếp hạng',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          height: 24 / 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5.27),
                      Obx(() {
                        final homeController =
                            Get.isRegistered<HomeController>()
                                ? Get.find<HomeController>()
                                : null;
                        final effectiveRank =
                            rank ?? homeController?.userRank.value;
                        final ranking = effectiveRank?.ranking;
                        final levelName =
                            effectiveRank?.levelName ?? 'Chưa có';
                        final totalCoin = effectiveRank?.totalCoin ?? 0;
                        return Text(
                          ranking != null
                              ? 'Bạn đang ở vị trí #$ranking • $levelName • $totalCoin xu'
                              : 'Bạn chưa có xếp hạng',
                          style: TextStyle(
                            color:
                                const Color(0xff67688C).withValues(alpha: 0.9),
                            fontSize: 12,
                            height: 16 / 12,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      }),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_outlined, size: 33)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
