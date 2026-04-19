import 'package:flutter/material.dart';

class TermsOfServiceDialog extends StatelessWidget {
  const TermsOfServiceDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const TermsOfServiceDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xffe0f2fe),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: Color(0xff06B6D4),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Điều khoản dịch vụ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xff273143),
              ),
            ),
          ),
        ],
      ),
      content: const SizedBox(
        width: double.maxFinite,
        height: 500,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TermsSection(
                title: '1. Giới thiệu',
                content:
                    'Chào mừng bạn đến với ứng dụng Events App – nền tảng kết nối người tổ chức sự kiện và người tham gia. Khi sử dụng ứng dụng, bạn đồng ý tuân thủ các điều khoản dưới đây. Nếu không đồng ý, vui lòng không sử dụng dịch vụ.',
              ),
              _SectionGap(),
              _TermsSection(
                title: '2. Tài khoản người dùng',
                content:
                    '• Đăng ký tài khoản với thông tin chính xác, trung thực.\n'
                    '• Bảo mật thông tin đăng nhập (email, mật khẩu). Bạn chịu trách nhiệm hoàn toàn về mọi hoạt động diễn ra dưới tài khoản của mình.\n'
                    '• Không chia sẻ tài khoản cho người khác.\n'
                    '• Thông báo ngay cho chúng tôi nếu phát hiện tài khoản bị truy cập trái phép.\n'
                    '• Người tổ chức sự kiện cần xác minh danh tính tổ chức trước khi tạo sự kiện công khai.',
              ),
              _SectionGap(),
              _TermsSection(
                title: '3. Dành cho người tham gia sự kiện',
                content:
                    '• Đăng ký tham gia sự kiện một cách trung thực và có trách nhiệm.\n'
                    '• Tham dự đúng thời gian, địa điểm đã đăng ký.\n'
                    '• Tuân thủ nội quy và quy định của từng sự kiện.\n'
                    '• Không hủy đăng ký liên tục nếu không có lý do chính đáng.\n'
                    '• Quét QR code điểm danh đúng thời gian quy định để xác nhận tham dự.\n'
                    '• Cư xử văn minh, lịch sự với người tổ chức và những người tham gia khác.',
              ),
              _SectionGap(),
              _TermsSection(
                title: '4. Dành cho người tổ chức sự kiện',
                content:
                    '• Cung cấp thông tin sự kiện chính xác, đầy đủ (tên, thời gian, địa điểm, mô tả).\n'
                    '• Đảm bảo sự kiện không vi phạm pháp luật, không có nội dung lừa đảo, phản động, đồi trụy.\n'
                    '• Chịu trách nhiệm quản lý danh sách người tham gia và điểm danh.\n'
                    '• Xử lý phản hồi (feedback) từ người tham dự một cách nghiêm túc.\n'
                    '• Không thu phí tham gia sự kiện trái quy định hoặc lừa đảo người tham gia.\n'
                    '• Mọi sự kiện công khai cần được xác minh danh tính tổ chức trước khi đăng tải.',
              ),
              _SectionGap(),
              _TermsSection(
                title: '5. Cộng tác viên (CTV)',
                content:
                    '• CTV là người được người tổ chức mời hỗ trợ quản lý sự kiện.\n'
                    '• CTV có quyền hạn theo phân công của người tổ chức (điểm danh, quản lý feedback).\n'
                    '• CTV không được lạm dụng quyền hạn để thu thập thông tin người tham dự.\n'
                    '• CTV cam kết bảo mật thông tin sự kiện và danh sách người tham gia.',
              ),
              _SectionGap(),
              _TermsSection(
                title: '6. Nội dung do người dùng tạo (UGC)',
                content:
                    '• Bạn giữ bản quyền nội dung bạn đăng tải trên ứng dụng.\n'
                    '• Khi đăng tải nội dung, bạn cho phép chúng tôi sử dụng để hiển thị trong ứng dụng.\n'
                    '• Không đăng tải nội dung vi phạm quyền sở hữu trí tuệ, bản quyền của người khác.\n'
                    '• Chúng tôi có quyền gỡ bỏ nội dung không phù hợp mà không cần thông báo trước.',
              ),
              _SectionGap(),
              _TermsSection(
                title: '7. Thanh toán',
                content:
                    '• Nếu sự kiện có thu phí, mọi giao dịch thanh toán được xử lý qua cổng thanh toán tích hợp.\n'
                    '• Chúng tôi không lưu trữ thông tin thẻ thanh toán của bạn.\n'
                    '• Người tổ chức chịu trách nhiệm hoàn tiền theo chính sách riêng của sự kiện.\n'
                    '• Báo cáo ngay nếu phát hiện giao dịch bất thường.',
              ),
              _SectionGap(),
              _TermsSection(
                title: '8. Quyền và nghĩa vụ của chúng tôi',
                content:
                    '• Cung cấp và duy trì hoạt động của ứng dụng một cách ổn định.\n'
                    '• Bảo mật dữ liệu cá nhân theo Chính sách bảo mật.\n'
                    '• Có quyền tạm khóa hoặc xóa tài khoản vi phạm điều khoản.\n'
                    '• Có quyền cập nhật, thay đổi điều khoản và thông báo cho người dùng.\n'
                    '• Không chịu trách nhiệm về tranh chấp trực tiếp giữa người tổ chức và người tham gia.',
              ),
              _SectionGap(),
              _TermsSection(
                title: '9. Giới hạn trách nhiệm',
                content:
                    '• Chúng tôi không đảm bảo sự kiện diễn ra đúng như mô tả; người tổ chức chịu trách nhiệm.\n'
                    '• Không chịu trách nhiệm về thiệt hại phát sinh từ việc sử dụng hoặc không thể sử dụng ứng dụng.\n'
                    '• Không chịu trách nhiệm về hành vi của người dùng trong và ngoài ứng dụng.',
              ),
              _SectionGap(),
              _TermsSection(
                title: '10. Chấm dứt dịch vụ',
                content:
                    '• Bạn có thể xóa tài khoản và ngừng sử dụng bất cứ lúc nào.\n'
                    '• Chúng tôi có thể tạm khóa hoặc xóa tài khoản vi phạm điều khoản mà không cần thông báo.\n'
                    '• Sau khi xóa tài khoản, dữ liệu của bạn sẽ được xử lý theo Chính sách bảo mật.',
              ),
              _SectionGap(),
              _TermsSection(
                title: '11. Thay đổi điều khoản',
                content:
                    'Chúng tôi có quyền cập nhật Điều khoản dịch vụ theo thời gian. Phiên bản mới sẽ được đăng tải trên ứng dụng với thông báo rõ ràng. Việc tiếp tục sử dụng sau khi cập nhật đồng nghĩa với việc bạn chấp nhận các điều khoản mới.',
              ),
              _SectionGap(),
              _TermsSection(
                title: '12. Liên hệ',
                content:
                    'Nếu có thắc mắc về Điều khoản dịch vụ, vui lòng liên hệ qua:\n'
                    '• Email: support@eventsapp.com\n'
                    '• Hotline: 1900 xxxx\n'
                    '• Địa chỉ: [Địa chỉ công ty]',
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff06B6D4),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Đã đọc và đồng ý', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }
}

