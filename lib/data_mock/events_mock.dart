import 'package:events_app/data_mock/venues_mock.dart';
import 'package:events_app/feature/common/domain/entity/category_entity.dart';
import 'package:events_app/feature/common/domain/entity/category_option_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';

/// Mock data cho cac su kien
/// Luu y: dung EventEntity de khop voi controller detail va field backend moi.
final List<EventEntity> eventsMock = [
  EventEntity(
    eventId: 1,
    organizerName: 'Nguyễn Văn A',
    venue: venuesMock.firstWhere((venue) => venue.venueId == 1),
    title: 'Hoi thao AI 2026: Xu huong va Ung dung',
    description:
        'Hoi thao chia se nhung xu huong moi nhat ve Tri tue nhan tao, Machine Learning, va cac ung dung thuc te trong cong nghiep. '
        'Su kien co su tham gia cua cac chuyen gia hang dau trong linh vuc AI, voi cac buoi workshop thuc hanh tren Tensorflow, PyTorch. '
        'Phu hop cho sinh vien CNTT, Data Science muon tim hieu AI va cach trien khai du an thuc te.',
    banner: 'https://example.com/events/ai-2026.jpg',
    status: EventStatus.published,
    startTime: DateTime(2026, 4, 10, 8, 30),
    endTime: DateTime(2026, 4, 10, 17, 30),
    registerOpenTime: DateTime(2026, 3, 20, 8, 0),
    price: 500000,
    categories: [
      CategoryEntity(
        categoryId: 1,
        name: 'Lĩnh vực',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 1,
            categoryId: 1,
            value: 'Artificial Intelligence',
          ),
          CategoryOptionEntity(
            categoryOptionId: 2,
            categoryId: 1,
            value: 'Machine Learning',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 2,
        name: 'Hình thức',
        type: CategoryType.style,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 5,
            categoryId: 2,
            value: 'Hands-on Workshop',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 3,
        name: 'Trường đại học',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 8,
            categoryId: 3,
            value: 'ĐH Bách Khoa TP.HCM',
          ),
        ],
      ),
    ],
    rewardCoin: 50,
    youthUnionPoint: 10,
    certificateName: 'Chứng nhận tham dự hội thảo AI 2026',
    createdTime: DateTime(2026, 3, 1, 10, 0),
    totalParticipants: 150,
    userEventState: UserEventState.none,
  ),
  EventEntity(
    eventId: 2,
    organizerName: 'Trần Thị B',
    venue: venuesMock.firstWhere((venue) => venue.venueId == 2),
    title: 'Startup Pitch Day - Ket noi Dau tu',
    description:
        'Su kien giup cac Startup tre ket noi voi mentor kinh nghiem va cac nha dau tu trong va ngoai nuoc. '
        'Cac doi startup se co 5 phut de trinh bay y tuong, sau do la phien Q&A voi ban giam khao. '
        'Giai thuong: 100 trieu dong von dau tu cho doi nhat, co hoi huong dan truc tiep tu Shark Tank Vietnam. '
        'Tuyen gap 3 sinh vien lam viec part-time ho tro to chuc su kien (luong: 150k/gio).',
    banner: 'https://example.com/events/startup-pitch.jpg',
    status: EventStatus.published,
    startTime: DateTime(2026, 4, 22, 13, 30),
    endTime: DateTime(2026, 4, 22, 18, 0),
    registerOpenTime: DateTime(2026, 3, 25, 9, 0),
    price: null,
    categories: [
      CategoryEntity(
        categoryId: 4,
        name: 'Lĩnh vực',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 10,
            categoryId: 4,
            value: 'Startup',
          ),
          CategoryOptionEntity(
            categoryOptionId: 11,
            categoryId: 4,
            value: 'Investment',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 5,
        name: 'Hình thức',
        type: CategoryType.style,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 15,
            categoryId: 5,
            value: 'Pitching',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 6,
        name: 'Trường đại học',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 20,
            categoryId: 6,
            value: 'ĐH Công nghệ Thông tin',
          ),
        ],
      ),
    ],
    rewardCoin: 30,
    youthUnionPoint: 0,
    certificateName: null,
    createdTime: DateTime(2026, 3, 2, 9, 15),
    totalParticipants: 120,
    userEventState: UserEventState.none,
  ),
  EventEntity(
    eventId: 3,
    organizerName: 'Lê Văn C',
    venue: venuesMock.firstWhere((venue) => venue.venueId == 3),
    title: 'Cyber Security Bootcamp 2026',
    description:
        'Chuong trinh dao tao 3 thang ve Bao mat mang va An ninh thong tin, tu co ban den nang cao. '
        'Noi dung: Network Security, Penetration Testing, Ethical Hacking, Secure Coding Practice. '
        'Huan luyen vien: Chuyen gia 10+ nam kinh nghiem tu FPT Security va Viettel Cyber Security. '
        'Sau khoa hoc, hoc vien se nhan chung chi quoc te CEH (Certified Ethical Hacker). '
        'Tuyen 5 intern lam du an thuc te trong 6 thang (luong: 4-6 trieu/thang).',
    banner: 'https://example.com/events/cyber-security.jpg',
    status: EventStatus.draft,
    startTime: DateTime(2026, 5, 5, 8, 0),
    endTime: DateTime(2026, 5, 5, 17, 30),
    registerOpenTime: DateTime(2026, 4, 1, 8, 0),
    price: 2000000,
    categories: [
      CategoryEntity(
        categoryId: 1,
        name: 'Lĩnh vực',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 3,
            categoryId: 1,
            value: 'Cyber Security',
          ),
          CategoryOptionEntity(
            categoryOptionId: 4,
            categoryId: 1,
            value: 'Networking',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 7,
        name: 'Hình thức',
        type: CategoryType.style,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 25,
            categoryId: 7,
            value: 'Intensive Training',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 8,
        name: 'Trường đại học',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 30,
            categoryId: 8,
            value: 'ĐH Khoa học Tự nhiên',
          ),
        ],
      ),
    ],
    rewardCoin: 100,
    youthUnionPoint: 20,
    certificateName: 'Chứng nhận tham dự Cyber Security Bootcamp',
    createdTime: DateTime(2026, 3, 3, 8, 40),
    totalParticipants: 0,
    userEventState: UserEventState.none,
  ),
  EventEntity(
    eventId: 4,
    organizerName: 'Phạm Thị D',
    venue: venuesMock.firstWhere((venue) => venue.venueId == 4),
    title: 'Ngay hoi Viec lam 2026 - Job Fair HCMC',
    description:
        'Su kien tuyen dung lon nhat nam danh cho sinh vien sap tot nghiep va nguoi di lam. '
        'Tham gia: 150+ doanh nghiep hang dau (FPT, VNG, Viettel, Samsung, Shopee, Grab, Tiki,...). '
        'Co hoi phong van truc tiep voi nha tuyen dung, tham du workshop ve CV, phong van, ky nang mem. '
        'Tuyen 20 volunteer ho tro dieu phoi su kien (co chung nhan tinh nguyen + buffet + ao su kien).',
    banner: 'https://example.com/events/job-fair-hcmc.jpg',
    status: EventStatus.closed,
    startTime: DateTime(2026, 3, 28, 7, 30),
    endTime: DateTime(2026, 3, 28, 16, 0),
    registerOpenTime: DateTime(2026, 2, 20, 8, 0),
    price: null,
    categories: [
      CategoryEntity(
        categoryId: 9,
        name: 'Lĩnh vực',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 35,
            categoryId: 9,
            value: 'Job Fair',
          ),
          CategoryOptionEntity(
            categoryOptionId: 36,
            categoryId: 9,
            value: 'Recruitment',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 10,
        name: 'Hình thức',
        type: CategoryType.style,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 40,
            categoryId: 10,
            value: 'Career Networking',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 11,
        name: 'Trường đại học',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 45,
            categoryId: 11,
            value: 'Tất cả sinh viên',
          ),
        ],
      ),
    ],
    rewardCoin: 0,
    youthUnionPoint: 0,
    certificateName: 'Chứng nhận hỗ trợ Ngày hội Việc làm 2026',
    createdTime: DateTime(2026, 2, 15, 14, 30),
    totalParticipants: 1850,
    userEventState: UserEventState.none,
  ),
  EventEntity(
    eventId: 5,
    organizerName: 'Nguyễn Văn A',
    venue: venuesMock.firstWhere((venue) => venue.venueId == 1),
    title: 'Workshop Product Design - UX/UI Thinking',
    description:
        'Chuoi workshop thuc hanh ve quy trinh nghien cuu nguoi dung (User Research), thiet ke giao dien (UI Design), trai nghiem nguoi dung (UX). '
        'Hoc vien se lam viec theo nhom 4-5 nguoi, thuc hien du an thiet ke app/website thuc te trong 1 ngay. '
        'Cong cu: Figma, Adobe XD, Miro. Giang vien: Senior Product Designer tu Tiki va Shopee. '
        'Tuyen 2 thiet ke vien part-time lam viec 20h/tuan (luong: 100k/gio) ho tro du an design cua truong.',
    banner: 'https://example.com/events/ux-ui-workshop.jpg',
    status: EventStatus.published,
    startTime: DateTime(2026, 5, 12, 9, 0),
    endTime: DateTime(2026, 5, 12, 16, 30),
    registerOpenTime: DateTime(2026, 4, 5, 8, 0),
    price: 300000,
    categories: [
      CategoryEntity(
        categoryId: 12,
        name: 'Lĩnh vực',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 50,
            categoryId: 12,
            value: 'UX/UI Design',
          ),
          CategoryOptionEntity(
            categoryOptionId: 51,
            categoryId: 12,
            value: 'Product Design',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 2,
        name: 'Hình thức',
        type: CategoryType.style,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 6,
            categoryId: 2,
            value: 'Interactive Workshop',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 3,
        name: 'Trường đại học',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 8,
            categoryId: 3,
            value: 'ĐH Bách Khoa TP.HCM',
          ),
        ],
      ),
    ],
    rewardCoin: 40,
    youthUnionPoint: 5,
    certificateName: 'Chứng nhận tham gia Workshop UX/UI Thinking',
    createdTime: DateTime(2026, 3, 4, 11, 0),
    totalParticipants: 90,
    userEventState: UserEventState.none,
  ),
  EventEntity(
    eventId: 6,
    organizerName: 'Trần Thị B',
    venue: venuesMock.firstWhere((venue) => venue.venueId == 5),
    title: 'Hackathon 48h - Giai phap Cong nghe Xanh',
    description:
        'Cuoc thi lap trinh 48 gio khong nghi tap trung giai quyet van de moi truong bang cong nghe. '
        'Cac doi (3-5 nguoi) se phat trien giai phap IoT, AI, Mobile App hoac Web cho bai toan: '
        'Giam sat chat luong khong khi, Quan ly rac thai thong minh, Tiet kiem nang luong. '
        'Giai thuong: 50 trieu dong + co hoi goi von tu quy dau tu xanh. '
        'Can tuyen 10 volunteer ho tro ky thuat, catering, media (co chung nhan + qua luu niem).',
    banner: 'https://example.com/events/hackathon-green.jpg',
    status: EventStatus.published,
    startTime: DateTime(2026, 6, 20, 18, 0),
    endTime: DateTime(2026, 6, 22, 18, 0),
    registerOpenTime: DateTime(2026, 5, 1, 8, 0),
    price: null,
    categories: [
      CategoryEntity(
        categoryId: 13,
        name: 'Lĩnh vực',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 65,
            categoryId: 13,
            value: 'Green Tech',
          ),
          CategoryOptionEntity(
            categoryOptionId: 66,
            categoryId: 13,
            value: 'IoT',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 14,
        name: 'Hình thức',
        type: CategoryType.style,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 70,
            categoryId: 14,
            value: 'Masterclass',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 15,
        name: 'Trường đại học',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 75,
            categoryId: 15,
            value: 'ĐH Tôn Đức Thắng',
          ),
        ],
      ),
    ],
    rewardCoin: 200,
    youthUnionPoint: 30,
    certificateName: 'Chứng nhận tham gia Hackathon 48h',
    createdTime: DateTime(2026, 3, 10, 15, 30),
    totalParticipants: 180,
    userEventState: UserEventState.none,
  ),
  EventEntity(
    eventId: 7,
    organizerName: 'Lê Văn C',
    venue: venuesMock.firstWhere((venue) => venue.venueId == 3),
    title: 'Data Science Series - Big Data Analytics',
    description:
        'Chuong trinh dao tao 12 tuan ve Phan tich du lieu lon (Big Data) va Khoa hoc du lieu (Data Science). '
        'Noi dung: Python, SQL, Pandas, NumPy, Matplotlib, Apache Spark, Hadoop, Power BI. '
        'Hoc vien lam du an thuc te voi du lieu tu doanh nghiep (e-commerce, fintech, healthcare). '
        'Giang vien: Data Scientist tu Grab, Lazada, Tiki. '
        'Tuyen 8 intern tham gia du an Data Analysis 4 thang (luong: 5-8 trieu/thang + laptop).',
    banner: 'https://example.com/events/data-science-series.jpg',
    status: EventStatus.published,
    startTime: DateTime(2026, 7, 1, 18, 30),
    endTime: DateTime(2026, 7, 1, 21, 0),
    registerOpenTime: DateTime(2026, 5, 15, 8, 0),
    price: 800000,
    categories: [
      CategoryEntity(
        categoryId: 16,
        name: 'Lĩnh vực',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 80,
            categoryId: 16,
            value: 'Data Science',
          ),
          CategoryOptionEntity(
            categoryOptionId: 81,
            categoryId: 16,
            value: 'Big Data',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 17,
        name: 'Hình thức',
        type: CategoryType.style,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 85,
            categoryId: 17,
            value: 'Masterclass',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 18,
        name: 'Trường đại học',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 90,
            categoryId: 18,
            value: 'ĐH Khoa học Tự nhiên',
          ),
        ],
      ),
    ],
    rewardCoin: 120,
    youthUnionPoint: 15,
    certificateName: 'Chứng nhận tham dự Data Science Series',
    createdTime: DateTime(2026, 3, 12, 9, 45),
    totalParticipants: 64,
    userEventState: UserEventState.none,
  ),
  EventEntity(
    eventId: 8,
    organizerName: 'Phạm Thị D',
    venue: venuesMock.firstWhere((venue) => venue.venueId == 2),
    title: 'Marketing Digital & Social Media Masterclass',
    description:
        'Khoa hoc thuc hanh ve Marketing so (Digital Marketing), quan ly mang xa hoi (Social Media Management). '
        'Noi dung: Facebook Ads, Google Ads, SEO/SEM, Instagram Marketing, TikTok for Business, Analytics. '
        'Hoc vien se thuc hanh chay quang cao that voi ngan sach 5 trieu dong do nha tai tro cap. '
        'Giang vien: Marketing Manager tu Unilever, Nestle, Coca-Cola Viet Nam. '
        'Tuyen 4 sinh vien part-time lam content creator & social media (100k/gio, 15h/tuan).',
    banner: 'https://example.com/events/marketing-masterclass.jpg',
    status: EventStatus.published,
    startTime: DateTime(2026, 5, 18, 13, 0),
    endTime: DateTime(2026, 5, 18, 17, 30),
    registerOpenTime: DateTime(2026, 4, 10, 8, 0),
    price: 150000,
    categories: [
      CategoryEntity(
        categoryId: 19,
        name: 'Lĩnh vực',
        type: CategoryType.field,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 95,
            categoryId: 19,
            value: 'Digital Marketing',
          ),
          CategoryOptionEntity(
            categoryOptionId: 96,
            categoryId: 19,
            value: 'Social Media',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 20,
        name: 'Hình thức',
        type: CategoryType.style,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 100,
            categoryId: 20,
            value: 'Masterclass',
          ),
        ],
      ),
      CategoryEntity(
        categoryId: 21,
        name: 'Trường đại học',
        type: CategoryType.school,
        options: [
          CategoryOptionEntity(
            categoryOptionId: 105,
            categoryId: 21,
            value: 'ĐH Tôn Đức Thắng',
          ),
        ],
      ),
    ],
    rewardCoin: 20,
    youthUnionPoint: 8,
    certificateName: 'Chứng nhận tham gia Marketing Masterclass',
    createdTime: DateTime(2026, 3, 15, 10, 20),
    totalParticipants: 120,
    userEventState: UserEventState.none,
  ),
];
