import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/common/path/asset_path.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_image_utils.dart';
import 'package:events_app/feature/common/utils/app_map_utils.dart';
import 'package:events_app/feature/event_management/presentation/page/event_detail_page.dart';
import 'package:events_app/feature/organizer/presentation/page/events/organizer_event_detail_page.dart';
import 'package:events_app/feature/recruitment/presentation/controller/ctv_detail_page_controller.dart';
import 'package:events_app/feature/recruitment/presentation/widget/ctv_apply_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CtvDetailPage extends StatefulWidget {
  const CtvDetailPage({
    super.key,
    required this.ctvRecruitmentId,
    this.onBack,
  });

  final int? ctvRecruitmentId;
  final VoidCallback? onBack;

  @override
  State<CtvDetailPage> createState() => _CtvDetailPageState();
}

class _CtvDetailPageState extends State<CtvDetailPage> {
  late final CtvDetailPageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CtvDetailPageController.attach(widget.ctvRecruitmentId);
  }

  @override
  void dispose() {
    CtvDetailPageController.detach(widget.ctvRecruitmentId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (_controller.isLoading.value) {
          return const Scaffold(
            backgroundColor: Color(0xffF5F5F5),
            body: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xffDB0025)),
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
                  height: 224,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(child: _buildBanner()),
                      _buildTag(),
                    ],
                  ),
                ),
                const SizedBox(height: 17),
                _buildHeader(),
                const SizedBox(height: 16),
                Divider(
                        height: 1,
                        color: const Color(0xff273143).withOpacity(0.1))
                    .marginSymmetric(horizontal: 16),
                const SizedBox(height: 16),
                _buildctvDetail(context),
                const SizedBox(height: 16),
                _buildBenefitCard(),
                const SizedBox(height: 16),
                _buildGoToEventButton(),
                _buildRegisterButton(),
                const SizedBox(height: 30)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBanner() {
    final ctv = _controller.recruitment.value;

    return AppImageUtils.buildNetworkImage(
      imageUrl: ctv?.banner,
      placeholder: AppImageUtils.buildImagePlaceholder(),
      fit: BoxFit.cover,
      memCacheWidth: 736,
      memCacheHeight: 448,
      maxWidthDiskCache: 736,
      maxHeightDiskCache: 448,
    );
  }

  Widget _buildTag() {
    return Positioned(
      top: 6,
      left: 8,
      right: 8,
      child: Row(
        children: [
          _controller.hasCashReward
              ? Container(
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
                      _controller.cashRewardLabel,
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
                )
              : const SizedBox(height: 0),
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
    );
  }

  Widget _buildHeader() {
    final ctv = _controller.recruitment.value;
    final categoryGroups = _controller.categoryGroups;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categoryGroups.map((group) {
              return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xffFFF4F1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      width: 1.2,
                      color: const Color(0xffDB0025).withOpacity(0.55),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffDB0025).withOpacity(0.14),
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
                          color: Color(0xffDB0025),
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
                                  color: const Color(0xffFFE8E1),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: const Color(0xffDB0025)
                                        .withOpacity(0.3),
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
                  ));
            }).toList(),
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  ctv?.title ?? '',
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
            ctv?.description ?? '',
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

  Widget _buildctvDetail(BuildContext context) {
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
          Divider(
            height: 1,
            color: const Color(0xff273143).withOpacity(0.1),
          ),
          const SizedBox(height: 12),
          _buildComponentDetail(context, 5),
        ],
      ),
    );
  }

  Widget _buildComponentDetail(BuildContext context, int position) {
    final ctv = _controller.recruitment.value;

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
                      ? AssetPath.ctv
                      : position == 4
                          ? AssetPath.organizationIcon
                          : AssetPath.networkIcon,
          color: const Color(0xffDB0025),
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
                                  ? 'Vị trí'
                                  : position == 4
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
                        mapUrl: ctv?.venue?.mapUrl,
                        latitude: ctv?.venue?.latitude,
                        longitude: ctv?.venue?.longitude,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xffDB0025).withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.directions,
                          size: 18,
                          color: Color(0xffDB0025),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              position != 5
                  ? Text(
                      position == 1
                          ? AppDateUtils.formatDateTime(ctv?.startTime)
                          : position == 2
                              ? ctv?.venue?.name ?? ''
                              : position == 3
                                  ? ctv?.roleName ?? ''
                                  : ctv?.organizerName ?? '',
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
                              '${_controller.remainingSlots} / ${_controller.quantity}',
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
                                color: const Color(0xffDB0025),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${_controller.recruitedPercent}% đã ứng tuyển',
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
                            value: _controller.recruitedProgress,
                            minHeight: 8,
                            backgroundColor: const Color(0xffF5F5F5),
                            borderRadius: BorderRadius.circular(16),
                            valueColor:
                                const AlwaysStoppedAnimation(Color(0xffDB0025)),
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
        color: const Color(0xffDB0025).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1.71,
          color: const Color(0xffDB0025).withOpacity(0.2),
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
          color: const Color(0xffDB0025),
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
    final actionState = _controller.actionState;
    final recruitment = _controller.recruitment.value;

    return GestureDetector(
      onTap: actionState.isEnabled
          ? () {
              final recruitmentId = recruitment?.ctvRecruitmentId;
              if (recruitmentId == null) return;

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => CtvApplyBottomSheet(
                  ctvRecruitmentId: recruitmentId,
                  eventId: recruitment?.eventId,
                  position: recruitment?.roleName,
                  onSubmitted: _controller.reloadApplicationStatus,
                ),
              );
            }
          : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 42,
        decoration: BoxDecoration(
          color: actionState.isEnabled
              ? const Color(0xffDB0025)
              : const Color(0xffB0B4C0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
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
  }

  Widget _buildGoToEventButton() {
    final eventId = _controller.recruitment.value?.eventId;
    if (eventId == null) return const SizedBox.shrink();

    final isOrganizer =
        AuthController.to.currentUser.value?.role == UserRole.organization;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: GestureDetector(
        onTap: () => Get.to(
          () => isOrganizer
              ? OrganizerEventDetailPage(eventId: eventId)
              : EventDetailPage(eventId: eventId),
        ),
        child: Container(
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xff06B6D4)),
          ),
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event, size: 16, color: Color(0xff06B6D4)),
                SizedBox(width: 6),
                Text(
                  'Xem chi tiết sự kiện',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff06B6D4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
