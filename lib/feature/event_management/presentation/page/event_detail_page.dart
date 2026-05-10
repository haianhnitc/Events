import 'package:events_app/common/path/asset_path.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_image_utils.dart';
import 'package:events_app/feature/common/utils/app_map_utils.dart';
import 'package:events_app/feature/event_management/presentation/controller/event_detail_page_controller.dart';
import 'package:events_app/feature/event_management/presentation/utils/event_action_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({
    super.key,
    required this.eventId,
    this.onBack,
  });

  final int? eventId;
  final VoidCallback? onBack;

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  late final String _controllerTag;
  late final EventDetailPageController _controller;
  bool _controllerWasRegistered = false;

  static const int _bannerLogicalWidth = 368;
  static const int _bannerLogicalHeight = 224;
  static const Color _categoryColor = Color(0xff06B6D4);
  static const Color _categoryCardBgColor = Color(0xffEEF9FF);
  static const Color _categoryChipBgColor = Color(0xffDFF4FF);

  @override
  void initState() {
    super.initState();
    _controllerTag = 'event_detail_${widget.eventId ?? 'unknown'}';
    _controllerWasRegistered =
        Get.isRegistered<EventDetailPageController>(tag: _controllerTag);
    if (_controllerWasRegistered) {
      _controller = Get.find<EventDetailPageController>(tag: _controllerTag);
    } else {
      _controller = Get.put(
        EventDetailPageController(eventId: widget.eventId),
        tag: _controllerTag,
      );
    }
  }

  @override
  void dispose() {
    if (!_controllerWasRegistered) {
      Get.delete<EventDetailPageController>(tag: _controllerTag);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (_controller.isLoading) {
          return const Scaffold(
            backgroundColor: Color(0xffF5F5F5),
            body: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff06B6D4)),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xffF5F5F5),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xff273143)),
              onPressed: () {
                if (widget.onBack != null) {
                  widget.onBack!();
                } else {
                  Get.back();
                }
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: _bannerLogicalHeight.toDouble(),
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(child: _buildBanner()),
                      _buildTag(),
                    ],
                  ),
                ),
                const SizedBox(height: 17),
                _buildEventStatusBanner(),
                _buildHeader(),
                const SizedBox(height: 16),
                Divider(
                        height: 1,
                        color: const Color(0xff273143).withOpacity(0.1))
                    .marginSymmetric(horizontal: 16),
                const SizedBox(height: 16),
                _buildEventDetail(context),
                const SizedBox(height: 8),
                _buildBenefitCard(),
                const SizedBox(height: 16),
                _buildRegisterButton(),
                const SizedBox(height: 30)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventStatusBanner() {
    final status = _controller.event.value?.status;
    if (status == null) return const SizedBox.shrink();
    if (status == EventStatus.published) return const SizedBox.shrink();
    if (status == EventStatus.draft) return const SizedBox.shrink();

    Color color;
    IconData icon;
    String message;

    if (status == EventStatus.locked) {
      color = const Color(0xFFEF4444);
      icon = Icons.lock_outline;
      message = 'Sự kiện bị khóa bởi quản trị viên.';
    } else if (status == EventStatus.cancelled) {
      color = const Color(0xFF6B7280);
      icon = Icons.cancel_outlined;
      message = 'Sự kiện đã bị hủy.';
    } else if (status == EventStatus.closed) {
      color = const Color(0xFFF59E0B);
      icon = Icons.event_busy;
      message = 'Sự kiện đã kết thúc.';
    } else {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                    fontSize: 13, color: color, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    final event = _controller.event.value;

    return AppImageUtils.buildNetworkImage(
      imageUrl: event?.banner,
      placeholder: AppImageUtils.buildImagePlaceholder(),
      fit: BoxFit.cover,
      memCacheWidth: _bannerLogicalWidth * 2,
      memCacheHeight: _bannerLogicalHeight * 2,
      maxWidthDiskCache: _bannerLogicalWidth * 2,
      maxHeightDiskCache: _bannerLogicalHeight * 2,
    );
  }

  Widget _buildTag() {
    return Positioned(
      top: 6,
      left: 8,
      right: 8,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
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
                _controller.priceLabel,
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
          const Spacer(),
          _controller.hasCertificate
              ? Container(
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
                      'Chứng nhận',
                      style: TextStyle(
                        fontSize: 10,
                        height: 15 / 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : const SizedBox(height: 0),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final event = _controller.event.value;
    final categoryGroups = _controller.categoryGroups;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categoryGroups
                .map(
                  (group) => Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _categoryCardBgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        width: 1.2,
                        color: _categoryColor.withOpacity(0.55),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _categoryColor.withOpacity(0.14),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${group.name}:',
                          style: const TextStyle(
                            fontSize: 12,
                            height: 16 / 12,
                            fontWeight: FontWeight.w700,
                            color: _categoryColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: group.values
                              .map(
                                (value) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _categoryChipBgColor,
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: _categoryColor.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      height: 14 / 11,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff273143),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  event?.title ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    height: 24 / 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff273143),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            event?.description ?? '',
            style: const TextStyle(
              fontSize: 14,
              height: 20 / 14,
              fontWeight: FontWeight.w400,
              color: Color(0xff67688C),
            ),
          ),
          const SizedBox(height: 16),
          // Center(
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       _buildItemButton(1),
          //       const SizedBox(width: 15),
          //       _buildItemButton(2),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  // Widget _buildItemButton(int position) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 7),
  //     height: 36,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(10),
  //       border: Border.all(
  //         width: 1.71,
  //         color: const Color(0xff273143).withOpacity(0.1),
  //       ),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         SvgPicture.asset(
  //           position == 1 ? AssetPath.calendarIcon : AssetPath.notification,
  //           height: 16,
  //           width: 16,
  //           color: Colors.black,
  //         ),
  //         const SizedBox(width: 17),
  //         Text(
  //           position == 1 ? 'Thêm vào lịch' : 'Đặt Nhắc nhở',
  //           style: const TextStyle(
  //             fontSize: 14,
  //             height: 20 / 14,
  //             fontWeight: FontWeight.w500,
  //             color: Color(0xff273143),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _buildEventDetail(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              width: 1.71, color: const Color(0xff273143).withOpacity(0.1))),
      child: Column(
        children: [
          _buildComponentDetail(context, 1),
          const SizedBox(height: 12),
          Divider(
            height: 1,
            color: const Color(0xff273143).withOpacity(0.1),
          ),
          const SizedBox(height: 12),
          _buildComponentDetail(context, 2),
          const SizedBox(height: 12),
          Divider(
            height: 1,
            color: const Color(0xff273143).withOpacity(0.1),
          ),
          const SizedBox(height: 12),
          _buildComponentDetail(context, 3),
          const SizedBox(height: 12),
          Divider(
            height: 1,
            color: const Color(0xff273143).withOpacity(0.1),
          ),
          const SizedBox(height: 12),
          _buildComponentDetail(context, 4),
        ],
      ),
    );
  }

  Widget _buildComponentDetail(BuildContext context, int position) {
    final event = _controller.event.value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          position == 1
              ? AssetPath.events
              : position == 2
                  ? AssetPath.locationIcon
                  : position == 3
                      ? AssetPath.organizationIcon
                      : AssetPath.networkIcon,
          color: const Color(0xff06B6D4),
          height: 20,
          width: 20,
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      position == 1
                          ? 'Thời gian'
                          : position == 2
                              ? 'Địa điểm'
                              : position == 3
                                  ? 'Ban tổ chức'
                                  : 'Số chỗ còn trống',
                      style: const TextStyle(
                        fontSize: 14,
                        height: 20 / 14,
                        fontWeight: FontWeight.w400,
                        color: Color(
                          0xff67688C,
                        ),
                      ),
                    ),
                  ),
                  if (position == 2)
                    InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => AppMapUtils.openVenueDirection(
                        context,
                        mapUrl: event?.venue?.mapUrl,
                        latitude: event?.venue?.latitude,
                        longitude: event?.venue?.longitude,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xff06B6D4).withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.directions,
                          size: 18,
                          color: Color(0xff06B6D4),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              position != 4
                  ? Text(
                      position == 1
                          ? AppDateUtils.formatDateTime(event?.startTime)
                          : position == 2
                              ? event?.venue?.name ?? ''
                              : event?.organizerName ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        height: 24 / 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff273143),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_controller.remainingSlots} / ${_controller.venueCapacity}',
                              style: const TextStyle(
                                fontSize: 16,
                                height: 24 / 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff273143),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xff06B6D4),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${_controller.registrationPercent}% đã đăng ký',
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 16 / 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 13,
                          width: double.infinity,
                          child: LinearProgressIndicator(
                            value: _controller.registrationProgress,
                            minHeight: 8,
                            backgroundColor: const Color(0xffF5F5F5),
                            borderRadius: BorderRadius.circular(16),
                            valueColor:
                                const AlwaysStoppedAnimation(Color(0xff06B6D4)),
                          ),
                        )
                      ],
                    )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBenefitCard() {
    final benefits = _controller.benefits;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff06B6D4).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1.71,
          color: const Color(0xff06B6D4).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quyền lợi',
            style: TextStyle(
                fontSize: 16,
                height: 20 / 16,
                fontWeight: FontWeight.w400,
                color: Color(0xff273143)),
          ),
          const SizedBox(height: 12),
          ..._buildBenefitItems(benefits),
        ],
      ),
    );
  }

  List<Widget> _buildBenefitItems(List<String> benefits) {
    final widgets = <Widget>[];
    for (var index = 0; index < benefits.length; index++) {
      widgets.add(_buildBenefitComponent(benefits[index]));
      if (index != benefits.length - 1) {
        widgets.add(const SizedBox(height: 8));
      }
    }
    return widgets;
  }

  Widget _buildBenefitComponent(String title) {
    return Row(
      children: [
        SvgPicture.asset(
          AssetPath.tickIcon,
          color: const Color(0xff06B6D4),
          height: 14,
          width: 14,
        ),
        const SizedBox(width: 9.32),
        Text(
          title,
          style: const TextStyle(
              fontSize: 14,
              height: 20 / 14,
              fontWeight: FontWeight.w400,
              color: Color(0xff273143)),
        )
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Obx(() {
      final ev = _controller.event.value;
      debugPrint(
          '[UI] _buildRegisterButton — ev.eventId=${ev?.eventId}, userEventState=${ev?.userEventState}, totalParticipants=${ev?.totalParticipants}');
      final userState = ev?.userEventState;
      final actionState = EventActionUtils.getEventRegisterState(
        status: ev?.status,
        registerOpenTime: ev?.registerOpenTime,
        endTime: ev?.endTime,
        capacity: ev?.venue?.capacity,
        totalParticipants: ev?.totalParticipants,
        userEventState: userState,
      );
      final isSubmitting = _controller.isSubmittingRegistration.value;
      final canTap = actionState.isEnabled && !isSubmitting;

      return GestureDetector(
        onTap: canTap ? _controller.registerAndHandlePayment : null,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 42,
          decoration: BoxDecoration(
            color: canTap ? const Color(0xff06B6D4) : const Color(0xffB0B4C0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Center(
                child: isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        actionState.label,
                        style: const TextStyle(
                            fontSize: 14,
                            height: 20 / 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
              ),
              Positioned(
                top: 12,
                left: 28,
                child: SvgPicture.asset(
                  AssetPath.tickIcon,
                  height: 16,
                  width: 16,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
