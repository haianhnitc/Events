import 'dart:async';

import 'package:events_app/authentication/domain/auth_constants.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/authentication/presentation/pages/login_screen.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerRejectedScreen extends StatefulWidget {
  const OrganizerRejectedScreen({super.key});

  @override
  State<OrganizerRejectedScreen> createState() =>
      _OrganizerRejectedScreenState();
}

class _OrganizerRejectedScreenState extends State<OrganizerRejectedScreen> {
  late final AuthController _authController;
  late final StreamSubscription<AuthEvent> _authEventSubscription;

  @override
  void initState() {
    super.initState();
    _authController = AuthController.to;
    _authEventSubscription =
        _authController.authEvents.listen(_handleAuthEvent);
  }

  @override
  void dispose() {
    _authEventSubscription.cancel();
    super.dispose();
  }

  void _handleAuthEvent(AuthEvent event) {
    if (event == AuthEvent.logoutComplete ||
        event == AuthEvent.sessionExpired) {
      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => _confirmBack(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xff273143)),
        ),
        title: const Text(
          'Hồ sơ bị từ chối',
          style: TextStyle(
            color: Color(0xff273143),
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAlertBanner(),
              const SizedBox(height: 24),
              _buildInstructionCard(),
              const SizedBox(height: 16),
              _buildDocumentSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffFECACA)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xffFEE2E2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cancel_outlined,
              color: Color(0xffDC2626),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hồ sơ xác minh bị từ chối',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff991B1B),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Vui lòng cập nhật tài liệu mới và gửi lại để được xét duyệt.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xffB91C1C),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xff06B6D4), size: 20),
              SizedBox(width: 8),
              Text(
                'Hướng dẫn',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff273143),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInstructionItem(
              '1', 'Xem lại các tài liệu đã tải lên trước đó'),
          const SizedBox(height: 8),
          _buildInstructionItem('2', 'Thêm tài liệu mới để bổ sung minh chứng'),
          const SizedBox(height: 8),
          _buildInstructionItem('3', 'Nhấn "Gửi lại" để yêu cầu xét duyệt'),
          const SizedBox(height: 8),
          _buildInstructionItem(
              '4', 'Chờ quản trị viên xét duyệt trong 1-3 ngày làm việc'),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Color(0xff06B6D4),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xff67688C),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tài liệu minh chứng',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xff273143),
              ),
            ),
            TextButton.icon(
              onPressed: () => _showDocumentTypePicker(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Thêm tài liệu'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xff06B6D4),
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildDocumentList(),
        const SizedBox(height: 24),
        _buildResubmitButton(),
      ],
    );
  }

  Widget _buildDocumentList() {
    return Obx(() {
      final docs = _authController.uploadedVerificationDocs;

      if (docs.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xfff8fafc),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Icon(Icons.folder_open_outlined,
                  size: 40, color: Colors.grey.shade400),
              const SizedBox(height: 8),
              Text(
                'Chưa có tài liệu nào',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Nhấn "Thêm tài liệu" để tải lên',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        children: docs.map((doc) => _buildDocumentItem(doc)).toList(),
      );
    });
  }

  Widget _buildDocumentItem(Map<String, dynamic> doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xffe0f2fe),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: Color(0xff06B6D4),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc['fileName'] ?? 'Tài liệu',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff273143),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  doc['type'] ?? 'Tài liệu xác minh',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _authController.removeVerificationDoc(doc['id']),
            icon: Icon(Icons.close, size: 18, color: Colors.grey.shade400),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildResubmitButton() {
    return Obx(() {
      final docs = _authController.uploadedVerificationDocs;
      final isLoading = _authController.isLoadingEmail.value;

      return SizedBox(
        height: 48,
        child: ElevatedButton(
          onPressed:
              docs.isEmpty || isLoading ? null : () => _handleResubmit(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff06B6D4),
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade300,
            disabledForegroundColor: Colors.grey.shade500,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Gửi lại để xét duyệt',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
        ),
      );
    });
  }

  void _handleResubmit(BuildContext context) {
    final docs = _authController.uploadedVerificationDocs;

    if (docs.isEmpty) {
      AppSnackbarUtils.showError(
        'Thiếu tài liệu',
        'Vui lòng thêm ít nhất 1 tài liệu minh chứng.',
      );
      return;
    }

    AppSnackbarUtils.showSuccess(
      'Hoàn tất',
      'Đã gửi yêu cầu xét duyệt. Vui lòng chờ quản trị viên xử lý.',
    );
    _authController.emitAuthEvent(AuthEvent.organizerPending);
  }

  void _showDocumentTypePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Chọn loại tài liệu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff273143),
              ),
            ),
            const SizedBox(height: 16),
            _buildDocTypeOption(
              'Giấy phép kinh doanh',
              Icons.business,
              () {
                Navigator.pop(ctx);
                _authController.uploadVerificationDocument('BUSINESS_LICENSE');
              },
            ),
            _buildDocTypeOption(
              'Quyết định của trường đại học',
              Icons.school,
              () {
                Navigator.pop(ctx);
                _authController
                    .uploadVerificationDocument('UNIVERSITY_DECISION');
              },
            ),
            _buildDocTypeOption(
              'Giấy phép thành lập câu lạc bộ',
              Icons.groups,
              () {
                Navigator.pop(ctx);
                _authController.uploadVerificationDocument('CLUB_CERTIFICATE');
              },
            ),
            _buildDocTypeOption(
              'Mã số thuế',
              Icons.receipt_long,
              () {
                Navigator.pop(ctx);
                _authController.uploadVerificationDocument('TAX_CODE');
              },
            ),
            _buildDocTypeOption(
              'Loại khác',
              Icons.folder,
              () {
                Navigator.pop(ctx);
                _authController.uploadVerificationDocument('OTHER');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildDocTypeOption(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: const Color(0xff64748B)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 14, color: Color(0xff273143)),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  void _confirmBack(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Xác nhận thoát'),
        content: const Text(
          'Bạn có tài liệu chưa được lưu. Thoát bây giờ sẽ không mất dữ liệu đã tải lên.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Get.back();
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xffDB0025),
            ),
            child: const Text('Thoát'),
          ),
        ],
      ),
    );
  }
}
