import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_summary_entity.dart';
import 'package:events_app/feature/common/domain/entity/category_entity.dart';
import 'package:events_app/feature/common/domain/entity/category_option_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';

final List<CtvRecruitmentSummaryEntity> ctvRecruitmentSummaryMock = [
  CtvRecruitmentSummaryEntity(
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
    title: 'CTV check-in team',
    banner: 'https://example.com/recruitments/checkin-team.jpg',
    startTime: DateTime(2026, 3, 25, 9, 0),
    roleName: 'Event Coordinator',
    description: 'We are looking for event coordinators',
    certificateName: 'Chung nhan cong tac vien check-in',
    cashRewardAmount: 300000,
    quantity: 5,
    isOpen: true,
    appliedCount: 8,
    userEventState: UserEventState.none,
    createdTime: DateTime(2024, 5, 1),
    youthUnionPoint: 25,
  ),
  CtvRecruitmentSummaryEntity(
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
    title: 'CTV content support',
    banner: 'https://example.com/recruitments/content-support.jpg',
    startTime: DateTime(2026, 4, 20, 8, 0),
    roleName: 'Content Assistant',
    description: 'Support social posts and event communication materials',
    certificateName: 'Chung nhan ho tro noi dung su kien',
    cashRewardAmount: 250000,
    quantity: 3,
    isOpen: true,
    appliedCount: 6,
    userEventState: UserEventState.ctvApplied,
    createdTime: DateTime(2024, 5, 8),
    youthUnionPoint: 20,
  ),
  CtvRecruitmentSummaryEntity(
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
    title: 'CTV employer support desk',
    banner: 'https://example.com/recruitments/support-desk.jpg',
    startTime: DateTime(2026, 3, 27, 13, 0),
    roleName: 'Support Staff',
    description: 'Assist employers and visitors at support desks',
    certificateName: 'Chung nhan ho tro Job Fair',
    cashRewardAmount: 400000,
    quantity: 10,
    isOpen: false,
    appliedCount: 24,
    userEventState: UserEventState.ctv,
    createdTime: DateTime(2024, 4, 30),
    youthUnionPoint: 30,
  ),
  CtvRecruitmentSummaryEntity(
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
    title: 'CTV media support',
    banner: 'https://example.com/recruitments/media-support.jpg',
    startTime: DateTime(2026, 4, 12, 8, 0),
    roleName: 'Media Assistant',
    description: 'Capture photos and support event media tasks',
    certificateName: 'Chung nhan ho tro truyen thong su kien',
    cashRewardAmount: 280000,
    quantity: 4,
    isOpen: true,
    appliedCount: 7,
    userEventState: UserEventState.attendee,
    createdTime: DateTime(2024, 5, 10),
    youthUnionPoint: 22,
  ),
  CtvRecruitmentSummaryEntity(
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
    title: 'CTV logistics support',
    banner: 'https://example.com/recruitments/logistics-support.jpg',
    startTime: DateTime(2026, 4, 28, 9, 0),
    roleName: 'Logistics Assistant',
    description: 'Support setup and on-site logistics',
    certificateName: 'Chung nhan ho tro hau can su kien',
    cashRewardAmount: 320000,
    quantity: 6,
    isOpen: false,
    appliedCount: 6,
    userEventState: UserEventState.none,
    createdTime: DateTime(2024, 5, 12),
    youthUnionPoint: 28,
  ),
  CtvRecruitmentSummaryEntity(
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
    title: 'CTV support analyst team',
    banner: 'https://example.com/recruitments/analyst-support.jpg',
    startTime: DateTime(2026, 5, 2, 8, 0),
    roleName: 'Analyst Assistant',
    description: 'Support data collection and analyst coordination',
    certificateName: 'Chung nhan ho tro du lieu su kien',
    cashRewardAmount: 350000,
    quantity: 3,
    isOpen: true,
    appliedCount: 12,
    userEventState: UserEventState.none,
    createdTime: DateTime(2024, 5, 14),
    youthUnionPoint: 32,
  ),
  // Test case: không có options để hiển thị "--"
  CtvRecruitmentSummaryEntity(
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
    title: 'CTV test no field label',
    banner: 'https://example.com/recruitments/special.jpg',
    startTime: DateTime(2026, 5, 5, 10, 0),
    roleName: 'Special Role',
    description: 'Test case with no field options',
    certificateName: 'Chung nhan dac biet',
    cashRewardAmount: 270000,
    quantity: 2,
    isOpen: true,
    appliedCount: 3,
    userEventState: UserEventState.none,
    createdTime: DateTime(2024, 5, 15),
    youthUnionPoint: 0,
  ),
];

List<CtvRecruitmentSummaryEntity> getOpenCtvRecruitmentSummaryMock() {
  return ctvRecruitmentSummaryMock
      .where((recruitment) => recruitment.isOpen == true)
      .toList();
}
