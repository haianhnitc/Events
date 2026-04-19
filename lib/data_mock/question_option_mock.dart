import 'package:events_app/feature/recruitment/domain/entity/question_option_entity.dart';

final List<QuestionOptionEntity> questionOptionMock = [
  // Recruitment 1 - CTV hỗ trợ check-in
  QuestionOptionEntity(
      optionId: 10011, questionId: 1001, optionValue: '1-2 sự kiện'),
  QuestionOptionEntity(
      optionId: 10012, questionId: 1001, optionValue: '3-5 sự kiện'),
  QuestionOptionEntity(
      optionId: 10013, questionId: 1001, optionValue: 'Trên 5 sự kiện'),
  QuestionOptionEntity(
      optionId: 10021, questionId: 1002, optionValue: 'Sáng sớm'),
  QuestionOptionEntity(
      optionId: 10022, questionId: 1002, optionValue: 'Cả ngày'),
  QuestionOptionEntity(
      optionId: 10023, questionId: 1002, optionValue: 'Chiều tối'),

  // Recruitment 2 - CTV hỗ trợ nội dung
  QuestionOptionEntity(optionId: 20011, questionId: 2001, optionValue: 'Canva'),
  QuestionOptionEntity(
      optionId: 20012, questionId: 2001, optionValue: 'CapCut'),
  QuestionOptionEntity(
      optionId: 20013, questionId: 2001, optionValue: 'Photoshop'),
  QuestionOptionEntity(
      optionId: 20021, questionId: 2002, optionValue: 'Viết bài'),
  QuestionOptionEntity(
      optionId: 20022, questionId: 2002, optionValue: 'Làm video ngắn'),
  QuestionOptionEntity(
      optionId: 20023, questionId: 2002, optionValue: 'Cả hai'),

  // Recruitment 3 - CTV hỗ trợ doanh nghiệp
  QuestionOptionEntity(
      optionId: 30011, questionId: 3001, optionValue: 'Tiếng Việt'),
  QuestionOptionEntity(
      optionId: 30012, questionId: 3001, optionValue: 'Tiếng Anh'),
  QuestionOptionEntity(
      optionId: 30013, questionId: 3001, optionValue: 'Song ngữ'),
  QuestionOptionEntity(
      optionId: 30021, questionId: 3002, optionValue: 'Lễ tân'),
  QuestionOptionEntity(
      optionId: 30022, questionId: 3002, optionValue: 'Hướng dẫn khách'),
  QuestionOptionEntity(
      optionId: 30023,
      questionId: 3002,
      optionValue: 'Hỗ trợ quầy doanh nghiệp'),

  // Recruitment 4 - CTV hỗ trợ truyền thông
  QuestionOptionEntity(
      optionId: 40011, questionId: 4001, optionValue: 'Chụp ảnh'),
  QuestionOptionEntity(
      optionId: 40012, questionId: 4001, optionValue: 'Quay video'),
  QuestionOptionEntity(
      optionId: 40013, questionId: 4001, optionValue: 'Cả hai'),
  QuestionOptionEntity(
      optionId: 40021,
      questionId: 4002,
      optionValue: 'Có sẵn máy ảnh/máy quay'),
  QuestionOptionEntity(
      optionId: 40022, questionId: 4002, optionValue: 'Chỉ dùng điện thoại'),

  // Recruitment 5 - CTV hậu cần
  QuestionOptionEntity(
      optionId: 50011, questionId: 5001, optionValue: 'Set-up sân khấu'),
  QuestionOptionEntity(
      optionId: 50012,
      questionId: 5001,
      optionValue: 'Hỗ trợ âm thanh ánh sáng'),
  QuestionOptionEntity(
      optionId: 50013,
      questionId: 5001,
      optionValue: 'Quản lý vật phẩm sự kiện'),
  QuestionOptionEntity(
      optionId: 50021, questionId: 5002, optionValue: 'Có thể khiêng đồ nhẹ'),
  QuestionOptionEntity(
      optionId: 50022, questionId: 5002, optionValue: 'Chỉ hỗ trợ điều phối'),

  // Recruitment 6 - CTV hỗ trợ phân tích
  QuestionOptionEntity(
      optionId: 60011, questionId: 6001, optionValue: 'Google Sheets'),
  QuestionOptionEntity(optionId: 60012, questionId: 6001, optionValue: 'Excel'),
  QuestionOptionEntity(
      optionId: 60013, questionId: 6001, optionValue: 'Cả hai'),
  QuestionOptionEntity(
      optionId: 60021, questionId: 6002, optionValue: 'Thống kê cơ bản'),
  QuestionOptionEntity(
      optionId: 60022, questionId: 6002, optionValue: 'Tổng hợp dữ liệu'),
  QuestionOptionEntity(
      optionId: 60023, questionId: 6002, optionValue: 'Trực quan hóa dữ liệu'),

  // Recruitment 7 - CTV đặc biệt
  QuestionOptionEntity(optionId: 70011, questionId: 7001, optionValue: 'Sáng'),
  QuestionOptionEntity(optionId: 70012, questionId: 7001, optionValue: 'Chiều'),
  QuestionOptionEntity(
      optionId: 70013, questionId: 7001, optionValue: 'Cả ngày'),
  QuestionOptionEntity(
      optionId: 70021, questionId: 7002, optionValue: 'Nhanh nhạy'),
  QuestionOptionEntity(
      optionId: 70022, questionId: 7002, optionValue: 'Kỷ luật'),
  QuestionOptionEntity(
      optionId: 70023, questionId: 7002, optionValue: 'Chủ động'),
];

List<QuestionOptionEntity> getQuestionOptionsByQuestionId(int questionId) {
  return questionOptionMock
      .where((option) => option.questionId == questionId)
      .toList();
}
