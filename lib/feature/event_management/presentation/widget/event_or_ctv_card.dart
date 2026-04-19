import 'package:events_app/common/path/asset_path.dart';
import 'package:events_app/feature/common/utils/category_label_utils.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_image_utils.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/event_management/presentation/utils/event_action_utils.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EventOrCtvCard extends StatelessWidget {
  const EventOrCtvCard({
    super.key,
    required this.isEvent,
    this.event,
    this.ctv,
    this.actionStateOverride,
    this.onApplyTap,
  });

  static const int _bannerLogicalWidth = 162;
  static const int _bannerLogicalHeight = 91;

  final bool isEvent;
  final EventSummaryEntity? event;
  final CtvRecruitmentEntity? ctv;
  final ActionButtonState? actionStateOverride;
  final VoidCallback? onApplyTap;

  String get _displayTitle =>
      isEvent ? (event?.title ?? '') : (ctv?.title ?? '');

  DateTime? get _displayStartTime =>
      isEvent ? event?.startTime : ctv?.startTime;

  String? get _displayBannerUrl => isEvent ? event?.banner : ctv?.banner;

  String get _displayPriceLabel {
    if (!isEvent) {
      return ((ctv?.cashRewardAmount ?? 0) > 0)
          ? '${ctv?.cashRewardAmount.toString()}'
          : 'Không lương';
    }

    final price = event?.price;
    return price == null ? 'Miễn phí' : '$price VNĐ';
  }

  String get _displayCategoryLabel {
    return isEvent
        ? CategoryLabelUtils.firstFieldValue(event?.categories)
        : CategoryLabelUtils.firstFieldValue(ctv?.categories);
  }

  ActionButtonState get _actionButtonState {
    if (actionStateOverride != null) {
      return actionStateOverride!;
    }

    if (isEvent) {
      return EventActionUtils.getEventRegisterState(
        status: event?.status,
        registerOpenTime: event?.registerOpenTime,
        endTime: event?.endTime,
        capacity: event?.capacity,
        totalParticipants: event?.totalParticipants,
        userEventState: event?.userEventState,
      );
    }

    return EventActionUtils.getCtvApplyState(
      isOpen: ctv?.isOpen,
      quantity: ctv?.quantity,
      userEventState: ctv?.userEventState,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 256,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: SizedBox(
                  height: 91,
                  width: double.infinity,
                  child: _buildBanner(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      margin: const EdgeInsets.only(left: 10, right: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: isEvent
                                ? const Color(0xff06B6D4)
                                : const Color(0xffDB0025),
                            width: 1.7),
                      ),
                      child: Center(
                        child: Text(
                          _displayCategoryLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 10,
                              height: 15 / 10,
                              fontWeight: FontWeight.w500,
                              color: isEvent
                                  ? const Color(0xff06B6D4)
                                  : const Color(0xffDB0025)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {},
                      child: SvgPicture.asset(
                        AssetPath.scheduleIcon,
                        color: isEvent
                            ? const Color(0xff06B6D4)
                            : const Color(0xffDB0025),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _displayTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  height: 17.5 / 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
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
                    AppDateUtils.formatDateOnly(_displayStartTime),
                    style: const TextStyle(
                      fontSize: 11,
                      height: 16.5 / 11,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff67688C),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    AssetPath.networkIcon,
                    color: const Color(0xff67688C),
                    height: 12,
                    width: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isEvent
                        ? event!.capacity.toString()
                        : ctv!.quantity.toString(),
                    style: const TextStyle(
                      fontSize: 11,
                      height: 16.5 / 11,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff67688C),
                    ),
                  )
                ],
              ).marginSymmetric(horizontal: 12),
              const Spacer(),
              Center(
                child: GestureDetector(
                  onTap: _actionButtonState.isEnabled ? onApplyTap : null,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 32,
                    width: 138,
                    decoration: BoxDecoration(
                      color: _actionButtonState.isEnabled
                          ? (isEvent
                              ? const Color(0xff06B6D4)
                              : const Color(0xffDB0025))
                          : const Color(0xffB0B4C0),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        _actionButtonState.label,
                        style: const TextStyle(
                            fontSize: 12,
                            height: 16 / 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Positioned(
            top: 6,
            left: 8,
            right: 8,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 23,
                    decoration: BoxDecoration(
                      color: isEvent
                          ? const Color(0xff00A63E)
                          : const Color(0xffDB0025),
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
                        _displayPriceLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          height: 15 / 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  height: 23,
                  decoration: BoxDecoration(
                    color: isEvent
                        ? const Color(0xff06B6D4)
                        : const Color(0xff00A63E),
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
                      'Chứng nhận',
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

  Widget _buildBanner() {
    return AppImageUtils.buildNetworkImage(
      imageUrl: _displayBannerUrl,
      placeholder: AppImageUtils.buildImageLoadingPlaceholder(),
      errorPlaceholder: AppImageUtils.buildImagePlaceholder(),
      fit: BoxFit.cover,
      memCacheWidth: _bannerLogicalWidth * 2,
      memCacheHeight: _bannerLogicalHeight * 2,
      maxWidthDiskCache: _bannerLogicalWidth * 2,
      maxHeightDiskCache: _bannerLogicalHeight * 2,
    );
  }
}
