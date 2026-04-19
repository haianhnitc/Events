# Quy Trình Tích Hợp API Chung

> Hướng dẫn tích hợp API theo mẫu đã áp dụng với luồng Authentication.
> Document này đúc kết từ luồng auth thực tế, tuân thủ nghiêm ngặt Clean Architecture và các quy tắc đã được kiểm chứng.

---

## Mục lục

1. [Tổng quan kiến trúc](#1-tổng-quan-kiến-trúc)
2. [Cấu trúc thư mục](#2-cấu-trúc-thư-mục)
3. [Tầng API Template (nền tảng)](#3-tầng-api-template-nền-tảng)
4. [Quy trình tích hợp từng tầng](#4-quy-trình-tích-hợp-từng-tầng)
5. [Các helper và utility có sẵn](#5-các-helper-và-utility-có-sẵn)
6. [Quy tắc vàng khi tích hợp](#6-quy-tắc-vàng-khi-tích-hợp)
7. [Phân biệt Entity, Model, Params, Request Model](#7-phân-biệt-entity-model-params-request-model)
8. [Luồng API User (người dùng thường)](#8-luồng-api-user-người-dùng-thường)
9. [Luồng API Organizer (ban tổ chức)](#9-luồng-api-organizer-ban-tổ-chức)
10. [Tổng hợp API đã tích hợp theo module](#10-tổng-hợp-api-đã-tích-hợp-theo-module)
11. [Checklist trước khi merge](#11-checklist-trước-khi-merge)

---

## 1. Tổng quan kiến trúc

```
┌─────────────────────────────────────────────────────────────────┐
│                      PRESENTATION LAYER                         │
│  ┌─────────────┐  ┌─────────────┐  ┌──────────────────────┐     │
│  │   Screen/   │  │   Widget    │  │     Controller       │     │
│  │   Page      │  │             │  │       (GetX)         │     │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬───────────┘     │
└─────────┼────────────────┼────────────────────┼──────────────── ┘
          │                │                    │
          └────────────────┴──────────┬─────────┘
                                      │
┌─────────────────────────────────────┼────────────────────────────┐
│                      DOMAIN LAYER   │                            │
│  ┌─────────────────────┐  ┌────────┴─────────┐                   │
│  │       Usecase       │  │    Repository    │                   │
│  │  (Business Logic)   │◄─┤    (Interface)   │                   │
│  └──────────┬──────────┘  └─────────┬────────┘                   │
└─────────────┼────────────────────────┼───────────────────────────┘
              │                        │
┌─────────────┼────────────────────────┼───────────────────────────┐
│             │    DATA LAYER          │                            │
│  ┌──────────┴──────────┐  ┌─────────┴────────┐                   │
│  │   RepositoryImpl     │  │   DataSource     │                   │
│  │  (Model ↔ Entity)  │◄─┤  (API Calls)     │                   │
│  └──────────┬──────────┘  └─────────┬────────┘                   │
└──────────────┼───────────────────────┼────────────────────────────┘
               │                       │
        ┌──────┴──────┐         ┌──────┴──────┐
        │ Model       │         │  API Template│
        │ (JSON/JSON) │         │  (Dio/Http)  │
        └─────────────┘         └──────────────┘
```

### Luồng dữ liệu

```
User Action → Controller → Usecase → Repository (interface)
                                            │
                                    RepositoryImpl
                                            │
                                    DataSource (API call)
                                            │
                                    ApiProvider (HTTP)
                                            │
                                    REST Client (Dio)
                                            │
                                    Backend API
```

---

## 2. Cấu trúc thư mục

### 2.1 Phân chia theo Role

**QUY TẮC VÀNG: API của role nào thì phải nằm đúng folder của phần luồng chức năng và đúng folder role.**

```
lib/
├── authentication/                    # Auth chung
├── feature/
│   ├── attendance/                  # API chung (USER - cả user và organizer đều dùng được)
│   │   ├── data/
│   │   │   ├── model/
│   │   │   └── datasource/
│   │   │       └── attendance_datasource.dart  # USER: scanQr, selfCheckin, getQr
│   │   ├── domain/
│   │   │   ├── entity/              # Share được giữa user và organizer
│   │   │   └── usecase/
│   │   └── presentation/
│   ├── feedback/                    # API chung (USER - cả user và organizer)
│   ├── participant/                 # API chung (USER - lấy thông tin đăng ký của mình)
│   ├── recruitment/                 # API chung (CTV - user xem danh sách tuyển CTV)
│   ├── registration/                # API chung (USER - đăng ký tham gia sự kiện)
│   ├── staff_application/            # API chung (USER - ứng tuyển CTV)
│   ├── ticket/                      # API chung (USER - quản lý vé)
│   ├── news/                        # API chung (USER - xem tin tức)
│   ├── event_management/            # API chung (USER - xem sự kiện)
│   ├── payment/                     # API chung (USER - thanh toán)
│   ├── user_management/             # API chung (USER - quản lý profile)
│   └── organizer/                   # ✅ API dành riêng cho ORGANIZER
│       ├── attendance/              # ✅ Organizer → Điểm danh
│       │   ├── data/
│       │   │   ├── datasource/
│       │   │   └── repository/
│       │   └── domain/
│       ├── feedback/                # ✅ Organizer → Feedback
│       ├── participant/             # ✅ Organizer → Quản lý người tham gia
│       ├── recruitment/             # ✅ Organizer → Tuyển CTV
│       └── staff_application/       # ✅ Organizer → Duyệt đơn ứng tuyển
```

### 2.2 Entity / Model dùng chung

- Nếu entity/model dùng chung cho cả user và organizer → đặt trong `feature/[tên_chung]/`
- VD: `AttendanceQrModel` → `lib/feature/attendance/data/model/`
- VD: `ParticipantModel` → `lib/feature/participant/data/model/`
- Organizer **chỉ cần import** entity/model chung, **không copy** sang folder organizer

### 2.3 File cho 1 API mới

| Tầng         | File                    | Mô tả                        |
| ------------ | ----------------------- | ---------------------------- |
| Domain       | `entity/`               | Business object (DTO Out)    |
| Data         | `model/`                | JSON serialization (Freezed) |
| Domain       | `repository/` interface | Interface để usecase gọi     |
| Data         | `datasource/`           | API calls thực tế            |
| Data         | `repository_impl/`      | Map Model ↔ Entity           |
| Domain       | `usecase/`              | Business logic               |
| Presentation | `controller/`           | GetX controller              |

---

## 3. Tầng API Template (nền tảng)

### 3.1 ApiPath — Định nghĩa endpoint

```dart
// lib/api_template/api_path.dart
class ApiPath {
  // Auth
  static const String authVerify = '/auth/verify';
  static const String authSignup = '/auth/signup';
  static const String authLogout = '/auth/logout';

  // User Management
  static const String usersMe = '/users/me';
  static const String uploadAvatar = '/upload/avatar';
  static const String verificationDocuments = '/verification-documents';
  static const String myVerificationDocuments = '/verification-documents/me';

  // Events
  static const String events = '/events';
  static String eventDetail(int id) => '/events/$id';

  // Registration (User)
  static const String registrations = '/registrations';
  static String registrationDetail(int id) => '/registrations/$id';
  static String registrationCancel(int id) => '/registrations/$id/cancel';

  // Participant (User)
  static const String participants = '/participants';
  static String participantDetail(int id) => '/participants/$id';

  // Recruitment (CTV - User xem)
  static const String recruitments = '/recruitments';
  static String recruitmentDetail(int id) => '/recruitments/$id';
  static String recruitmentQuestions(int id) => '/recruitments/$id/questions';
  static String recruitmentClose(int id) => '/recruitments/$id/close';

  // Staff Application (User ứng tuyển CTV)
  static const String staffApplications = '/staff-applications';
  static String staffApplicationDetail(int id) => '/staff-applications/$id';
  static String staffApplicationApprove(int id) => '/staff-applications/$id/approve';

  // Attendance (User - quét QR)
  static const String attendancesQrParticipant = '/attendances/qr/participant';
  static const String attendancesQrEvent = '/attendances/qr/event';
  static const String attendancesScanQr = '/attendances/scan-qr';
  static const String attendancesSelfCheckin = '/attendances/self-checkin';
  static const String attendances = '/attendances';
  static String attendanceQrParticipant(int eventParticipantId) =>
      '/attendances/qr/participant/$eventParticipantId';
  static String attendanceQrEvent(int eventId) => '/attendances/qr/event/$eventId';

  // Attendance (Organizer - thủ công)
  static const String attendancesManualCheckin = '/attendances/manual-checkin';
  static const String attendancesManualCheckout = '/attendances/manual-checkout';

  // Feedback
  static const String feedbackQuestions = '/feedback-questions';
  static const String feedbacks = '/feedbacks';
  static String feedbackQuestionDetail(int id) => '/feedback-questions/$id';
  static String feedbackDetail(int id) => '/feedbacks/$id';

  // Ticket
  static const String tickets = '/tickets';
  static String ticketDetail(int id) => '/tickets/$id';
  static String ticketStatus(int id) => '/tickets/$id/status';

  // Payment
  static const String sePayPayment = '/finance/sepay-payment';
  static const String transactions = '/finance/transactions';
  static String transactionDetail(int id) => '/finance/transactions/$id';

  // News
  static const String news = '/news';
  static String newsDetail(int id) => '/news/$id';
}
```

### 3.2 ApiResponse — Response wrapper (Freezed)

```dart
@freezed
class ApiResponse<Model> with _$ApiResponse<Model> {
  const factory ApiResponse.success(Model model) = _Success;
  const factory ApiResponse.badRequest(ApiResponseError error) = _BadRequest;
  const factory ApiResponse.unauthorized(ApiResponseError error) = _Unauthorized;
  const factory ApiResponse.forbidden(ApiResponseError error) = _Forbidden;
  const factory ApiResponse.notFound(ApiResponseError error) = _NotFound;
  const factory ApiResponse.conflict(ApiResponseError error) = _Conflict;
  const factory ApiResponse.internalServerError() = _InternalServerError;
  const factory ApiResponse.badGateway() = _BadGateway;
  const factory ApiResponse.serviceUnavailable() = _ServiceUnavailable;
  const factory ApiResponse.gatewayTimeout() = _GatewayTimeout;
  const factory ApiResponse.canceled() = _Canceled;
  const factory ApiResponse.responseParsing() = _ResponseParsing;
  const factory ApiResponse.unexpected(ApiResponseError error) = _Unexpected;
}
```

### 3.3 ApiEnvelope — Backend response envelope

```dart
// Backend luôn trả format:
// { "errorCode": 0, "statusCode": 200, "message": null, "object": {...} }
class ApiEnvelope<T> {
  final int? errorCode;
  final int? statusCode;
  final String? message;
  final T? object;
  bool get isSuccess => (errorCode ?? -1) == 0;
}
```

### 3.4 ApiResponseForwarder — Parse envelope

```dart
// ✅ DÙNG CHO MỌI API CALL
ApiResponse<T> forwardEnvelopeResponse<T>(
  ApiResponse<Map<String, dynamic>> response,
  T Function(Object?) fromJson, {
  String fallbackError = 'Something went wrong',
});

// Extension chuyển sang Either
extension ApiResponseExtension<T> on ApiResponse<T> {
  Either<FailureEntity, T> toEither() { ... }
  Either<FailureEntity, Unit> toEitherUnit() { ... }
  Either<FailureEntity, T?> toEitherNullable() { ... }
}
```

### 3.5 ApiProvider — Base class cho DataSource

```dart
abstract class ApiProvider {
  Future<ApiResponse<Model>> get<Model>(String path, ResponseParser<Model> parser, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    String? contentType,
    bool requireAuth = true,
  });
  Future<ApiResponse<Model>> post<Model>(String path, ResponseParser<Model> parser, {
    ApiRequestBody? body,
    Map<String, String>? headers,
    String? contentType,
    bool requireAuth = true,
  });
  Future<ApiResponse<Model>> put<Model>(String path, ResponseParser<Model> parser, {
    ApiRequestBody? body,
    Map<String, String>? headers,
    String? contentType,
    bool requireAuth = true,
  });
  Future<ApiResponse<Model>> delete<Model>(String path, ResponseParser<Model> parser, {
    ApiRequestBody? body,
    Map<String, String>? headers,
    String? contentType,
    bool requireAuth = true,
  });
  Future<ApiResponse<Model>> upload<Model>(String path, ResponseParser<Model> parser, {
    ApiRequestBody? body,
    Map<String, String>? headers,
    String? contentType,
    bool requireAuth = true,
  });
}
```

**Lưu ý `contentType` và `headers`:**

- **`NRDRestClient` tự động set `Content-Type`** dựa trên `ApiRequestBody` type:
  - `ApiRequestBody.json()` → `application/json`
  - `ApiRequestBody.text()` → `text/plain`
  - `ApiRequestBody.file()` → multipart/form-data
- **KHÔNG cần truyền `contentType` hay `headers: {'Content-Type': ...}` thủ công** — chỉ cần dùng đúng factory constructor:
  - Body là JSON → `ApiRequestBody.json(params.toJson())`
  - Body là plain text → `ApiRequestBody.text(token)`

````

### 3.6 NRDRestClient

- Tự động attach `Authorization: Bearer {token}` khi `requireAuth = true`
- Tự động handle 401 → retry với token mới từ Firebase
- Check network trước mỗi request
- Retry logic cho token refresh

---

## 4. Quy trình tích hợp từng tầng

### Bước 1: Entity (Domain Layer) — Tạo TRƯỚC TIÊN

```dart
// lib/feature/events/domain/entity/event_entity.dart
class EventEntity {
  final int? id;
  final String title;
  final String? description;
  final DateTime? startTime;
  final DateTime? endTime;
  final EventStatus? status;
  final int? organizerId;
  final String? thumbnailUrl;
  final List<CategoryOptionEntity>? categories;
  final VenueEntity? venue;

  EventEntity({...});

  EventEntity copyWith({...});

  @override
  String toString() => 'EventEntity(id: $id, title: $title)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventEntity && other.id == id && other.title == title;
  }

  @override
  int get hashCode => Object.hash(id, title);
}
````

**Quy tắc:**

- Field nào nullable → để `?`
- Enum dùng `MyEnum?` (nullable)
- **Entity PHẢI có**: `copyWith`, `toString`, `==`, `hashCode`
- Không dùng Freezed cho entity

### Bước 2: Model (Data Layer) — Dùng Freezed

```dart
@freezed
class EventModel with _$EventModel {
  factory EventModel.fromJson(Map<String, dynamic> json) => ...;
  factory EventModel.fromEntity(EventEntity entity) => ...;
}

extension EventModelExtension on EventModel {
  EventEntity toEntity() => ...;
}
```

**Sau khi tạo model, chạy build_runner:**

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Bước 3: Repository Interface (Domain Layer)

```dart
// lib/feature/events/domain/repository/event_repository.dart
abstract class EventRepository {
  Future<Either<FailureEntity, List<EventEntity>>> getEvents({...});
  Future<Either<FailureEntity, EventEntity>> getEventById(int id);
}
```

### Bước 4: DataSource (Data Layer)

```dart
// lib/feature/events/data/datasource/event_datasource.dart
abstract class EventDatasource {
  Future<ApiResponse<List<EventModel>>> getEvents({...});
  Future<ApiResponse<EventModel>> getEventById(int id);
}

@Injectable(as: EventDatasource)
class EventDatasourceImpl extends ApiProvider implements EventDatasource {
  EventDatasourceImpl({RestClient? client}) : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<EventModel>> getEventById(int id) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.eventDetail(id),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );
      return forwardEnvelopeResponse<EventModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return EventModel.fromJson(object);
        },
        fallbackError: 'Lấy chi tiết sự kiện thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
```

### Bước 5: Repository Implementation (Data Layer)

```dart
@Injectable(as: EventRepository)
class EventRepositoryImpl implements EventRepository {
  final EventDatasource _datasource;
  EventRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, EventEntity>> getEventById(int id) async {
    final response = await _datasource.getEventById(id);
    return response.toEitherNullable().map((m) => m.toEntity());
  }
}
```

### Bước 6: Usecase (Domain Layer)

```dart
// Params dùng cho 1 usecase → đặt TRONG file usecase
class GetEventsParams {
  final int page;
  final int size;
  const GetEventsParams({this.page = 0, this.size = 20});
}

@injectable
class GetEventsUsecase implements UseCase<List<EventEntity>, GetEventsParams> {
  final EventRepository _repository;
  GetEventsUsecase(this._repository);

  @override
  Future<Either<FailureEntity, List<EventEntity>>> call(GetEventsParams params) async {
    return await _repository.getEvents(page: params.page, size: params.size);
  }
}
```

### Bước 7: Controller (Presentation Layer)

```dart
class EventController extends GetxController {
  final GetEventsUsecase _getEventsUsecase = networkGetIt<GetEventsUsecase>();

  final RxList<EventEntity> events = <EventEntity>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> loadEvents() async {
    if (isLoading.value) return;
    isLoading.value = true;
    final result = await _getEventsUsecase(const GetEventsParams(page: 0, size: 20));
    result.fold(
      (failure) => _handleFailure(failure),
      (data) => events.assignAll(data),
    );
    isLoading.value = false;
  }

  void _handleFailure(FailureEntity failure) {
    failure.when(
      serverFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message),
      dataParsingFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không đọc được dữ liệu'),
      noConnectionFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không có kết nối mạng'),
      systemFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message),
    );
  }
}
```

---

## 5. Các Helper và Utility có sẵn

### 5.1 Upload Helper

```dart
// lib/common/utils/upload_helper.dart

// Chọn 1 ảnh
final result = await ImagePickerService().pickSingleImage();

// Chọn nhiều ảnh
final results = await ImagePickerService().pickMultipleImages();

// Chọn document
final result = await FilePickerService().pickDocument(allowedExtensions: ['jpg', 'pdf']);
```

### 5.2 Permission Helper

```dart
final permissionHelper = PermissionHelper();
await permissionHelper.requestCameraPermission();
await permissionHelper.requestPhotosPermission();
await permissionHelper.requestLocationPermission();
await permissionHelper.openSettings();
```

### 5.3 Snackbar Utils

```dart
AppSnackbarUtils.showSuccess('Thành công', 'Đăng nhập thành công');
AppSnackbarUtils.showError('Lỗi', 'Có lỗi xảy ra');
AppSnackbarUtils.showInfo('Thông báo', 'Đang xử lý...');
```

### 5.4 Network Check

`NRDRestClient` tự động check network trước mỗi request. Nếu không có mạng, trả về `ApiResponse.serviceUnavailable()`.

### 5.5 Retry Logic cho Token Refresh

1. Nhận 401 → kiểm tra `retryCount`
2. Chưa retry → clear token cũ, lấy token mới từ Firebase
3. Gửi lại request với token mới
4. Retry thất bại hoặc đã retry rồi → `signOut()` Firebase

### 5.6 Auth Constants

```dart
// lib/authentication/domain/auth_constants.dart
class AuthConstants {
  AuthConstants._();
  static const String organizerPendingCode = 'ORG_PENDING';
  static const String organizerRejectedCode = 'ORG_REJECTED';
  static const String userDisabledCode = 'USER_DISABLED';
  static const String profileNotFoundCode = '404';    // HTTP 404: Firebase user tồn tại nhưng chưa có profile ở BE
  static const String accountConflictCode = '409';    // HTTP 409: Email đã được đăng ký ở BE (signup trùng)
}
```

---

## 6. Quy tắc vàng khi tích hợp

### 6.1 Enum Mapping

**LUÔN LUÔN tạo extension cho enum để convert API ↔ Code:**

```dart
extension MyEnumApiValue on MyEnum {
  String get apiValue { ... }
  static MyEnum? fromApiValue(Object? rawValue) { ... }
}
```

**KHÔNG BAO GIỜ** dùng trực tiếp giá trị String từ API.

### 6.2 Error Handling

**DataSource:** Wrap mọi API call trong `try-catch`, dùng `mapExceptionToApiResponse`.

```dart
@override
Future<ApiResponse<Model>> getSomething() async {
  try {
    final response = await get<...>(...);
    return forwardEnvelopeResponse<Model>(...);
  } catch (e) {
    return mapExceptionToApiResponse(e);
  }
}
```

**Controller:** Dùng `FailureEntity.when()` đầy đủ 4 trường hợp.

### 6.3 Forwarder Pattern

**LUÔN dùng `forwardEnvelopeResponse`** — điểm parse envelope DUY NHẤT.
**KHÔNG viết `_parseXxxEnvelope` trong datasource.**

```dart
// ✅ ĐÚNG
return forwardEnvelopeResponse<EventModel>(
  response,
  (object) => EventModel.fromJson(object as Map<String, dynamic>),
  fallbackError: 'Lấy chi tiết sự kiện thất bại',
);

// ✅ ĐÚNG — List response
return forwardEnvelopeResponse<List<EventModel>>(
  response,
  (object) {
    final content = (object as Map<String, dynamic>)['content'] as List<dynamic>? ?? [];
    return content.map((e) => EventModel.fromJson(e as Map<String, dynamic>)).toList();
  },
  fallbackError: 'Lấy danh sách thất bại',
);

// ⚠️ LƯU Ý: Khi parse bên trong forwardEnvelopeResponse callback,
// `object` đã là nội dung BÊN TRONG field `object` của envelope gốc.
// KHÔNG parse lại `errorCode` / `message` ở đây.
// Nếu cần kiểm tra errorCode → thêm validation trong callback.
```

### 6.4 Repository trả về Either

**KHÔNG BAO GIỜ** trả trực tiếp `ApiResponse` từ Repository. Luôn convert qua extension:

```dart
// ✅ ĐÚNG
return response.toEither().map((model) => model.toEntity());

// ✅ ĐÚNG - cho void
return response.toEitherUnit();

// ✅ ĐÚNG - cho nullable
return response.toEitherNullable().map((m) => m.toEntity());
```

### 6.5 Model ↔ Entity mapping

**KHÔNG BAO GIỜ** dùng Model trực tiếp ở presentation layer. Luôn convert qua `.toEntity()`.

### 6.6 URL path params

Dùng `replaceAll` cho path params thay vì string interpolation:

```dart
// ✅ ĐÚNG
ApiPath.eventDetail(id)

// ✅ ĐÚNG - inline
ApiPath.eventDetail(eventId)
```

### 6.7 Pagination

Dùng `page` và `size` query params. Response trả về envelope chứa:

```json
{
  "object": {
    "content": [...],
    "pageable": { "pageNumber": 0, "pageSize": 20 },
    "totalElements": 100,
    "totalPages": 5
  }
}
```

### 6.8 Request body cho POST/PUT

```dart
// JSON body
body: ApiRequestBody.json(params.toJson()),

// Plain text (VD: Firebase token) - Content-Type tự động là text/plain
body: ApiRequestBody.text(idToken),
```

### 6.9 Params — Đặt TRONG file Usecase

- Params dùng cho **1 usecase duy nhất** → đặt **bên trong file usecase**
- Params dùng **chung cho nhiều usecase** → đặt trong file `{feature}_params.dart` riêng

```dart
// ✅ ĐÚNG - Params 1 usecase → trong file usecase
class GetEventsParams {
  final int page;
  final int size;
  const GetEventsParams({this.page = 0, this.size = 20});
}

@injectable
class GetEventsUsecase implements UseCase<List<EventEntity>, GetEventsParams> { ... }
```

```dart
// ✅ ĐÚNG - Params dùng chung → file riêng
// lib/feature/feedback/domain/usecase/submit_feedback_params.dart
class SubmitFeedbackParams {
  final int eventId;
  final String? comment;
  final List<FeedbackAnswerItem> answers;
  ...
}
```

### 6.10 Repository nhận Params (không phải từng field riêng lẻ)

**QUY TẮC:** Repository interface và implementation nhận **Params object**, không truyền từng field.

```dart
// ✅ ĐÚNG - Repository nhận Params object
abstract class UserRepository {
  Future<Either<FailureEntity, UserEntity?>> updateCurrentUser(
      UpdateCurrentUserParams params);
}

// ❌ SAI - Truyền từng field riêng lẻ
abstract class UserRepository {
  Future<Either<FailureEntity, UserEntity?>> getMyTickets(int userId, {int page, int size});
}
```

### 6.11 API theo Role — Đặt đúng folder

**NGUYÊN TẮC VÀNG:** API của role nào thì phải nằm đúng folder.

| API thuộc về                    | Nằm trong                          | Ví dụ                                  |
| ------------------------------- | ---------------------------------- | -------------------------------------- |
| User / Chế độ người dùng thường | `lib/feature/{feature}/`           | `attendance_datasource.dart`           |
| Organizer / Ban tổ chức         | `lib/feature/organizer/{feature}/` | `organizer_attendance_datasource.dart` |
| CTV (Cộng tác viên)             | `lib/feature/recruitment/`         | `ctv_recruitment_datasource.dart`      |

**KHÔNG BAO GIỜ** đặt API của organizer vào folder chung user.

### 6.12 RequireAuth

- **`requireAuth: false`**: Endpoint công khai (không cần đăng nhập)
  - `GET /news` — Tin tức công khai ✅
  - `GET /recruitments` — Danh sách tuyển CTV công khai ✅
  - `GET /feedback-questions` — Câu hỏi feedback công khai ✅
- **`requireAuth: true`**: Tất cả endpoint cần xác thực (mặc định nên đặt `true`)

### 6.13 Import thứ tự

1. `dart:` packages
2. `package:` third-party
3. `package:events_app/` internal packages (theo độ sâu thư mục)
4. relative imports

---

## 7. Phân biệt Entity, Model, Params, Request Model

### Tổng quan

| Loại              | Mục đích                                            | Dùng khi nào                                | Đặt ở đâu         |
| ----------------- | --------------------------------------------------- | ------------------------------------------- | ----------------- |
| **Entity**        | Kết quả trả về từ BE (DTO Out)                      | Parsing response, dùng trong business logic | `domain/entity/`  |
| **Model**         | JSON serialization + Entity mapping                 | Parsing JSON, gửi/nhận data                 | `data/model/`     |
| **Params**        | Param truyền vào usecase (DTO In cho create/update) | Gọi usecase từ controller                   | `domain/usecase/` |
| **Request Model** | Body gửi lên API (DTO In)                           | Serialize JSON body cho POST/PUT            | `data/model/`     |

### Luồng dữ liệu

```
Controller → Params → Usecase → Repository
                              ↓
                         Request Model (toJson)   ← chỉ khi cần serialize phức tạp
                              ↓
                         DataSource (API call)
                              ↓
                         Model (fromJson)
                              ↓
                         Entity
                              ↓
                         Controller
```

### Ví dụ: Submit Feedback Flow

1. **Controller** tạo `SubmitFeedbackParams` từ form input
2. **Usecase** nhận params, truyền xuống repository
3. **Repository** nhận params, tạo body `params.toJson()`, gọi datasource
4. **DataSource** gọi API với `ApiRequestBody.json(params.toJson())`
5. **Backend** trả về `FeedbackDtoOut` → parse thành `FeedbackModel`
6. **FeedbackModel** → `FeedbackEntity` để dùng trong app

---

## 8. Luồng API User (người dùng thường)

### 8.1 Authentication

| API                              | Method   | Endpoint                     | Mô tả                                                |
| -------------------------------- | -------- | ---------------------------- | ---------------------------------------------------- |
| Đăng nhập email/password         | POST     | `/auth/verify`               | Firebase signIn → verify token                       |
| Đăng ký email/password           | POST     | `/auth/signup`               | Firebase create → signup                             |
| **Bước 1** Google                | -        | Firebase SDK                 | `SignInWithGoogleOnlyUsecase` → `GoogleSignInResult` |
| **Bước 2a** Google (existing)    | POST     | `/auth/verify`               | `SignInWithGoogleExistingUserUsecase` → verify BE    |
| **Bước 2b** Google (new/pending) | POST     | `/auth/signup`               | `SignUpWithGoogleUsecase` → signup BE                |
| Đăng xuất                        | POST     | `/auth/logout`               | Logout BE → Firebase signOut                         |
| Lấy thông tin user hiện tại      | GET      | `/users/me`                  | Bootstrap session                                    |
| Quên mật khẩu                    | Firebase | SDK                          | Firebase sendPasswordResetEmail                      |
| Upload tài liệu xác thực         | POST     | `/verification-documents`    | multipart/form upload                                |
| Lấy tài liệu xác thực            | GET      | `/verification-documents/me` | Danh sách tài liệu đã upload                         |

**Luồng Email/Password Sign-In — PHÂN BIỆT case user chưa có profile ở BE:**

```
User nhập email + password → click Đăng nhập
         ↓
  Firebase signInWithEmailAndPassword
         ↓
  POST /auth/verify (với Firebase idToken)
         ↓
  ├── 200 + user → Đăng nhập thành công ✅
  ├── 404 (profileNotFoundCode) → Firebase user tồn tại nhưng chưa có ở BE:
  │      ↓
  │   AppSnackbar: "Tài khoản chưa hoàn tất đăng ký"
  │      ↓
  │   Dialog: [Sinh viên] [Tổ chức]
  │      ↓
  │   Navigate sang GoogleRegisterScreen
  │   (email đã pre-fill từ Firebase user)
  │      ↓
  │   Điền form → POST /auth/signup → Tạo user ở BE
  ├── 409 (accountConflictCode) → Email đã tồn tại ở BE:
  │      ↓
  │   AppSnackbar: "Tài khoản đã tồn tại"
  │   Firebase signOut → Navigate về /login
  ├── Organizer pending/rejected/disabled → Navigate tương ứng
  └── Firebase exception (wrong-password, etc.) → "Email hoặc mật khẩu không đúng"
```

```
User click "Sign in with Google"
         ↓
  BƯỚC 1: Firebase Google Auth
  SignInWithGoogleOnlyUsecase (NoParams)
  → Gọi GoogleSignIn.signIn() → Firebase Auth
  → Trả về GoogleSignInResult (firebaseUid, idToken, isNewUser, email)
         ↓
  ├── isNewUser = true (Firebase user mới):
  │      ↓
  │   Dialog: [Sinh viên] [Tổ chức]
  │      ↓
  │   Navigate sang GoogleRegisterScreen
  │   (form không có email/password - đã có từ Google)
  │      ↓
  │   submitGoogleRegister() → SignUpWithGoogleUsecase
  │      ↓
  │   POST /auth/signup với firebaseIdToken
  │      ↓
  │   ├── 409 CONFLICT → "Email đã được đăng ký" (user đã tồn tại ở BE)
  │   └── 200 → Đăng ký thành công ✅
  │
  └── isNewUser = false (Firebase user cũ):
         ↓
      BƯỚC 2A: SignInWithGoogleExistingUserUsecase(firebaseUid)
         ↓
      POST /auth/verify với idToken
         ↓
      ├── 200 → Đăng nhập thành công ✅
      └── 404 (profileNotFoundCode) → User chưa có ở BE:
               ↓
            _navigateToIncompleteEmailRegistration()
               ↓
            Dialog: [Sinh viên] [Tổ chức]
               ↓
            Navigate sang GoogleRegisterScreen (isGoogleRegister: true)
               ↓
            Lấy idToken từ FirebaseAuth.instance.currentUser
               ↓
            submitGoogleRegister() → SignUpWithGoogleUsecase
               ↓
            POST /auth/signup → Tạo user ở BE
```

**3 Usecase trong `signin_with_google_usecase.dart`:**

| Usecase                               | Input                    | Trả về                                      | Mục đích                                |
| ------------------------------------- | ------------------------ | ------------------------------------------- | --------------------------------------- |
| `SignInWithGoogleOnlyUsecase`         | `NoParams`               | `Either<FailureEntity, GoogleSignInResult>` | Bước 1: Firebase Google Auth            |
| `SignInWithGoogleExistingUserUsecase` | `String` (firebaseUid)   | `Either<FailureEntity, UserEntity?>`        | Bước 2a: Verify BE cho Firebase user cũ |
| `SigninWithGoogleUsecase` (legacy)    | `SignInWithGoogleParams` | throw `UnimplementedError`                  | **DEPRECATED** — dùng 2 usecase trên    |

**Class `GoogleSignInResult` trong `auth_datasource.dart`:**

| Property       | Type      | Mô tả                      |
| -------------- | --------- | -------------------------- |
| `firebaseUid`  | `String?` | Firebase user ID           |
| `idToken`      | `String?` | Firebase ID token          |
| `accessToken`  | `String?` | Google access token        |
| `isNewUser`    | `bool`    | Firebase user mới hay cũ   |
| `email`        | `String?` | Email từ Google            |
| `errorCode`    | `String?` | Mã lỗi (null = thành công) |
| `errorMessage` | `String?` | Thông báo lỗi              |

Factories: `GoogleSignInResult.success()`, `.canceled()`, `.error()`.

**Case đặc biệt - User back giữa chừng:**

- User bấm Google → Firebase tạo user → Back → Tắt app → Mở lại bấm Google
- Firebase vẫn logged in, `isNewUser = false`
- BE verify lỗi (user chưa có) → `_handleIncompleteGoogleRegistration()`
- Lấy lại idToken từ `FirebaseAuth.instance.currentUser`
- Navigate sang form hoàn thành đăng ký

### 8.2 User Management

| API                | Method | Endpoint         | Mô tả                           |
| ------------------ | ------ | ---------------- | ------------------------------- |
| Lấy thông tin user | GET    | `/users/me`      | Bootstrap session               |
| Cập nhật profile   | PUT    | `/users/me`      | Update user info                |
| Upload avatar      | POST   | `/upload/avatar` | multipart/form → trả về CDN URL |

### 8.3 Events

| API                   | Method | Endpoint       | Mô tả                                                  |
| --------------------- | ------ | -------------- | ------------------------------------------------------ |
| Lấy danh sách sự kiện | GET    | `/events`      | Hỗ trợ filter: categoryId, status, keyword, pagination |
| Lấy chi tiết sự kiện  | GET    | `/events/{id}` | Chi tiết đầy đủ                                        |

**Flow:** User duyệt sự kiện → Filter theo category/status → Xem chi tiết → Đăng ký tham gia.

### 8.4 Registration (Đăng ký tham gia sự kiện)

| API                            | Method | Endpoint                     | Mô tả                                           |
| ------------------------------ | ------ | ---------------------------- | ----------------------------------------------- |
| Đăng ký tham gia               | POST   | `/registrations`             | Tạo registration → nếu có vé thì cần thanh toán |
| Lấy danh sách đăng ký của mình | GET    | `/registrations?userId=...`  | Phân trang                                      |
| Lấy chi tiết đăng ký           | GET    | `/registrations/{id}`        | Chi tiết 1 registration                         |
| Hủy đăng ký                    | DELETE | `/registrations/{id}/cancel` | Hủy participation                               |

### 8.5 Attendance (Điểm danh)

| API                    | Method | Endpoint                                           | Mô tả                              |
| ---------------------- | ------ | -------------------------------------------------- | ---------------------------------- |
| Lấy QR cá nhân         | GET    | `/attendances/qr/participant/{eventParticipantId}` | QR để staff scan                   |
| Lấy QR sự kiện         | GET    | `/attendances/qr/event/{eventId}`                  | QR để staff scan (vé miễn phí)     |
| Quét QR (CTV)          | POST   | `/attendances/scan-qr`                             | CTV scan QR code của người tham dự |
| Tự check-in (không vé) | POST   | `/attendances/self-checkin`                        | Check-in không cần QR              |

**Flow:**

```
User đăng ký thành công
         ↓
  MyQrPage: Lấy danh sách participant của mình
         ↓
  Với mỗi participant đang active:
    ├── Có ticketId → getParticipantQr
    └── Không có ticketId → getEventQr
         ↓
  QR được hiển thị, tự động refresh khi hết hạn
```

### 8.6 Feedback (Người dùng gửi feedback)

| API                  | Method | Endpoint                          | Mô tả              | requireAuth |
| -------------------- | ------ | --------------------------------- | ------------------ | ----------- |
| Lấy câu hỏi feedback | GET    | `/feedback-questions?eventId=...` | Danh sách câu hỏi  | false       |
| Gửi feedback         | POST   | `/feedbacks`                      | Submit câu trả lời | true        |

### 8.7 Recruitment (CTV tuyển dụng)

| API                     | Method | Endpoint                       | Mô tả                 | requireAuth |
| ----------------------- | ------ | ------------------------------ | --------------------- | ----------- |
| Lấy danh sách tuyển CTV | GET    | `/recruitments`                | Public, hỗ trợ filter | false       |
| Lấy chi tiết tuyển CTV  | GET    | `/recruitments/{id}`           | Chi tiết              | false       |
| Lấy câu hỏi ứng tuyển   | GET    | `/recruitments/{id}/questions` | Danh sách câu hỏi     | false       |

### 8.8 Staff Application (Ứng tuyển CTV)

| API               | Method | Endpoint                   | Mô tả               |
| ----------------- | ------ | -------------------------- | ------------------- |
| Nộp đơn ứng tuyển | POST   | `/staff-applications`      | Gửi answers + cvUrl |
| Lấy chi tiết đơn  | GET    | `/staff-applications/{id}` | Chi tiết đơn đã nộp |

**⚠️ LƯU Ý QUAN TRỌNG:** `ApplyCtvParams.eventId` phải là **eventId** (ID của sự kiện), KHÔNG phải `ctvRecruitmentId`. Luôn resolve từ recruitment entity trước khi gọi API.

### 8.9 Ticket

| API                       | Method | Endpoint               | Mô tả                 |
| ------------------------- | ------ | ---------------------- | --------------------- |
| Lấy danh sách vé của mình | GET    | `/tickets?userId=...`  | Phân trang            |
| Lấy chi tiết vé           | GET    | `/tickets/{id}`        | Chi tiết 1 vé         |
| Cập nhật trạng thái vé    | PUT    | `/tickets/{id}/status` | Update status + notes |

### 8.10 Payment

| API                      | Method | Endpoint                     | Mô tả                       |
| ------------------------ | ------ | ---------------------------- | --------------------------- |
| Tạo thanh toán SePay     | POST   | `/finance/sepay-payment`     | Tạo QR thanh toán           |
| Lấy trạng thái giao dịch | GET    | `/finance/transactions/{id}` | Poll để kiểm tra thanh toán |

**Flow thanh toán:**

```
User đăng ký → có ticket
         ↓
  Tạo payment (POST /finance/sepay-payment)
         ↓
  Nhận orderId, qrCodeUrl
         ↓
  Poll (GET /finance/transactions/{id}) mỗi 2s
         ↓
  Payment thành công → vé được kích hoạt
```

### 8.11 News

| API                   | Method | Endpoint     | Mô tả                  | requireAuth |
| --------------------- | ------ | ------------ | ---------------------- | ----------- |
| Lấy danh sách tin tức | GET    | `/news`      | Public, hỗ trợ keyword | false       |
| Lấy chi tiết tin tức  | GET    | `/news/{id}` | Chi tiết               | false       |

---

## 9. Luồng API Organizer (Ban tổ chức)

### 9.1 Attendance (Organizer điểm danh)

| API                | Method | Endpoint                                           | Mô tả                                           |
| ------------------ | ------ | -------------------------------------------------- | ----------------------------------------------- |
| Lấy QR sự kiện     | GET    | `/attendances/qr/event/{eventId}`                  | QR để phát cho attendee                         |
| Lấy QR cá nhân     | GET    | `/attendances/qr/participant/{eventParticipantId}` | QR cá nhân                                      |
| Check-in thủ công  | POST   | `/attendances/manual-checkin`                      | Check-in không QR                               |
| Check-out thủ công | POST   | `/attendances/manual-checkout`                     | Check-out thủ công                              |
| Lấy log điểm danh  | GET    | `/attendances`                                     | Danh sách attendance log, hỗ trợ eventId filter |

### 9.2 Feedback (Organizer quản lý feedback)

| API                                | Method | Endpoint                          | Mô tả                         |
| ---------------------------------- | ------ | --------------------------------- | ----------------------------- |
| Tạo câu hỏi feedback               | POST   | `/feedback-questions`             | Tạo 1 câu hỏi                 |
| Lấy câu hỏi feedback               | GET    | `/feedback-questions?eventId=...` | Danh sách câu hỏi             |
| Lấy chi tiết câu hỏi               | GET    | `/feedback-questions/{id}`        | Chi tiết 1 câu hỏi            |
| Xóa câu hỏi feedback               | DELETE | `/feedback-questions`             | Body: JSON array `[id1, id2]` |
| Lấy danh sách feedback submissions | GET    | `/feedbacks`                      | Hỗ trợ eventId filter         |
| Lấy chi tiết feedback submission   | GET    | `/feedbacks/{id}`                 | Chi tiết 1 submission         |

### 9.3 Participant (Organizer quản lý người tham gia)

| API                       | Method | Endpoint             | Mô tả                                  |
| ------------------------- | ------ | -------------------- | -------------------------------------- |
| Lấy danh sách participant | GET    | `/participants`      | Hỗ trợ eventId, participantType filter |
| Lấy chi tiết participant  | GET    | `/participants/{id}` | Chi tiết 1 participant                 |
| Tạo participant thủ công  | POST   | `/participants`      | Thêm participant không qua đăng ký     |
| Xóa participant           | DELETE | `/participants/{id}` | Xóa participant                        |

### 9.4 Recruitment (Organizer tuyển CTV)

| API                     | Method | Endpoint                   | Mô tả                 |
| ----------------------- | ------ | -------------------------- | --------------------- |
| Lấy danh sách tuyển CTV | GET    | `/recruitments`            | Hỗ trợ eventId filter |
| Lấy chi tiết tuyển CTV  | GET    | `/recruitments/{id}`       | Chi tiết              |
| Tạo tuyển CTV           | POST   | `/recruitments`            | Tạo đợt tuyển mới     |
| Cập nhật tuyển CTV      | PUT    | `/recruitments/{id}`       | Chỉnh sửa             |
| Đóng tuyển CTV          | PATCH  | `/recruitments/{id}/close` | Đóng đợt tuyển        |
| Xóa tuyển CTV           | DELETE | `/recruitments/{id}`       | Xóa đợt tuyển         |

### 9.5 Staff Application (Organizer duyệt đơn ứng tuyển CTV)

| API                         | Method | Endpoint                           | Mô tả                         |
| --------------------------- | ------ | ---------------------------------- | ----------------------------- |
| Lấy danh sách đơn ứng tuyển | GET    | `/staff-applications`              | Hỗ trợ eventId, status filter |
| Lấy chi tiết đơn            | GET    | `/staff-applications/{id}`         | Chi tiết                      |
| Duyệt/từ chối đơn           | PUT    | `/staff-applications/{id}/approve` | isApproved + feedback         |

---

## 10. Tổng hợp API đã tích hợp theo module

### 10.1 Tổng quan số lượng

| Module                            | Layer      | Số lượng API |
| --------------------------------- | ---------- | ------------ |
| **Authentication**                | DataSource | 8 API        |
| **User Management**               | DataSource | 3 API        |
| **Event Management**              | DataSource | 2 API        |
| **News**                          | DataSource | 2 API        |
| **Registration**                  | DataSource | 4 API        |
| **Participant**                   | DataSource | 2 API        |
| **Attendance (User)**             | DataSource | 4 API        |
| **Attendance (Organizer)**        | DataSource | 5 API        |
| **Feedback (User)**               | DataSource | 2 API        |
| **Feedback (Organizer)**          | DataSource | 6 API        |
| **Recruitment (CTV/User)**        | DataSource | 3 API        |
| **Recruitment (Organizer)**       | DataSource | 6 API        |
| **Staff Application (User)**      | DataSource | 2 API        |
| **Staff Application (Organizer)** | DataSource | 3 API        |
| **Ticket**                        | DataSource | 3 API        |
| **Payment**                       | DataSource | 2 API        |
| **TỔNG CỘNG**                     |            | **57 API**   |

### 10.2 Chi tiết theo Module

#### Authentication (`lib/authentication/data/datasource/auth_datasource.dart`)

| Method                         | Endpoint                     | Method HTTP   | Mô tả                                                                                               |
| ------------------------------ | ---------------------------- | ------------- | --------------------------------------------------------------------------------------------------- |
| `signInWithEmailAndPassword`   | `/auth/verify`               | POST          | Firebase signIn → verify token (body: JSON)                                                         |
| `signUpWithEmailAndPassword`   | `/auth/signup`               | POST          | Firebase create → signup (body: JSON)                                                               |
| `signInWithGoogleOnly`         | -                            | -             | **Bước 1:** Chỉ Firebase Google auth, trả về `GoogleSignInResult` (firebaseUid, idToken, isNewUser) |
| `signInWithGoogleExistingUser` | `/auth/verify`               | POST          | **Bước 2a:** Verify token cho Firebase user cũ đã đăng ký BE                                        |
| `signUpWithGoogle`             | `/auth/signup`               | POST          | **Bước 2b:** Signup cho user mới Google (isNewUser=true hoặc user chưa hoàn tất)                    |
| `signOut`                      | `/auth/logout`               | POST          | Logout BE → Firebase signOut                                                                        |
| `getCurrentUser`               | `/users/me`                  | GET           | Lấy thông tin user hiện tại                                                                         |
| `sendPasswordResetEmail`       | Firebase SDK                 | -             | Firebase sendPasswordResetEmail                                                                     |
| `uploadVerificationDocument`   | `/verification-documents`    | POST (upload) | multipart/form upload                                                                               |
| `getMyVerificationDocuments`   | `/verification-documents/me` | GET           | Danh sách tài liệu đã upload                                                                        |

> ⚠️ `signInWithGoogle` (one-step) đã **deprecated** — thay bằng two-step: `signInWithGoogleOnly` + `signInWithGoogleExistingUser`/`signUpWithGoogle`.

#### User Management (`lib/feature/user_management/data/datasource/user_datasource.dart`)

- `getCurrentUser` → GET `/users/me`
- `updateCurrentUser` → PUT `/users/me`
- `uploadAvatar` → POST `/upload/avatar` (upload)

#### Event Management (`lib/feature/event_management/data/datasource/event_datasource.dart`)

- `getEvents` → GET `/events`
- `getEventById` → GET `/events/{id}`

#### News (`lib/feature/news/data/datasource/news_datasource.dart`)

- `getNewsList` → GET `/news` (requireAuth: false)
- `getNewsById` → GET `/news/{id}` (requireAuth: false)

#### Registration (`lib/feature/registration/data/datasource/registration_datasource.dart`)

- `createRegistration` → POST `/registrations`
- `getMyRegistrations` → GET `/registrations?userId=...`
- `getRegistrationById` → GET `/registrations/{id}`
- `cancelRegistration` → DELETE `/registrations/{id}/cancel`

#### Participant (User) (`lib/feature/participant/data/datasource/participant_datasource.dart`)

- `getMyParticipants` → GET `/participants?userId=...`
- `getParticipantById` → GET `/participants/{id}`

#### Attendance User (`lib/feature/attendance/data/datasource/attendance_datasource.dart`)

- `getParticipantQr` → GET `/attendances/qr/participant/{eventParticipantId}`
- `getEventQr` → GET `/attendances/qr/event/{eventId}`
- `scanQr` → POST `/attendances/scan-qr`
- `selfCheckin` → POST `/attendances/self-checkin`

#### Attendance Organizer (`lib/feature/organizer/attendance/data/datasource/organizer_attendance_datasource.dart`)

- `getEventQr` → GET `/attendances/qr/event/{eventId}`
- `getParticipantQr` → GET `/attendances/qr/participant/{eventParticipantId}`
- `manualCheckIn` → POST `/attendances/manual-checkin`
- `manualCheckOut` → POST `/attendances/manual-checkout`
- `getAttendanceLogs` → GET `/attendances`

#### Feedback User (`lib/feature/feedback/data/datasource/feedback_datasource.dart`)

- `getFeedbackQuestions` → GET `/feedback-questions?eventId=...` (requireAuth: false)
- `submitFeedback` → POST `/feedbacks`

#### Feedback Organizer (`lib/feature/organizer/feedback/data/datasource/organizer_feedback_datasource.dart`)

- `createFeedbackQuestion` → POST `/feedback-questions`
- `getFeedbackQuestionById` → GET `/feedback-questions/{id}`
- `getFeedbackQuestions` → GET `/feedback-questions?eventId=...`
- `deleteFeedbackQuestions` → DELETE `/feedback-questions` (body: JSON array)
- `getFeedbacks` → GET `/feedbacks`
- `getFeedbackById` → GET `/feedbacks/{id}`

#### Recruitment User/CTV (`lib/feature/recruitment/data/datasource/ctv_recruitment_datasource.dart`)

- `getRecruitments` → GET `/recruitments` (requireAuth: false)
- `getRecruitmentById` → GET `/recruitments/{id}` (requireAuth: false)
- `getRecruitmentQuestions` → GET `/recruitments/{id}/questions` (requireAuth: false)

#### Recruitment Organizer (`lib/feature/organizer/recruitment/data/datasource/organizer_recruitment_datasource.dart`)

- `getRecruitments` → GET `/recruitments`
- `getRecruitmentById` → GET `/recruitments/{id}`
- `createRecruitment` → POST `/recruitments`
- `updateRecruitment` → PUT `/recruitments/{id}`
- `closeRecruitment` → PATCH `/recruitments/{id}/close`
- `deleteRecruitment` → DELETE `/recruitments/{id}`

#### Staff Application User (`lib/feature/staff_application/data/datasource/staff_application_datasource.dart`)

- `createApplication` → POST `/staff-applications`
- `getApplicationById` → GET `/staff-applications/{id}`

#### Staff Application Organizer (`lib/feature/organizer/staff_application/data/datasource/organizer_staff_application_datasource.dart`)

- `getStaffApplications` → GET `/staff-applications`
- `getStaffApplicationById` → GET `/staff-applications/{id}`
- `approveStaffApplication` → PUT `/staff-applications/{id}/approve`

#### Ticket (`lib/feature/ticket/data/datasource/ticket_datasource.dart`)

- `getMyTickets` → GET `/tickets?userId=...`
- `getTicketById` → GET `/tickets/{id}`
- `updateTicketStatus` → PUT `/tickets/{id}/status`

#### Payment (`lib/feature/payment/data/datasource/sepay_payment_datasource.dart`)

- `createSePayPayment` → POST `/finance/sepay-payment`
- `getTransactionById` → GET `/finance/transactions/{id}`

---

## 11. Checklist trước khi merge

### Cấu trúc

- [ ] Entity tạo đúng cấu trúc, field nullable đúng (DTO Out từ backend)
- [ ] Entity PHẢI có `copyWith`, `toString`, `==`, `hashCode`
- [ ] Model dùng Freezed, có `fromJson`, `fromEntity`, `toEntity`
- [ ] **API được đặt đúng folder theo role** (user → `feature/`, organizer → `feature/organizer/`)
- [ ] Entity/Model chung reuse được, không copy sang folder role
- [ ] Chạy `dart run build_runner build` thành công

### DataSource

- [ ] **API đặt đúng folder theo role** — Organizer không đặt trong folder user
- [ ] Datasource dùng `forwardEnvelopeResponse` — KHÔNG viết `_parseXxxEnvelope`
- [ ] Datasource kế thừa `ApiProvider`
- [ ] Mọi API call trong `try-catch` với `mapExceptionToApiResponse`
- [ ] `requireAuth` đúng: `false` cho endpoint public, `true` cho endpoint cần xác thực

### Repository

- [ ] Repository nhận **Params object** (không truyền từng field riêng lẻ)
- [ ] Repository convert `ApiResponse` → `Either` qua extension
- [ ] Repository trả về `Either<FailureEntity, T>` — không trả trực tiếp `ApiResponse`

### Usecase & Params

- [ ] Params đặt **TRONG file usecase** (nếu chỉ dùng cho 1 usecase)
- [ ] Params dùng chung → file `{feature}_params.dart` riêng
- [ ] Usecase implement `UseCase<T, P>` interface, có `@injectable`

### Enum & Type Safety

- [ ] Enum có extension `apiValue` và `fromApiValue`
- [ ] Null safety được handle (không crash với nullable)
- [ ] Upload file có `originalFileName` trong form-data (nếu backend cần)

### Presentation Layer

- [ ] Controller dùng GetX/Rx, handle `FailureEntity.when()` đầy đủ 4 trường hợp
- [ ] Error message hiển thị cho user (dùng `AppSnackbarUtils`)
- [ ] Loading state được set/unset đúng
- [ ] Endpoint paths thêm vào `ApiPath`
- [ ] Code clean, không duplicate logic

### ⚠️ Các bug đã được phát hiện và sửa

1. **ĐÃ SỬA**: `CtvController.submitCtvApplication` truyền `ctvRecruitmentId` vào `ApplyCtvParams.eventId` — phải resolve `eventId` từ recruitment entity trước khi gọi.
2. **ĐÃ SỬA**: `UserDatasource.uploadAvatar` parse envelope sai tầng — trong callback của `forwardEnvelopeResponse`, `object` đã là nội dung bên trong envelope, không chứa `errorCode`.
3. **ĐÃ THÊM**: HTTP 409 Conflict — `/auth/verify` trả 404 khi Firebase user tồn tại nhưng chưa có ở BE; `/auth/signup` trả 409 khi user đã tồn tại. Cần xử lý `conflict` trong mọi `ApiResponse.when()` dùng `forwardEnvelopeResponse` hoặc transport-level switch.
4. **CẦN CHẠY**: `flutter pub run build_runner build` sau khi thêm `ApiResponse.conflict` (union case mới trong freezed class).
