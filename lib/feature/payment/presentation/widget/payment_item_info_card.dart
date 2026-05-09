import 'package:events_app/feature/common/domain/entity/package_entity.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_image_utils.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';
import 'package:events_app/feature/portfolio/domain/entity/portfolio_entity.dart';
import 'package:events_app/feature/payment/presentation/page/shared_payment_flow_args.dart';
import 'package:events_app/feature/user_management/domain/entity/user_package_entity.dart';
import 'package:flutter/material.dart';

class PaymentItemInfoCard extends StatelessWidget {
  final PaymentItemInfo itemInfo;

  const PaymentItemInfoCard({
    super.key,
    required this.itemInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ItemImage(itemInfo: itemInfo),
              const SizedBox(width: 12),
              Expanded(child: _ItemDetails(itemInfo: itemInfo)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ItemImage extends StatelessWidget {
  final PaymentItemInfo itemInfo;

  const _ItemImage({required this.itemInfo});

  @override
  Widget build(BuildContext context) {
    final imageUrl = itemInfo.itemImageUrl;
    final isEvent = itemInfo.event != null;
    final isPortfolio = itemInfo.portfolio != null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 80,
        height: 80,
        child: imageUrl != null && imageUrl.isNotEmpty
            ? AppImageUtils.buildNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                memCacheWidth: 160,
                memCacheHeight: 160,
                placeholder: _buildPlaceholder(isEvent, isPortfolio),
                errorPlaceholder: _buildPlaceholder(isEvent, isPortfolio),
              )
            : _buildPlaceholder(isEvent, isPortfolio),
      ),
    );
  }

  Widget _buildPlaceholder(bool isEvent, bool isPortfolio) {
    IconData icon;
    Color bgColor;
    Color iconColor;

    if (isPortfolio) {
      icon = Icons.folder_outlined;
      bgColor = const Color(0xffFEF3C7);
      iconColor = const Color(0xffF59E0B);
    } else if (isEvent) {
      icon = Icons.event_outlined;
      bgColor = const Color(0xffDBEAFE);
      iconColor = const Color(0xff3B82F6);
    } else {
      icon = Icons.inventory_2_outlined;
      bgColor = const Color(0xffD1FAE5);
      iconColor = const Color(0xff10B981);
    }

    return Container(
      color: bgColor,
      child: Center(
        child: Icon(icon, size: 32, color: iconColor),
      ),
    );
  }
}

class _ItemDetails extends StatelessWidget {
  final PaymentItemInfo itemInfo;

  const _ItemDetails({required this.itemInfo});

  @override
  Widget build(BuildContext context) {
    if (itemInfo.event != null) {
      return _EventPaymentDetails(event: itemInfo.event!);
    } else if (itemInfo.package != null) {
      return _PackagePaymentDetails(
        package: itemInfo.package!,
        autoRenew: itemInfo.autoRenew,
      );
    } else if (itemInfo.portfolio != null) {
      return _PortfolioPaymentDetails(portfolio: itemInfo.portfolio!);
    } else if (itemInfo.userPackage != null) {
      return _UserPackagePaymentDetails(userPackage: itemInfo.userPackage!);
    }
    return const SizedBox.shrink();
  }
}

class _EventPaymentDetails extends StatelessWidget {
  final EventEntity event;

  const _EventPaymentDetails({required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title ?? 'Sự kiện',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xff273143),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if ((event.organizerName ?? '').trim().isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.business_outlined,
                size: 14,
                color: Color(0xff67688C),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  event.organizerName!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff67688C),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
        if (event.venue != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: Color(0xff67688C),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  event.venue!.name ?? event.venue!.address ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff67688C),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
        if (event.startTime != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.schedule_outlined,
                size: 14,
                color: Color(0xff67688C),
              ),
              const SizedBox(width: 4),
              Text(
                AppDateUtils.formatDateTime(event.startTime),
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xff67688C),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        _buildPriceBadge(event.price),
      ],
    );
  }
}

class _PackagePaymentDetails extends StatelessWidget {
  final PackageEntity package;
  final bool autoRenew;

  const _PackagePaymentDetails({
    required this.package,
    required this.autoRenew,
  });

  @override
  Widget build(BuildContext context) {
    final name = package.name ?? 'Gói dịch vụ';
    final description = package.description;
    final durationDays = package.durationDays;
    final price = package.price;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xffD1FAE5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 14,
                    color: Color(0xff10B981),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'GÓI DỊCH VỤ',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff10B981),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xff273143),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if ((description ?? '').trim().isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            description!,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xff67688C),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (durationDays != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: Color(0xff67688C),
              ),
              const SizedBox(width: 4),
              Text(
                'Thời hạn: $durationDays ngày',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xff67688C),
                ),
              ),
            ],
          ),
        ],
        if (autoRenew) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.autorenew,
                size: 14,
                color: Color(0xff3B82F6),
              ),
              const SizedBox(width: 4),
              const Text(
                'Tự động gia hạn',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xff3B82F6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        _buildPriceBadge(price),
      ],
    );
  }
}

class _PortfolioPaymentDetails extends StatelessWidget {
  final PortfolioEntity portfolio;

  const _PortfolioPaymentDetails({required this.portfolio});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xffFEF3C7),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.folder_outlined,
                    size: 14,
                    color: Color(0xffF59E0B),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'PORTFOLIO',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffF59E0B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          portfolio.title ?? 'Portfolio',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xff273143),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if ((portfolio.description ?? '').trim().isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            portfolio.description!,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xff67688C),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if ((portfolio.portfolioCode ?? '').trim().isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.code,
                size: 14,
                color: Color(0xff67688C),
              ),
              const SizedBox(width: 4),
              Text(
                portfolio.portfolioCode!,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xff67688C),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        _buildPriceBadge(portfolio.price),
      ],
    );
  }
}

class _UserPackagePaymentDetails extends StatelessWidget {
  final UserPackageEntity userPackage;

  const _UserPackagePaymentDetails({required this.userPackage});

  @override
  Widget build(BuildContext context) {
    final name = userPackage.packageName ?? 'Gói dịch vụ';
    final endTime = userPackage.endTime;
    final price = userPackage.price?.toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xffD1FAE5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 14,
                    color: Color(0xff10B981),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'GÓI DỊCH VỤ',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff10B981),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xffFEE2E2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'HẾT HẠN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffEF4444),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xff273143),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (endTime != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.event_busy_outlined,
                size: 14,
                color: Color(0xffEF4444),
              ),
              const SizedBox(width: 4),
              Text(
                'Hết hạn: ${_formatDate(endTime)}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xffEF4444),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        _buildPriceBadge(price),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

Widget _buildPriceBadge(int? price) {
  if (price == null || price <= 0) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xff10B981),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'MIỄN PHÍ',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  final formatted = price.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (match) => ',',
      );

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xffDBEAFE),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      '$formatted VND',
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color(0xff2563EB),
      ),
    ),
  );
}
