import 'package:events_app/feature/common/domain/entity/category_entity.dart';
import 'package:events_app/feature/common/domain/entity/category_option_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';

/// Mock data cho EventSummary - danh sach su kien nhe
final List<EventSummaryEntity> eventSummaryMock = [
  EventSummaryEntity(
    eventId: 1,
    title: 'Hội thảo AI 2026: Xu hướng và Ứng dụng',
    startTime: DateTime(2026, 4, 10, 8, 30),
    endTime: DateTime(2026, 4, 10, 17, 30),
    status: EventStatus.published,
    price: 500000,
    categories: [
      CategoryEntity(
        categoryId: 1,
        name: 'Technology',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 1,
            categoryId: 1,
            value: 'ai',
            label: 'Artificial Intelligence',
          ),
          CategoryOptionEntity(
            categoryOptionId: 2,
            categoryId: 1,
            value: 'machine-learning',
            label: 'Machine Learning',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 2,
        name: 'Workshop',
        type: CategoryType.style,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 5,
            categoryId: 2,
            value: 'hands-on',
            label: 'Hands-on Workshop',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 3,
        name: 'Bách Khoa',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 8,
            categoryId: 3,
            value: 'hcmut',
            label: 'ĐH Bách Khoa TPHCM',
          ),
        ],
      ),
    ],
    capacity: 200,
    totalParticipants: 150,
  ),
  EventSummaryEntity(
    eventId: 2,
    title: 'Startup Pitch Day - Kết nối Đầu tư',
    startTime: DateTime(2026, 4, 22, 13, 30),
    endTime: DateTime(2026, 4, 22, 18, 0),
    status: EventStatus.published,
    price: null, // Free event
    categories: [
      CategoryEntity(
        categoryId: 4,
        name: 'Business',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 10,
            categoryId: 4,
            value: 'startup',
            label: 'Startup',
          ),
          CategoryOptionEntity(
            categoryOptionId: 11,
            categoryId: 4,
            value: 'investment',
            label: 'Investment',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 5,
        name: 'Competition',
        type: CategoryType.style,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 15,
            categoryId: 5,
            value: 'pitch',
            label: 'Pitching',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 6,
        name: 'UIT',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 20,
            categoryId: 6,
            value: 'uit',
            label: 'ĐH Công nghệ Thông tin',
          ),
        ],
      ),
    ],
    capacity: 150,
    totalParticipants: 120,
  ),
  EventSummaryEntity(
    eventId: 3,
    title: 'Cyber Security Bootcamp 2026',
    startTime: DateTime(2026, 5, 5, 8, 0),
    endTime: DateTime(2026, 5, 5, 17, 30),
    status: EventStatus.draft,
    price: 2000000,
    categories: [
      CategoryEntity(
        categoryId: 1,
        name: 'Technology',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 3,
            categoryId: 1,
            value: 'cybersecurity',
            label: 'Cyber Security',
          ),
          CategoryOptionEntity(
            categoryOptionId: 4,
            categoryId: 1,
            value: 'networking',
            label: 'Networking',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 7,
        name: 'Bootcamp',
        type: CategoryType.style,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 25,
            categoryId: 7,
            value: 'intensive',
            label: 'Intensive Training',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 8,
        name: 'HCMUS',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 30,
            categoryId: 8,
            value: 'hcmus',
            label: 'ĐH Khoa học Tự nhiên',
          ),
        ],
      ),
    ],
    capacity: 50,
    totalParticipants: 0,
  ),
  EventSummaryEntity(
    eventId: 4,
    title: 'Ngày hội Việc làm 2026 - Job Fair HCMC',
    startTime: DateTime(2026, 3, 28, 7, 30),
    endTime: DateTime(2026, 3, 28, 16, 0),
    status: EventStatus.closed,
    price: null,
    categories: [
      CategoryEntity(
        categoryId: 9,
        name: 'Career',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 35,
            categoryId: 9,
            value: 'job-fair',
            label: 'Job Fair',
          ),
          CategoryOptionEntity(
            categoryOptionId: 36,
            categoryId: 9,
            value: 'recruitment',
            label: 'Recruitment',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 10,
        name: 'Networking',
        type: CategoryType.style,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 40,
            categoryId: 10,
            value: 'career-networking',
            label: 'Career Networking',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 11,
        name: 'Tất cả trường',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 45,
            categoryId: 11,
            value: 'all-schools',
            label: 'Tất cả sinh viên',
          ),
        ],
      ),
    ],
    capacity: 2000,
    totalParticipants: 1850,
  ),
  EventSummaryEntity(
    eventId: 5,
    title: 'Workshop Product Design - UX/UI Thinking',
    startTime: DateTime(2026, 5, 12, 9, 0),
    endTime: DateTime(2026, 5, 12, 16, 30),
    status: EventStatus.published,
    price: 300000,
    categories: [
      CategoryEntity(
        categoryId: 12,
        name: 'Design',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 50,
            categoryId: 12,
            value: 'ux-ui',
            label: 'UX/UI Design',
          ),
          CategoryOptionEntity(
            categoryOptionId: 51,
            categoryId: 12,
            value: 'product-design',
            label: 'Product Design',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 2,
        name: 'Workshop',
        type: CategoryType.style,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 6,
            categoryId: 2,
            value: 'interactive',
            label: 'Interactive Workshop',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 3,
        name: 'Bách Khoa',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 8,
            categoryId: 3,
            value: 'hcmut',
            label: 'ĐH Bách Khoa TPHCM',
          ),
        ],
      ),
    ],
    capacity: 80,
    totalParticipants: 65,
  ),
  EventSummaryEntity(
    eventId: 6,
    title: 'Hackathon 48h - Giải pháp Công nghệ Xanh',
    startTime: DateTime(2026, 6, 1, 18, 0),
    endTime: DateTime(2026, 6, 3, 18, 0),
    status: EventStatus.published,
    price: 100000,
    categories: [
      CategoryEntity(
        categoryId: 1,
        name: 'Technology',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 1,
            categoryId: 1,
            value: 'ai',
            label: 'Artificial Intelligence',
          ),
          CategoryOptionEntity(
            categoryOptionId: 55,
            categoryId: 1,
            value: 'iot',
            label: 'Internet of Things',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 5,
        name: 'Competition',
        type: CategoryType.style,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 60,
            categoryId: 5,
            value: 'hackathon',
            label: 'Hackathon',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 6,
        name: 'UIT',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 20,
            categoryId: 6,
            value: 'uit',
            label: 'ĐH Công nghệ Thông tin',
          ),
        ],
      ),
    ],
    capacity: 100,
    totalParticipants: 85,
  ),
  EventSummaryEntity(
    eventId: 7,
    title: 'Digital Marketing Masterclass 2026',
    startTime: DateTime(2026, 4, 15, 14, 0),
    endTime: DateTime(2026, 4, 15, 18, 30),
    status: EventStatus.published,
    price: 400000,
    categories: [
      CategoryEntity(
        categoryId: 13,
        name: 'Marketing',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 65,
            categoryId: 13,
            value: 'digital-marketing',
            label: 'Digital Marketing',
          ),
          CategoryOptionEntity(
            categoryOptionId: 66,
            categoryId: 13,
            value: 'social-media',
            label: 'Social Media',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 14,
        name: 'Seminar',
        type: CategoryType.style,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 70,
            categoryId: 14,
            value: 'masterclass',
            label: 'Masterclass',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 15,
        name: 'TDTU',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 75,
            categoryId: 15,
            value: 'tdtu',
            label: 'ĐH Tôn Đức Thắng',
          ),
        ],
      ),
    ],
    capacity: 120,
    totalParticipants: 95,
  ),
  EventSummaryEntity(
    eventId: 8,
    title: 'Blockchain & Web3 Conference',
    startTime: DateTime(2026, 5, 20, 8, 30),
    endTime: DateTime(2026, 5, 20, 17, 0),
    status: EventStatus.published,
    price: 800000,
    categories: [
      CategoryEntity(
        categoryId: 1,
        name: 'Technology',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 80,
            categoryId: 1,
            value: 'blockchain',
            label: 'Blockchain',
          ),
          CategoryOptionEntity(
            categoryOptionId: 81,
            categoryId: 1,
            value: 'web3',
            label: 'Web3',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 16,
        name: 'Conference',
        type: CategoryType.style,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 85,
            categoryId: 16,
            value: 'international',
            label: 'International Conference',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 11,
        name: 'Tất cả trường',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 45,
            categoryId: 11,
            value: 'all-schools',
            label: 'Tất cả sinh viên',
          ),
        ],
      ),
    ],
    capacity: 300,
    totalParticipants: 245,
  ),
];

/// Helper function de lay event summary mock theo trang thai
List<EventSummaryEntity> getEventSummaryByStatus(EventStatus status) {
  return eventSummaryMock.where((event) => event.status == status).toList();
}

/// Helper function de lay event summary mock dang published
List<EventSummaryEntity> getPublishedEventSummary() {
  return getEventSummaryByStatus(EventStatus.published);
}

/// Helper function de lay event summary mock co gia ve
List<EventSummaryEntity> getPaidEventSummary() {
  return eventSummaryMock.where((event) => event.price != null && event.price! > 0).toList();
}

/// Helper function de lay event summary mock mien phi
List<EventSummaryEntity> getFreeEventSummary() {
  return eventSummaryMock.where((event) => event.price == null || event.price == 0).toList();
}


