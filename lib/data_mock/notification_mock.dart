import 'package:events_app/feature/common/notifications_controller.dart';

final List<NotificationItem> notificationMock = [
  NotificationItem(
    id: '1',
    title: 'Xác nhận tham dự sự kiện',
    body: 'Bạn đã xác nhận tham dự sự kiện "Hội thảo Công nghệ AI 2025". Cảm ơn bạn đã tham gia!',
    timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    category: 'event',
  ),
  NotificationItem(
    id: '2',
    title: 'Nhắc nhở sự kiện sắp diễn ra',
    body: 'Sự kiện "Workshop Kỹ năng mềm" sẽ diễn ra trong 2 giờ nữa. Đừng quên check-in!',
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    category: 'event',
  ),
  NotificationItem(
    id: '3',
    title: 'Xếp hạng của bạn đã được cập nhật',
    body: 'Chúc mừng! Bạn đã thăng lên cấp "Thợ săn" với 2,500 xu tích lũy.',
    timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    category: 'system',
  ),
  NotificationItem(
    id: '4',
    title: 'Thanh toán thành công',
    body: 'Thanh toán gói Premium Monthly đã được xử lý thành công. Gói sẽ hết hạn vào ngày 23/05/2026.',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    category: 'payment',
  ),
  NotificationItem(
    id: '5',
    title: 'Yêu cầu cộng tác viên được chấp nhận',
    body: 'Đơn ứng tuyển CTV của bạn cho sự kiện "Lễ hội Văn hóa 2025" đã được chấp nhận.',
    timestamp: DateTime.now().subtract(const Duration(days: 2)),
    category: 'event',
  ),
  NotificationItem(
    id: '6',
    title: 'Sự kiện bạn quan tâm đã được công bố',
    body: 'Sự kiện mới "Cuộc thi Khởi nghiệp Sinh viên 2026" vừa được đăng tải. Xem ngay!',
    timestamp: DateTime.now().subtract(const Duration(days: 3)),
    category: 'event',
  ),
  NotificationItem(
    id: '7',
    title: 'Gói dịch vụ sắp hết hạn',
    body: 'Gói Premium của bạn sẽ hết hạn trong 3 ngày. Hãy gia hạn để tiếp tục sử dụng.',
    timestamp: DateTime.now().subtract(const Duration(days: 4)),
    category: 'payment',
  ),
  NotificationItem(
    id: '8',
    title: 'Phản hồi từ ban tổ chức',
    body: 'Ban tổ chức sự kiện "Hội thảo AI" đã trả lời câu hỏi của bạn.',
    timestamp: DateTime.now().subtract(const Duration(days: 5)),
    category: 'event',
  ),
  NotificationItem(
    id: '9',
    title: 'Bạn nhận được một badge mới',
    body: 'Chúc mừng! Bạn đã hoàn thành 5 sự kiện và nhận được badge "Người tham dự tích cực".',
    timestamp: DateTime.now().subtract(const Duration(days: 7)),
    category: 'system',
  ),
  NotificationItem(
    id: '10',
    title: 'Cảm ơn bạn đã đánh giá sự kiện',
    body: 'Cảm ơn bạn đã để lại đánh giá cho sự kiện "Workshop Kỹ năng mềm".',
    timestamp: DateTime.now().subtract(const Duration(days: 10)),
    category: 'system',
  ),
];
