import 'package:events_app/common/path/asset_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class RankingCard extends StatelessWidget {
  const RankingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.white.withOpacity(0.1),
              offset: const Offset(0, 10),
              blurRadius: 15,
              spreadRadius: -3)
        ],
        // gradient: const LinearGradient(
        //     colors: [Color(0xffECFEFF), Color(0xffFAA5AB), Color(0xffFAA5AB)],
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight),
        color: Color(0xffFAA5AB).withOpacity(0.7),
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
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(57384700),
                    color: Colors.white.withValues(alpha: 0.2)),
                child: Center(
                  child: SvgPicture.asset(AssetPath.rankingIcon),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bảng xếp hạng',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        height: 24 / 16,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 5.27),
                  Text(
                    'Bạn đang ở vị trí #47 • 1,250 điểm',
                    style: TextStyle(
                        color: const Color(0xff67688C).withValues(alpha: 0.9),
                        fontSize: 12,
                        height: 16 / 12,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.chevron_right_outlined, size: 33)
            ],
          ).marginSymmetric(horizontal: 16),
        ],
      ),
    );
  }
}
