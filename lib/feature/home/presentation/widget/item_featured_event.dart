import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ItemFeaturedEvent extends StatelessWidget {
  const ItemFeaturedEvent({super.key, required this.eventFeatured});

  static const int _bannerLogicalWidth = 162;
  static const int _bannerLogicalHeight = 91;

  final EventSummaryEntity eventFeatured;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 91,
                width: 162,
                child: _buildBanner(),
              ),
              const SizedBox(height: 36),
              Text(
                eventFeatured.title ?? '',
                style: const TextStyle(
                    fontSize: 14,
                    height: 17.5 / 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ).marginSymmetric(horizontal: 12),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_month,
                      size: 12, color: Color(0xff67688C)),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    AppDateUtils.formatDateOnly(eventFeatured.startTime),
                    style: const TextStyle(
                      fontSize: 11,
                      height: 16.5 / 11,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff67688C),
                    ),
                  )
                ],
              ).marginSymmetric(horizontal: 12)
            ],
          ),
          Positioned(
            top: 8,
            left: 8,
            right: 8,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  height: 23,
                  decoration: BoxDecoration(
                    color: const Color(0xff00A63E),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 4),
                        spreadRadius: -1,
                        blurRadius: 6,
                        color: Colors.white.withOpacity(0.1),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      eventFeatured.price == null
                          ? 'Miễn phí'
                          : '${eventFeatured.price} VNĐ',
                      style: const TextStyle(
                        fontSize: 10,
                        height: 15 / 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  height: 23,
                  decoration: BoxDecoration(
                    color: const Color(0xff06B6D4),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 4),
                        spreadRadius: -1,
                        blurRadius: 6,
                        color: Colors.white.withOpacity(0.1),
                      )
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Chứng chỉ',
                      style: TextStyle(
                        fontSize: 10,
                        height: 15 / 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidNetworkSvgUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return false;
    }
    final uri = Uri.tryParse(value.trim());
    return uri != null && uri.hasScheme && uri.hasAuthority;
  }

  Widget _buildBanner() {
    final bannerUrl = eventFeatured.banner;
    if (_isValidNetworkSvgUrl(bannerUrl)) {
      final normalizedUrl = bannerUrl!.trim();
      final isSvg = normalizedUrl.toLowerCase().endsWith('.svg');
      if (isSvg) {
        return SvgPicture.network(
          normalizedUrl,
          fit: BoxFit.cover,
          placeholderBuilder: (context) => _buildImagePlaceholder(),
        );
      }

      return CachedNetworkImage(
        imageUrl: normalizedUrl,
        fit: BoxFit.cover,
        memCacheWidth: _bannerLogicalWidth * 2,
        memCacheHeight: _bannerLogicalHeight * 2,
        maxWidthDiskCache: _bannerLogicalWidth * 2,
        maxHeightDiskCache: _bannerLogicalHeight * 2,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        placeholder: (context, url) => _buildImagePlaceholder(),
        errorWidget: (context, url, error) => _buildImagePlaceholder(),
      );
    }

    return _buildImagePlaceholder();
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 24,
          color: Color(0xff9CA3AF),
        ),
      ),
    );
  }
}
