import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/attendance/domain/usecase/attendance_usecase.dart';
import 'package:events_app/feature/attendance/domain/usecase/scan_qr_params.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/common/utils/app_distance_utils.dart';
import 'package:events_app/common/utils/app_location_service.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/feedback/domain/entity/feedback_entity.dart';
import 'package:events_app/feature/feedback/domain/usecase/feedback_usecase.dart';
import 'package:events_app/feature/feedback/domain/usecase/feedback_usecase_params.dart';
import 'package:events_app/feature/feedback/domain/usecase/submit_feedback_params.dart';
import 'package:events_app/feature/feedback/presentation/controller/feedback_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckOutContext {
  final int eventParticipantId;
  final String qrContent;
  final double? latitude;
  final double? longitude;
  final double? venueLat;
  final double? venueLng;

  const CheckOutContext({
    required this.eventParticipantId,
    required this.qrContent,
    this.latitude,
    this.longitude,
    this.venueLat,
    this.venueLng,
  });
}

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({
    super.key,
    required this.eventId,
    this.eventTitle,
    this.onSubmitted,
    this.checkOutContext,
  });

  final int eventId;
  final String? eventTitle;
  final VoidCallback? onSubmitted;

  final CheckOutContext? checkOutContext;

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final FeedbackController _controller = FeedbackController.ensureInstance();
  final TextEditingController _commentController = TextEditingController();
  final AppLocationService _locationService = AppLocationService();

  late final SelfCheckInUsecase _checkOutUsecase;

  @override
  void initState() {
    super.initState();
    _checkOutUsecase = networkGetIt<SelfCheckInUsecase>();
    _controller.loadQuestions(widget.eventId);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xff06B6D4),
        elevation: 0,
        title: Text(
          widget.eventTitle ?? 'Đánh giá sự kiện',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xff06B6D4),
            ),
          );
        }

        if (_controller.hasSubmitted.value) {
          return _buildSuccessState();
        }

        if (_controller.questions.isEmpty) {
          return _buildNoQuestionsState();
        }

        return _buildFeedbackForm();
      }),
    );
  }

  Widget _buildSuccessState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xffDCFCE7),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.check_circle,
                size: 60,
                color: Color(0xff22C55E),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Cảm ơn bạn!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xff273143),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Phản hồi của bạn đã được gửi thành công.\nChúng tôi sẽ cải thiện để mang lại\ntrải nghiệm tốt hơn.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xff67688C),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onSubmitted?.call();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff06B6D4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Quay lại',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoQuestionsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xffF0F0F0),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.question_answer_outlined,
                size: 40,
                color: Color(0xffB0B4C0),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Chưa có câu hỏi đánh giá',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xff273143),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sự kiện này chưa có câu hỏi đánh giá nào.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff67688C),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xff06B6D4),
                  side: const BorderSide(color: Color(0xff06B6D4)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Quay lại'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 16),
                ..._buildQuestionList(),
                const SizedBox(height: 16),
                _buildCommentSection(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xff06B6D4).withValues(alpha: 0.1),
            const Color(0xff06B6D4).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xff06B6D4).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xff06B6D4).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.rate_review,
              color: Color(0xff06B6D4),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đánh giá sự kiện',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff273143),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Phản hồi của bạn giúp chúng tôi cải thiện',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff67688C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildQuestionList() {
    final questions = _controller.questions;

    return questions.map((question) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    question.questionContent ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff273143),
                    ),
                  ),
                ),
                if (question.isRequired == true)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xffEF4444).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Bắt buộc',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffEF4444),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildQuestionInput(question),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildQuestionInput(FeedbackQuestionEntity question) {
    switch (question.questionType) {
      case FeedbackQuestionType.rating:
        return _buildRatingInput(question);
      case FeedbackQuestionType.text:
        return _buildTextInput(question);
      case FeedbackQuestionType.singleChoice:
        return _buildSingleChoiceInput(question);
      case FeedbackQuestionType.multipleChoice:
        return _buildMultipleChoiceInput(question);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRatingInput(FeedbackQuestionEntity question) {
    const maxRating = 5;
    final currentRating = int.tryParse(_controller.answers[question.feedbackQuestionId] ?? '');

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(maxRating, (index) {
            final rating = index + 1;
            final isSelected = currentRating != null && rating <= currentRating;

            return GestureDetector(
              onTap: () {
                _controller.setAnswer(
                  question.feedbackQuestionId!,
                  rating.toString(),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  isSelected ? Icons.star : Icons.star_border,
                  size: 40,
                  color: isSelected
                      ? const Color(0xffF59E0B)
                      : const Color(0xffD1D5DB),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          currentRating != null ? '$currentRating / $maxRating' : 'Nhấn để đánh giá',
          style: TextStyle(
            fontSize: 13,
            color: currentRating != null
                ? const Color(0xffF59E0B)
                : const Color(0xffB0B4C0),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTextInput(FeedbackQuestionEntity question) {
    return TextField(
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Nhập câu trả lời của bạn...',
        hintStyle: const TextStyle(
          color: Color(0xffB0B4C0),
          fontSize: 14,
        ),
        filled: true,
        fillColor: const Color(0xffF8F9FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      onChanged: (value) {
        _controller.setAnswer(question.feedbackQuestionId!, value);
      },
    );
  }

  Widget _buildSingleChoiceInput(FeedbackQuestionEntity question) {
    final options = question.options ?? [];
    final selectedId = _controller.selectedOptions[question.feedbackQuestionId]?.firstOrNull;

    return Column(
      children: options.map((option) {
        final isSelected = selectedId == option.optionId;

        return GestureDetector(
          onTap: () {
            if (option.optionId != null) {
              _controller.selectSingleOption(question.feedbackQuestionId!, option.optionId!);
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xff06B6D4).withValues(alpha: 0.1)
                  : const Color(0xffF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xff06B6D4)
                    : const Color(0xffE5E7EB),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? const Color(0xff06B6D4) : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? const Color(0xff06B6D4) : const Color(0xffD1D5DB),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 12,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option.optionValue ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? const Color(0xff06B6D4) : const Color(0xff273143),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMultipleChoiceInput(FeedbackQuestionEntity question) {
    final options = question.options ?? [];
    final selectedIds = _controller.selectedOptions[question.feedbackQuestionId] ?? [];

    return Column(
      children: options.map((option) {
        final isSelected = selectedIds.contains(option.optionId);

        return GestureDetector(
          onTap: () {
            if (option.optionId != null) {
              _controller.toggleOption(question.feedbackQuestionId!, option.optionId!);
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xff06B6D4).withValues(alpha: 0.1)
                  : const Color(0xffF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xff06B6D4)
                    : const Color(0xffE5E7EB),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: isSelected ? const Color(0xff06B6D4) : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? const Color(0xff06B6D4) : const Color(0xffD1D5DB),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option.optionValue ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? const Color(0xff06B6D4) : const Color(0xff273143),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCommentSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.comment_outlined,
                size: 20,
                color: Color(0xff06B6D4),
              ),
              SizedBox(width: 8),
              Text(
                'Góp ý thêm (không bắt buộc)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff273143),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _commentController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Chia sẻ cảm nhận của bạn về sự kiện...',
              hintStyle: const TextStyle(
                color: Color(0xffB0B4C0),
                fontSize: 14,
              ),
              filled: true,
              fillColor: const Color(0xffF8F9FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            onChanged: (value) {
              _controller.setComment(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Obx(() {
        final canSubmit = _controller.canSubmit;
        final isSubmitting = _controller.isSubmitting.value;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canSubmit && !isSubmitting
                ? () => _handleSubmitWithCheckOut()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: canSubmit
                  ? const Color(0xff06B6D4)
                  : const Color(0xffB0B4C0),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: isSubmitting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    widget.checkOutContext != null
                        ? 'Gửi đánh giá & Check-out'
                        : 'Gửi đánh giá',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      }),
    );
  }

  Future<void> _handleSubmitWithCheckOut() async {
    if (widget.checkOutContext == null) {
      await _controller.submitFeedback();
      return;
    }

    await _controller.submitFeedback();

    if (!_controller.hasSubmitted.value) return;

    final ctx = widget.checkOutContext!;

    final locationResult = await _locationService.getCurrentLocation();
    final currentLat = locationResult.coords?.latitude ?? ctx.latitude;
    final currentLng = locationResult.coords?.longitude ?? ctx.longitude;

    if (currentLat != null &&
        currentLng != null &&
        ctx.venueLat != null &&
        ctx.venueLng != null) {
      final withinRadius = isWithinRadius(
        userLat: currentLat,
        userLng: currentLng,
        targetLat: ctx.venueLat!,
        targetLng: ctx.venueLng!,
        radiusMeters: 1000,
      );
      if (!withinRadius) {
        AppSnackbarUtils.showError(
          'Ngoài phạm vi',
          'Bạn đang ở ngoài bán kính 1km. Không thể check-out.',
        );
        return;
      }
    }

    final result = await _checkOutUsecase(ScanQrParams(
      eventParticipantId: ctx.eventParticipantId,
      qrContent: ctx.qrContent,
      latitude: currentLat,
      longitude: currentLng,
    ));

    result.fold(
      (failure) {
        AppSnackbarUtils.showError(
          'Thất bại',
          'Check-out thất bại. Vui lòng thử lại.',
        );
      },
      (scanData) {
        widget.onSubmitted?.call();
      },
    );
  }
}
