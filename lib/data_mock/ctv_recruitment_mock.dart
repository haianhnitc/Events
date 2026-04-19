import 'package:events_app/data_mock/venues_mock.dart';
import 'package:events_app/feature/common/domain/entity/category_entity.dart';
import 'package:events_app/feature/common/domain/entity/category_option_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';

final List<CtvRecruitmentEntity> ctvRecruitmentMock = [
  CtvRecruitmentEntity(
    ctvRecruitmentId: 1,
    eventId: 1,
    categories: [
      CategoryEntity(
        categoryId: 2,
        name: 'Lĩnh vực',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 14,
            categoryId: 2,
            value: 'Định hướng nghề nghiệp',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 1,
        name: 'Trường đại học',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 1,
            categoryId: 1,
            value: 'ĐH Bách Khoa TP.HCM',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 4,
        name: 'Tiêu chí',
        type: CategoryType.criterion,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 20,
            categoryId: 4,
            value: 'Chứng chỉ 5 tốt',
          ),
          CategoryOptionEntity(
            categoryOptionId: 21,
            categoryId: 4,
            value: 'Cộng điểm đoàn',
          ),
        ],
      ),
    ],
    recruitmentType: EventRecruitmentType.both,
    rewardCoin: 100,
    youthUnionPoint: 20,
    cashRewardAmount: 300000,
    certificateName: 'Chứng nhận cộng tác viên check-in',
    venue: venuesMock.firstWhere((v) => v.venueId == 1),
    title: 'CTV hỗ trợ check-in',
    banner: 'https://example.com/recruitments/checkin-team.jpg',
    startTime: DateTime(2026, 3, 25, 9, 0),
    organizerName: 'Nguyễn Văn A',
    roleName: 'Điều phối sự kiện',
    description:
        'Chúng tôi đang tìm cộng tác viên hỗ trợ check-in và điều phối khách mời.',
    quantity: 5,
    isOpen: true,
    appliedCount: 8,
    recruitedCtvCount: 3,
    userEventState: UserEventState.none,
    createdTime: DateTime(2024, 5, 1),
  ),
  CtvRecruitmentEntity(
    ctvRecruitmentId: 2,
    eventId: 2,
    categories: [
      CategoryEntity(
        categoryId: 2,
        name: 'Lĩnh vực',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 11,
            categoryId: 2,
            value: 'Kỹ năng mềm',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 1,
        name: 'Trường đại học',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 5,
            categoryId: 1,
            value: 'ĐH Công nghệ - ĐHQGHN',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 4,
        name: 'Tiêu chí',
        type: CategoryType.criterion,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 20,
            categoryId: 4,
            value: 'Chứng chỉ 5 tốt',
          ),
          CategoryOptionEntity(
            categoryOptionId: 21,
            categoryId: 4,
            value: 'Cộng điểm đoàn',
          ),
        ],
      ),
    ],
    recruitmentType: EventRecruitmentType.ctvOnly,
    rewardCoin: 80,
    youthUnionPoint: 15,
    cashRewardAmount: 250000,
    certificateName: 'Chứng nhận hỗ trợ nội dung sự kiện',
    venue: venuesMock.firstWhere((v) => v.venueId == 2),
    title: 'CTV hỗ trợ nội dung',
    banner: 'https://example.com/recruitments/content-support.jpg',
    startTime: DateTime(2026, 4, 20, 8, 0),
    organizerName: 'Trần Thị B',
    roleName: 'Trợ lý nội dung',
    description:
        'Hỗ trợ bài đăng mạng xã hội và tài liệu truyền thông sự kiện.',
    quantity: 3,
    isOpen: true,
    appliedCount: 6,
    recruitedCtvCount: 1,
    userEventState: UserEventState.ctvApplied,
    createdTime: DateTime(2024, 5, 8),
  ),
  CtvRecruitmentEntity(
    ctvRecruitmentId: 3,
    eventId: 4,
    categories: [
      CategoryEntity(
        categoryId: 2,
        name: 'Lĩnh vực',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 14,
            categoryId: 2,
            value: 'Định hướng nghề nghiệp',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 1,
        name: 'Trường đại học',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 3,
            categoryId: 1,
            value: 'ĐH Ngoại thương',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 4,
        name: 'Tiêu chí',
        type: CategoryType.criterion,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 20,
            categoryId: 4,
            value: 'Chứng chỉ 5 tốt',
          ),
          CategoryOptionEntity(
            categoryOptionId: 21,
            categoryId: 4,
            value: 'Cộng điểm đoàn',
          ),
        ],
      ),
    ],
    recruitmentType: EventRecruitmentType.ctvOnly,
    rewardCoin: 120,
    youthUnionPoint: 25,
    cashRewardAmount: 400000,
    certificateName: 'Chứng nhận hỗ trợ Job Fair',
    venue: venuesMock.firstWhere((v) => v.venueId == 4),
    title: 'CTV hỗ trợ doanh nghiệp',
    banner: 'https://example.com/recruitments/support-desk.jpg',
    startTime: DateTime(2026, 3, 27, 13, 0),
    organizerName: 'Phạm Thị D',
    roleName: 'Nhân sự hỗ trợ',
    description: 'Hỗ trợ nhà tuyển dụng và khách tham gia tại quầy hỗ trợ.',
    quantity: 10,
    isOpen: false,
    appliedCount: 24,
    recruitedCtvCount: 10,
    userEventState: UserEventState.ctv,
    createdTime: DateTime(2024, 4, 30),
  ),
  CtvRecruitmentEntity(
    ctvRecruitmentId: 4,
    eventId: 5,
    categories: [
      CategoryEntity(
        categoryId: 2,
        name: 'Lĩnh vực',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 10,
            categoryId: 2,
            value: 'Văn hóa - Nghệ thuật',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 1,
        name: 'Trường đại học',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 8,
            categoryId: 1,
            value: 'ĐH Quốc gia TP.HCM',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 4,
        name: 'Tiêu chí',
        type: CategoryType.criterion,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 20,
            categoryId: 4,
            value: 'Chứng chỉ 5 tốt',
          ),
          CategoryOptionEntity(
            categoryOptionId: 21,
            categoryId: 4,
            value: 'Cộng điểm đoàn',
          ),
        ],
      ),
    ],
    recruitmentType: EventRecruitmentType.both,
    rewardCoin: 90,
    youthUnionPoint: 16,
    cashRewardAmount: 280000,
    certificateName: 'Chứng nhận hỗ trợ truyền thông sự kiện',
    venue: venuesMock.firstWhere((v) => v.venueId == 1),
    title: 'CTV hỗ trợ truyền thông',
    banner: 'https://example.com/recruitments/media-support.jpg',
    startTime: DateTime(2026, 4, 12, 8, 0),
    organizerName: 'Nguyễn Văn A',
    roleName: 'Trợ lý media',
    description: 'Chụp ảnh và hỗ trợ công việc truyền thông cho sự kiện.',
    quantity: 4,
    isOpen: true,
    appliedCount: 7,
    recruitedCtvCount: 2,
    userEventState: UserEventState.attendee,
    createdTime: DateTime(2024, 5, 10),
  ),
  CtvRecruitmentEntity(
    ctvRecruitmentId: 5,
    eventId: 6,
    categories: [
      CategoryEntity(
        categoryId: 2,
        name: 'Lĩnh vực',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 11,
            categoryId: 2,
            value: 'Kỹ năng mềm',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 1,
        name: 'Trường đại học',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 7,
            categoryId: 1,
            value: 'ĐH FPT Hà Nội',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 4,
        name: 'Tiêu chí',
        type: CategoryType.criterion,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 20,
            categoryId: 4,
            value: 'Chứng chỉ 5 tốt',
          ),
          CategoryOptionEntity(
            categoryOptionId: 21,
            categoryId: 4,
            value: 'Cộng điểm đoàn',
          ),
        ],
      ),
    ],
    recruitmentType: EventRecruitmentType.ctvOnly,
    rewardCoin: 95,
    youthUnionPoint: 18,
    cashRewardAmount: 320000,
    certificateName: 'Chứng nhận hỗ trợ hậu cần sự kiện',
    venue: venuesMock.firstWhere((v) => v.venueId == 5),
    title: 'CTV hậu cần',
    banner: 'https://example.com/recruitments/logistics-support.jpg',
    startTime: DateTime(2026, 4, 28, 9, 0),
    organizerName: 'Trần Thị B',
    roleName: 'Trợ lý hậu cần',
    description: 'Hỗ trợ set-up và các công việc hậu cần tại chỗ.',
    quantity: 6,
    isOpen: false,
    appliedCount: 6,
    recruitedCtvCount: 4,
    userEventState: UserEventState.none,
    createdTime: DateTime(2024, 5, 12),
  ),
  CtvRecruitmentEntity(
    ctvRecruitmentId: 6,
    eventId: 7,
    categories: [
      CategoryEntity(
        categoryId: 2,
        name: 'Lĩnh vực',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 9,
            categoryId: 2,
            value: 'Công nghệ',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 1,
        name: 'Trường đại học',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 5,
            categoryId: 1,
            value: 'ĐH Công nghệ - ĐHQGHN',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 4,
        name: 'Tiêu chí',
        type: CategoryType.criterion,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 20,
            categoryId: 4,
            value: 'Chứng chỉ 5 tốt',
          ),
          CategoryOptionEntity(
            categoryOptionId: 21,
            categoryId: 4,
            value: 'Cộng điểm đoàn',
          ),
        ],
      ),
    ],
    recruitmentType: EventRecruitmentType.ctvOnly,
    rewardCoin: 110,
    youthUnionPoint: 22,
    cashRewardAmount: 350000,
    certificateName: 'Chứng nhận hỗ trợ dữ liệu sự kiện',
    venue: venuesMock.firstWhere((v) => v.venueId == 3),
    title: 'CTV hỗ trợ phân tích',
    banner: 'https://example.com/recruitments/analyst-support.jpg',
    startTime: DateTime(2026, 5, 2, 8, 0),
    organizerName: 'Lê Văn C',
    roleName: 'Trợ lý phân tích',
    description: 'Hỗ trợ thu thập dữ liệu và phối hợp với nhóm phân tích.',
    quantity: 3,
    isOpen: true,
    appliedCount: 12,
    recruitedCtvCount: 3,
    userEventState: UserEventState.none,
    createdTime: DateTime(2024, 5, 14),
  ),
  // Test case: không có options để hiển thị "--"
  CtvRecruitmentEntity(
    ctvRecruitmentId: 7,
    eventId: 8,
    categories: [
      CategoryEntity(
        categoryId: 7,
        name: 'Lĩnh vực',
        type: CategoryType.field,
        options: [], // Empty options để test "--"
      ),
    ],
    recruitmentType: EventRecruitmentType.ctvOnly,
    rewardCoin: 85,
    youthUnionPoint: 17,
    cashRewardAmount: 270000,
    certificateName: 'Chứng nhận cộng tác viên đặc biệt',
    venue: venuesMock.firstWhere((v) => v.venueId == 2),
    title: 'CTV đặc biệt (no field label)',
    banner: 'https://example.com/recruitments/special.jpg',
    startTime: DateTime(2026, 5, 5, 10, 0),
    organizerName: 'Lý Văn E',
    roleName: 'Chuyên gia đặc biệt',
    description: 'Hỗ trợ đặc biệt cho sự kiện.',
    quantity: 2,
    isOpen: true,
    appliedCount: 3,
    recruitedCtvCount: 0,
    userEventState: UserEventState.none,
    createdTime: DateTime(2024, 5, 15),
  ),
];

List<CtvRecruitmentEntity> getOpenCtvRecruitmentMock() {
  return ctvRecruitmentMock
      .where((recruitment) => recruitment.isOpen == true)
      .toList();
}
