import 'package:events_app/data_mock/question_option_mock.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/recruitment/domain/entity/requirement_question_entity.dart';

final List<RequirementQuestionEntity> requirementQuestionMock = [
  // Recruitment 1 - CTV hỗ trợ check-in
  RequirementQuestionEntity(
    questionId: 1001,
    ctvRecruitmentId: 1,
    questionText: 'Bạn đã tham gia bao nhiêu sự kiện gần đây?',
    questionType: RequirementQuestionType.singleChoice,
    isRequired: true,
    options: getQuestionOptionsByQuestionId(1001),
  ),
  RequirementQuestionEntity(
    questionId: 1002,
    ctvRecruitmentId: 1,
    questionText: 'Khung giờ bạn có thể hỗ trợ?',
    questionType: RequirementQuestionType.singleChoice,
    isRequired: true,
    options: getQuestionOptionsByQuestionId(1002),
  ),
  RequirementQuestionEntity(
    questionId: 1003,
    ctvRecruitmentId: 1,
    questionText: 'Mô tả ngắn kinh nghiệm check-in hoặc tiếp đón khách.',
    questionType: RequirementQuestionType.text,
    isRequired: false,
    options: null,
  ),

  // Recruitment 2 - CTV hỗ trợ nội dung
  RequirementQuestionEntity(
    questionId: 2001,
    ctvRecruitmentId: 2,
    questionText: 'Công cụ bạn sử dụng thành thạo nhất?',
    questionType: RequirementQuestionType.singleChoice,
    isRequired: true,
    options: getQuestionOptionsByQuestionId(2001),
  ),
  RequirementQuestionEntity(
    questionId: 2002,
    ctvRecruitmentId: 2,
    questionText: 'Thế mạnh nội dung của bạn là gì?',
    questionType: RequirementQuestionType.singleChoice,
    isRequired: true,
    options: getQuestionOptionsByQuestionId(2002),
  ),
  RequirementQuestionEntity(
    questionId: 2003,
    ctvRecruitmentId: 2,
    questionText: 'Gửi ví dụ bài viết/video bạn từng thực hiện.',
    questionType: RequirementQuestionType.text,
    isRequired: false,
    options: null,
  ),

  // Recruitment 3 - CTV hỗ trợ doanh nghiệp
  RequirementQuestionEntity(
    questionId: 3001,
    ctvRecruitmentId: 3,
    questionText: 'Bạn tự tin giao tiếp ngôn ngữ nào?',
    questionType: RequirementQuestionType.singleChoice,
    isRequired: true,
    options: getQuestionOptionsByQuestionId(3001),
  ),
  RequirementQuestionEntity(
    questionId: 3002,
    ctvRecruitmentId: 3,
    questionText: 'Nhóm công việc bạn muốn phụ trách?',
    questionType: RequirementQuestionType.singleChoice,
    isRequired: true,
    options: getQuestionOptionsByQuestionId(3002),
  ),
  RequirementQuestionEntity(
    questionId: 3003,
    ctvRecruitmentId: 3,
    questionText: 'Bạn từng hỗ trợ sự kiện việc làm nào chưa?',
    questionType: RequirementQuestionType.text,
    isRequired: false,
    options: null,
  ),

  // Recruitment 4 - CTV hỗ trợ truyền thông
  RequirementQuestionEntity(
    questionId: 4001,
    ctvRecruitmentId: 4,
    questionText: 'Kỹ năng media chính của bạn?',
    questionType: RequirementQuestionType.singleChoice,
    isRequired: true,
    options: getQuestionOptionsByQuestionId(4001),
  ),
  RequirementQuestionEntity(
    questionId: 4002,
    ctvRecruitmentId: 4,
    questionText: 'Trang thiết bị bạn đang có?',
    questionType: RequirementQuestionType.singleChoice,
    isRequired: true,
    options: getQuestionOptionsByQuestionId(4002),
  ),
  RequirementQuestionEntity(
    questionId: 4003,
    ctvRecruitmentId: 4,
    questionText: 'Link portfolio media (nếu có).',
    questionType: RequirementQuestionType.text,
    isRequired: false,
    options: null,
  ),

  // Recruitment 5 - CTV hậu cần
  RequirementQuestionEntity(
    questionId: 5001,
    ctvRecruitmentId: 5,
    questionText: 'Công việc hậu cần bạn ưu tiên?',
    questionType: RequirementQuestionType.singleChoice,
    isRequired: true,
    options: getQuestionOptionsByQuestionId(5001),
  ),
  RequirementQuestionEntity(
    questionId: 5002,
    ctvRecruitmentId: 5,
    questionText: 'Khả năng hỗ trợ vận động?',
    questionType: RequirementQuestionType.singleChoice,
    isRequired: true,
    options: getQuestionOptionsByQuestionId(5002),
  ),
  RequirementQuestionEntity(
    questionId: 5003,
    ctvRecruitmentId: 5,
    questionText: 'Bạn có thể đến sớm trước giờ bắt đầu bao lâu?',
    questionType: RequirementQuestionType.text,
    isRequired: false,
    options: null,
  ),

  // Recruitment 6 - CTV hỗ trợ phân tích
  RequirementQuestionEntity(
    questionId: 6001,
    ctvRecruitmentId: 6,
    questionText: 'Công cụ xử lý dữ liệu bạn sử dụng?',
    questionType: RequirementQuestionType.singleChoice,
    isRequired: true,
    options: getQuestionOptionsByQuestionId(6001),
  ),
  RequirementQuestionEntity(
    questionId: 6002,
    ctvRecruitmentId: 6,
    questionText: 'Kỹ năng dữ liệu nổi bật nhất của bạn?',
    questionType: RequirementQuestionType.singleChoice,
    isRequired: true,
    options: getQuestionOptionsByQuestionId(6002),
  ),
  RequirementQuestionEntity(
    questionId: 6003,
    ctvRecruitmentId: 6,
    questionText: 'Mô tả dự án nhỏ bạn từng tổng hợp/phân tích dữ liệu.',
    questionType: RequirementQuestionType.text,
    isRequired: false,
    options: null,
  ),

  // Recruitment 7 - CTV đặc biệt
  RequirementQuestionEntity(
    questionId: 7001,
    ctvRecruitmentId: 7,
    questionText: 'Ca làm việc mong muốn?',
    questionType: RequirementQuestionType.singleChoice,
    isRequired: true,
    options: getQuestionOptionsByQuestionId(7001),
  ),
  RequirementQuestionEntity(
    questionId: 7002,
    ctvRecruitmentId: 7,
    questionText: 'Phẩm chất bạn tự đánh giá phù hợp nhất?',
    questionType: RequirementQuestionType.singleChoice,
    isRequired: true,
    options: getQuestionOptionsByQuestionId(7002),
  ),
  RequirementQuestionEntity(
    questionId: 7003,
    ctvRecruitmentId: 7,
    questionText: 'Vì sao bạn muốn ứng tuyển vào vị trí CTV đặc biệt?',
    questionType: RequirementQuestionType.text,
    isRequired: false,
    options: null,
  ),
];

List<RequirementQuestionEntity> getRequirementQuestionsByRecruitmentId(
  int ctvRecruitmentId,
) {
  return requirementQuestionMock
      .where((question) => question.ctvRecruitmentId == ctvRecruitmentId)
      .toList();
}

RequirementQuestionEntity? getRequirementQuestionById(int questionId) {
  try {
    return requirementQuestionMock.firstWhere(
      (question) => question.questionId == questionId,
    );
  } catch (_) {
    return null;
  }
}
