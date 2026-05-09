import 'package:events_app/common/path/asset_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HeaderHomePage extends StatelessWidget {
  const HeaderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 28,
            padding: const EdgeInsets.symmetric(horizontal: 13),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: Colors.white.withOpacity(0.3), width: 1.71)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AssetPath.subHeaderHome,
                  height: 12,
                  width: 12,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Nền tảng sự kiện dành cho sinh viên',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      height: 16 / 12,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Khám phá sự kiện',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                height: 32 / 24,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text('Sinh viên',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                  height: 20 / 14,
                  fontWeight: FontWeight.w400)),
          const SizedBox(height: 4),
          const Text(
            'Kết nối tương lai - Tích lũy thành công',
            style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                height: 16 / 12,
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 20),
          _buildSearchBar(),
          const SizedBox(height: 8),
          _buildListItem(),
        ],
      ),
    );
  }

  _buildSearchBar() => Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: Colors.white),
        child: const Row(
          children: [
            Icon(
              Icons.search_outlined,
              color: Color(0xff67688C),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextField(
                style: TextStyle(
                    color: Color(0xff67688C),
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                maxLines: 1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Tìm sự kiện, trường ĐH, lĩnh vực...',
                  hintStyle: TextStyle(
                    color: Color(0xff67688C),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            )
          ],
        ),
      );

  _buildListItem() => Row(
        spacing: 12,
        children: [
          _buildItemDetail('500+', 'Sự kiện'),
          _buildItemDetail('10K+', 'Sinh viên'),
          _buildItemDetail('50+', 'Trường ĐH'),
          _buildItemDetail('95%', 'Hài lòng')
        ],
      );

  _buildItemDetail(String title, String content) => Expanded(
        child: Container(
          height: 96,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  offset: const Offset(0, 10),
                  blurRadius: 15,
                  spreadRadius: -3,
                )
              ]),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Color(0xff06B6D4),
                    fontSize: 18,
                    height: 28 / 18,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 3),
              Text(
                content,
                style: const TextStyle(
                    color: Color(0xff67688C),
                    fontSize: 10,
                    height: 15 / 10,
                    fontWeight: FontWeight.w400),
              )
            ],
          ),
        ),
      );
}
