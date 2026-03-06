import 'package:events_app/feature/event_management/data/model/event_model.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';

/// Mock data cho cac su kien
/// Ghi chu: Lien ket voi usersMock (userId) va venuesMock (venueId)
final List<EventModel> eventsMock = [
  EventModel(
    eventId: 1,
    userId: 101, // Nguyen Van A - HCMUT
    venueId: 1, // Hoi truong A - Truong DH Bach Khoa
    recruitmentType: EventRecruitmentType.ctvOnly,
    title: 'Hoi thao AI 2026: Xu huong va Ung dung',
    description:
        'Hoi thao chia se nhung xu huong moi nhat ve Tri tue nhan tao, Machine Learning, va cac ung dung thuc te trong cong nghiep. '
        'Su kien co su tham gia cua cac chuyen gia hang dau trong linh vuc AI, voi cac buoi workshop thuc hanh tren Tensorflow, PyTorch. '
        'Phu hop cho sinh vien CNTT, Data Science muon tim hieu AI va cach trien khai du an thuc te.',
    status: EventStatus.published,
    startTime: DateTime(2026, 4, 10, 8, 30),
    endTime: DateTime(2026, 4, 10, 17, 30),
    registerOpenTime: DateTime(2026, 3, 20, 8, 0),
    createdTime: DateTime(2026, 3, 1, 10, 0),
  ),
  EventModel(
    eventId: 2,
    userId: 102, // Tran Thi B - UIT
    venueId: 2, // Trung tam Khoi nghiep Sang tao
    recruitmentType: EventRecruitmentType.attendeeOnly,
    title: 'Startup Pitch Day - Ket noi Dau tu',
    description:
        'Su kien giup cac Startup tre ket noi voi mentor kinh nghiem va cac nha dau tu trong va ngoai nuoc. '
        'Cac doi startup se co 5 phut de trinh bay y tuong, sau do la phien Q&A voi ban giam khao. '
        'Giai thuong: 100 trieu dong von dau tu cho doi nhat, co hoi huong dan truc tiep tu Shark Tank Vietnam. '
        'Tuyen gap 3 sinh vien lam viec part-time ho tro to chuc su kien (luong: 150k/gio).',
    status: EventStatus.published,
    startTime: DateTime(2026, 4, 22, 13, 30),
    endTime: DateTime(2026, 4, 22, 18, 0),
    registerOpenTime: DateTime(2026, 3, 25, 9, 0),
    createdTime: DateTime(2026, 3, 2, 9, 15),
  ),
  EventModel(
    eventId: 3,
    userId: 103, // Le Van C - HCMUS
    venueId: 3, // Phong Hoi nghi B5 - DH Cong nghe
    recruitmentType: EventRecruitmentType.both,
    title: 'Cyber Security Bootcamp 2026',
    description:
        'Chuong trinh dao tao 3 thang ve Bao mat mang va An ninh thong tin, tu co ban den nang cao. '
        'Noi dung: Network Security, Penetration Testing, Ethical Hacking, Secure Coding Practice. '
        'Huan luyen vien: Chuyen gia 10+ nam kinh nghiem tu FPT Security va Viettel Cyber Security. '
        'Sau khoa hoc, hoc vien se nhan chung chi quoc te CEH (Certified Ethical Hacker). '
        'Tuyen 5 intern lam du an thuc te trong 6 thang (luong: 4-6 trieu/thang).',
    status: EventStatus.draft,
    startTime: DateTime(2026, 5, 5, 8, 0),
    endTime: DateTime(2026, 5, 5, 17, 30),
    registerOpenTime: DateTime(2026, 4, 1, 8, 0),
    createdTime: DateTime(2026, 3, 3, 8, 40),
  ),
  EventModel(
    eventId: 4,
    userId: 104, // Pham Thi D - TDTU
    venueId: 4, // San van dong Thong Nhat
    recruitmentType: EventRecruitmentType.ctvOnly,
    title: 'Ngay hoi Viec lam 2026 - Job Fair HCMC',
    description:
        'Su kien tuyen dung lon nhat nam danh cho sinh vien sap tot nghiep va nguoi di lam. '
        'Tham gia: 150+ doanh nghiep hang dau (FPT, VNG, Viettel, Samsung, Shopee, Grab, Tiki,...). '
        'Co hoi phong van truc tiep voi nha tuyen dung, tham du workshop ve CV, phong van, ky nang mem. '
        'Tuyen 20 volunteer ho tro dieu phoi su kien (co chung nhan tinh nguyen + buffet + ao su kien).',
    status: EventStatus.closed,
    startTime: DateTime(2026, 3, 28, 7, 30),
    endTime: DateTime(2026, 3, 28, 16, 0),
    registerOpenTime: DateTime(2026, 2, 20, 8, 0),
    createdTime: DateTime(2026, 2, 15, 14, 30),
  ),
  EventModel(
    eventId: 5,
    userId: 101, // Nguyen Van A - HCMUT
    venueId: 1, // Hoi truong A - Truong DH Bach Khoa
    recruitmentType: EventRecruitmentType.attendeeOnly,
    title: 'Workshop Product Design - UX/UI Thinking',
    description:
        'Chuoi workshop thuc hanh ve quy trinh nghien cuu nguoi dung (User Research), thiet ke giao dien (UI Design), trai nghiem nguoi dung (UX). '
        'Hoc vien se lam viec theo nhom 4-5 nguoi, thuc hien du an thiet ke app/website thuc te trong 1 ngay. '
        'Cong cu: Figma, Adobe XD, Miro. Giang vien: Senior Product Designer tu Tiki va Shopee. '
        'Tuyen 2 thiet ke vien part-time lam viec 20h/tuan (luong: 100k/gio) ho tro du an design cua truong.',
    status: EventStatus.published,
    startTime: DateTime(2026, 5, 12, 9, 0),
    endTime: DateTime(2026, 5, 12, 16, 30),
    registerOpenTime: DateTime(2026, 4, 5, 8, 0),
    createdTime: DateTime(2026, 3, 4, 11, 0),
  ),
  EventModel(
    eventId: 6,
    userId: 102, // Tran Thi B - UIT
    venueId: 5, // Co working space Innovation Hub
    recruitmentType: EventRecruitmentType.ctvOnly,
    title: 'Hackathon 48h - Giai phap Cong nghe Xanh',
    description:
        'Cuoc thi lap trinh 48 gio khong nghi tap trung giai quyet van de moi truong bang cong nghe. '
        'Cac doi (3-5 nguoi) se phat trien giai phap IoT, AI, Mobile App hoac Web cho bai toan: '
        'Giam sat chat luong khong khi, Quan ly rac thai thong minh, Tiet kiem nang luong. '
        'Giai thuong: 50 trieu dong + co hoi goi von tu quy dau tu xanh. '
        'Can tuyen 10 volunteer ho tro ky thuat, catering, media (co chung nhan + qua luu niem).',
    status: EventStatus.published,
    startTime: DateTime(2026, 6, 20, 18, 0),
    endTime: DateTime(2026, 6, 22, 18, 0),
    registerOpenTime: DateTime(2026, 5, 1, 8, 0),
    createdTime: DateTime(2026, 3, 10, 15, 30),
  ),
  EventModel(
    eventId: 7,
    userId: 103, // Le Van C - HCMUS
    venueId: 3, // Phong Hoi nghi B5 - DH Cong nghe
    recruitmentType: EventRecruitmentType.both,
    title: 'Data Science Series - Big Data Analytics',
    description:
        'Chuong trinh dao tao 12 tuan ve Phan tich du lieu lon (Big Data) va Khoa hoc du lieu (Data Science). '
        'Noi dung: Python, SQL, Pandas, NumPy, Matplotlib, Apache Spark, Hadoop, Power BI. '
        'Hoc vien lam du an thuc te voi du lieu tu doanh nghiep (e-commerce, fintech, healthcare). '
        'Giang vien: Data Scientist tu Grab, Lazada, Tiki. '
        'Tuyen 8 intern tham gia du an Data Analysis 4 thang (luong: 5-8 trieu/thang + laptop).',
    status: EventStatus.published,
    startTime: DateTime(2026, 7, 1, 18, 30),
    endTime: DateTime(2026, 7, 1, 21, 0),
    registerOpenTime: DateTime(2026, 5, 15, 8, 0),
    createdTime: DateTime(2026, 3, 12, 9, 45),
  ),
  EventModel(
    eventId: 8,
    userId: 104, // Pham Thi D - TDTU
    venueId: 2, // Trung tam Khoi nghiep Sang tao
    recruitmentType: EventRecruitmentType.attendeeOnly,
    title: 'Marketing Digital & Social Media Masterclass',
    description:
        'Khoa hoc thuc hanh ve Marketing so (Digital Marketing), quan ly mang xa hoi (Social Media Management). '
        'Noi dung: Facebook Ads, Google Ads, SEO/SEM, Instagram Marketing, TikTok for Business, Analytics. '
        'Hoc vien se thuc hanh chay quang cao that voi ngan sach 5 trieu dong do nha tai tro cap. '
        'Giang vien: Marketing Manager tu Unilever, Nestle, Coca-Cola Viet Nam. '
        'Tuyen 4 sinh vien part-time lam content creator & social media (100k/gio, 15h/tuan).',
    status: EventStatus.published,
    startTime: DateTime(2026, 5, 18, 13, 0),
    endTime: DateTime(2026, 5, 18, 17, 30),
    registerOpenTime: DateTime(2026, 4, 10, 8, 0),
    createdTime: DateTime(2026, 3, 15, 10, 20),
  ),
];