class PrivacyPolicyDialog extends StatelessWidget {
  const PrivacyPolicyDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const PrivacyPolicyDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xffe0f2fe),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.privacy_tip_outlined,
              color: Color(0xff06B6D4),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Chính sách bảo mật',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xff273143),
              ),
            ),
          ),
        ],
      ),
      content: const SizedBox(
        width: double.maxFinite,
        height: 500,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TermsSection(
                title: '1. Thông tin chúng tôi thu thập',
                content:
                    'Khi bạn sử dụng Events App, chúng tôi thu thập các thông tin sau:\n\n'
                    '• Thông tin đăng ký: Họ tên, email, số điện thoại, mật khẩu (đã mã hóa).\n'
                    '• Thông tin hồ sơ: Ảnh đại diện, ngày sinh, giới tính, mã sinh viên, trường đại học, khoa, ngành (nếu có).\n'
                    '• Thông tin tổ chức: Tên tổ chức, loại hình, địa chỉ, mô tả, logo, giấy phép xác minh (đối với người tổ chức).\n'
                    '• Thông tin sự kiện: Tên, mô tả, thời gian, địa điểm, hình ảnh, danh sách người tham gia.\n'
                    '• Dữ liệu điểm danh: Thời gian quét QR, trạng thái tham dự.\n'
                    '• Phản hồi (feedback): Nội dung đánh giá, xếp hạng sự kiện.\n'
                    '• Dữ liệu kỹ thuật: Thiết bị sử dụng, hệ điều hành, địa chỉ IP, logs hoạt động.\n'
                    '• Dữ liệu từ bên thứ ba: Thông tin từ Google khi bạn đăng nhập bằng Google Account.',
              ),
              _SectionGap(),
              _TermsSection(
                title: '2. Mục đích sử dụng dữ liệu',
                content:
                    'Chúng tôi sử dụng dữ liệu của bạn cho các mục đích:\n\n'
                    '• Tạo và quản lý tài khoản người dùng.\n'
                    '• Kết nối người tổ chức và người tham gia sự kiện.\n'
                    '• Xác minh danh tính người tổ chức và CTV.\n'
                    '• Điểm danh và xác nhận tham dự sự kiện.\n'
                    '• Gửi thông báo về sự kiện bạn đăng ký hoặc tổ chức.\n'
                    '• Thu thập và hiển thị phản hồi từ người tham dự.\n'
                    '• Cải thiện trải nghiệm người dùng trên ứng dụng.\n'
                    '• Xử lý thanh toán (nếu có).\n'
                    '• Tuân thủ nghĩa vụ pháp lý.',
              ),
              _SectionGap(),
              _TermsSection(
                title: '3. Cơ sở pháp lý cho việc xử lý dữ liệu',
                content:
                    'Chúng tôi xử lý dữ liệu của bạn dựa trên:\n\n'
                    '• Sự đồng ý của bạn khi đăng ký và sử dụng ứng dụng.\n'
                    '• Việc thực hiện hợp đồng giữa bạn và chúng tôi (cung cấp dịch vụ).\n'
                    '• Lợi ích hợp pháp của chúng tôi trong việc vận hành và cải thiện dịch vụ.\n'
                    '• Nghĩa vụ pháp lý (lưu trữ dữ liệu theo quy định).',
              ),
              _SectionGap(),
              _TermsSection(
                title: '4. Chia sẻ dữ liệu với bên thứ ba',
                content:
                    'Chúng tôi KHÔNG bán dữ liệu cá nhân của bạn. Dữ liệu chỉ được chia sẻ trong các trường hợp:\n\n'
                    '• Người tổ chức sự kiện: Thông tin cá nhân của bạn (họ tên, email) được chia sẻ với người tổ chức khi bạn đăng ký tham gia sự kiện của họ.\n'
                    '• Cộng tác viên (CTV): Thông tin cần thiết được chia sẻ để CTV hỗ trợ quản lý sự kiện.\n'
                    '• Người tham dự khác: Thông tin công khai (họ tên, ảnh đại diện) có thể hiển thị trong danh sách tham dự sự kiện công cộng.\n'
                    '• Nhà cung cấp dịch vụ: Dịch vụ lưu trữ đám mây, Firebase, cổng thanh toán – theo hợp đồng bảo mật.\n'
                    '• Yêu cầu pháp lý: Cung cấp cho cơ quan có thẩm quyền khi được yêu cầu theo quy định pháp luật.\n'
                    '• Chuyển nhượng doanh nghiệp: Trong trường hợp sáp nhập, mua lại, chúng tôi có thể chuyển giao dữ liệu cho bên nhận chuyển nhượng.',
              ),
              _SectionGap(),
              _TermsSection(
                title: '5. Thời gian lưu trữ dữ liệu',
                content:
                    '• Dữ liệu tài khoản: Lưu trữ cho đến khi bạn yêu cầu xóa tài khoản.\n'
                    '• Dữ liệu sự kiện và điểm danh: Lưu trữ trong thời gian hoạt động của sự kiện và 12 tháng sau khi sự kiện kết thúc.\n'
                    '• Dữ liệu phản hồi (feedback): Lưu trữ vĩnh viễn để phục vụ thống kê và cải thiện chất lượng sự kiện.\n'
                    '• Logs hệ thống: Lưu trữ tối đa 12 tháng.\n'
                    '• Dữ liệu thanh toán: Lưu trữ theo quy định kế toán (tối thiểu 5 năm).',
              ),
              _SectionGap(),
              _TermsSection(
                title: '6. Quyền của bạn',
                content:
                    'Bạn có các quyền sau đối với dữ liệu cá nhân của mình:\n\n'
                    '• Quyền truy cập: Xem toàn bộ dữ liệu cá nhân chúng tôi lưu trữ về bạn.\n'
                    '• Quyền chỉnh sửa: Cập nhật, sửa đổi thông tin cá nhân bất cứ lúc nào trong phần "Tài khoản".\n'
                    '• Quyền xóa: Yêu cầu xóa tài khoản và toàn bộ dữ liệu liên quan.\n'
                    '• Quyền hạn chế xử lý: Yêu cầu chúng tôi tạm ngừng xử lý dữ liệu trong một số trường hợp.\n'
                    '• Quyền phản đối: Phản đối việc xử lý dữ liệu cho mục đích tiếp thị.\n'
                    '• Quyền di chuyển dữ liệu: Yêu cầu xuất dữ liệu của bạn dưới dạng phổ biến.\n'
                    '• Quyền khiếu nại: Khiếu nại với cơ quan bảo vệ dữ liệu nếu bạn cho rằng quyền của mình bị vi phạm.\n\n'
                    'Để thực hiện quyền của mình, vui lòng liên hệ: support@eventsapp.com',
              ),
              _SectionGap(),
              _TermsSection(
                title: '7. Bảo mật dữ liệu',
                content:
                    'Chúng tôi áp dụng các biện pháp bảo mật sau:\n\n'
                    '• Mã hóa dữ liệu: Dữ liệu nhạy cảm (mật khẩu) được mã hóa bằng thuật toán một chiều (bcrypt). Dữ liệu truyền tải qua mạng được mã hóa bằng SSL/TLS.\n'
                    '• Kiểm soát truy cập: Chỉ nhân viên được ủy quyền mới có thể truy cập dữ liệu người dùng.\n'
                    '• Xác thực: Firebase Authentication để xác thực người dùng.\n'
                    '• Sao lưu định kỳ: Dữ liệu được sao lưu định kỳ để phòng trường hợp mất dữ liệu.\n'
                    '• Đánh giá bảo mật: Thường xuyên rà soát và cập nhật các biện pháp bảo mật.',
              ),
              _SectionGap(),
              _TermsSection(
                title: '8. Cookies và công nghệ tương tự',
                content:
                    'Ứng dụng không sử dụng cookie truyền thống. Tuy nhiên, chúng tôi sử dụng:\n\n'
                    '• Firebase Analytics: Thu thập dữ liệu sử dụng ứng dụng ẩn danh để cải thiện trải nghiệm.\n'
                    '• Local Storage: Lưu trữ cài đặt và preferences trên thiết bị của bạn.\n'
                    '• Push Notifications: Gửi thông báo qua Firebase Cloud Messaging.',
              ),
              _SectionGap(),
              _TermsSection(
                title: '9. Dữ liệu của trẻ vị thành niên',
                content:
                    'Ứng dụng không dành cho trẻ em dưới 16 tuổi. Chúng tôi không cố ý thu thập dữ liệu cá nhân của trẻ dưới 16 tuổi. Nếu phát hiện dữ liệu của trẻ dưới 16 tuổi được thu thập, chúng tôi sẽ xóa ngay lập tức.',
              ),
              _SectionGap(),
              _TermsSection(
                title: '10. Thay đổi chính sách bảo mật',
                content:
                    'Chúng tôi có thể cập nhật Chính sách bảo mật định kỳ. Khi có thay đổi quan trọng, chúng tôi sẽ:\n\n'
                    '• Thông báo trong ứng dụng (banner hoặc thông báo).\n'
                    '• Cập nhật ngày "Cập nhật lần cuối" bên dưới.\n'
                    '• Yêu cầu bạn xác nhận lại khi đăng nhập lần đầu sau khi có thay đổi.\n\n'
                    'Cập nhật lần cuối: 15/04/2026',
              ),
              _SectionGap(),
              _TermsSection(
                title: '11. Liên hệ',
                content:
                    'Nếu có thắc mắc về Chính sách bảo mật, vui lòng liên hệ:\n\n'
                    '• Email: support@eventsapp.com\n'
                    '• Hotline: 1900 xxxx\n'
                    '• Địa chỉ: [Địa chỉ công ty]\n\n'
                    'Chúng tôi sẽ phản hồi trong vòng 72 giờ làm việc.',
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff06B6D4),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Đã đọc', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }
}

class _TermsSection extends StatelessWidget {
  final String title;
  final String content;

  const _TermsSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xff273143),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xff64748B),
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _SectionGap extends StatelessWidget {
  const _SectionGap();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 16);
  }
}
