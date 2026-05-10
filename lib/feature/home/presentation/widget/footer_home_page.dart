import 'package:events_app/common/path/asset_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class FooterHomePage extends StatelessWidget {
  const FooterHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffF5F5F5),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 17),
          const Text(
            'Tại sao chọn S-Events?',
            style: TextStyle(
                fontSize: 18,
                height: 28 / 18,
                fontWeight: FontWeight.w700,
                color: Colors.black),
          ),
          const SizedBox(
            height: 17.27,
          ),
          _buildQuestionCard(1, 'Sự kiện đa dạng',
              'Hàng trăm sự kiện từ các trường đại học hàng đầu'),
          const SizedBox(height: 12),
          _buildQuestionCard(2, 'Chứng chỉ 5 tốt',
              'Tích lũy chứng chỉ được công nhận chính thức'),
          const SizedBox(height: 12),
          _buildQuestionCard(3, 'Kết nối cộng đồng',
              'Mở rộng mối quan hệ với sinh viên toàn quốc'),
          const SizedBox(height: 38)
        ],
      ),
    );
  }

  _buildQuestionCard(int period, String title, String content) {
    return Container(
      padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
      constraints: const BoxConstraints(minHeight: 96),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 6,
              spreadRadius: -1,
              color: Colors.white.withOpacity(0.1),
            )
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: period == 2
                  ? const Color(0xffDB0025).withOpacity(0.1)
                  : const Color(0xff06B6D4).withOpacity(0.1),
            ),
            child: Center(
              child: SvgPicture.asset(
                period == 1
                    ? AssetPath.calendarIcon
                    : period == 2
                        ? AssetPath.certificateIcon
                        : AssetPath.networkIcon,
                height: 20,
                width: 20,
                color: period == 2
                    ? const Color(0xffDB0025)
                    : const Color(0xff06B6D4),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 20 / 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff273143),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 16 / 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff67688C),
                  ),
                  softWrap: true,
                )
              ],
            ).marginOnly(right: 30),
          )
        ],
      ),
    );
  }
}
