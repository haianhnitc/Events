// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventModel _$EventModelFromJson(Map<String, dynamic> json) {
  return _EventModel.fromJson(json);
}

/// @nodoc
mixin _$EventModel {
  int? get eventId => throw _privateConstructorUsedError;
  String? get organizerName => throw _privateConstructorUsedError;
  VenueModel? get venue => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get banner => throw _privateConstructorUsedError;
  EventStatus? get status => throw _privateConstructorUsedError;
  DateTime? get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  DateTime? get registerOpenTime => throw _privateConstructorUsedError;
  int? get price => throw _privateConstructorUsedError;
  List<CategoryModel>? get categories => throw _privateConstructorUsedError;
  int? get rewardCoin => throw _privateConstructorUsedError;
  int? get youthUnionPoint => throw _privateConstructorUsedError;
  String? get certificateName => throw _privateConstructorUsedError;
  DateTime? get createdTime => throw _privateConstructorUsedError;
  int? get totalParticipants => throw _privateConstructorUsedError;
  UserEventState? get userEventState => throw _privateConstructorUsedError;
  EventRecruitmentType? get recruitmentType =>
      throw _privateConstructorUsedError;
  int? get viewCount => throw _privateConstructorUsedError;
  DateTime? get lastViewedTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventModelCopyWith<EventModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventModelCopyWith<$Res> {
  factory $EventModelCopyWith(
          EventModel value, $Res Function(EventModel) then) =
      _$EventModelCopyWithImpl<$Res, EventModel>;
  @useResult
  $Res call(
      {int? eventId,
      String? organizerName,
      VenueModel? venue,
      String? title,
      String? description,
      String? banner,
      EventStatus? status,
      DateTime? startTime,
      DateTime? endTime,
      DateTime? registerOpenTime,
      int? price,
      List<CategoryModel>? categories,
      int? rewardCoin,
      int? youthUnionPoint,
      String? certificateName,
      DateTime? createdTime,
      int? totalParticipants,
      UserEventState? userEventState,
      EventRecruitmentType? recruitmentType,
      int? viewCount,
      DateTime? lastViewedTime});

  $VenueModelCopyWith<$Res>? get venue;
}

/// @nodoc
class _$EventModelCopyWithImpl<$Res, $Val extends EventModel>
    implements $EventModelCopyWith<$Res> {
  _$EventModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = freezed,
    Object? organizerName = freezed,
    Object? venue = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? banner = freezed,
    Object? status = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? registerOpenTime = freezed,
    Object? price = freezed,
    Object? categories = freezed,
    Object? rewardCoin = freezed,
    Object? youthUnionPoint = freezed,
    Object? certificateName = freezed,
    Object? createdTime = freezed,
    Object? totalParticipants = freezed,
    Object? userEventState = freezed,
    Object? recruitmentType = freezed,
    Object? viewCount = freezed,
    Object? lastViewedTime = freezed,
  }) {
    return _then(_value.copyWith(
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int?,
      organizerName: freezed == organizerName
          ? _value.organizerName
          : organizerName // ignore: cast_nullable_to_non_nullable
              as String?,
      venue: freezed == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as VenueModel?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      banner: freezed == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatus?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      registerOpenTime: freezed == registerOpenTime
          ? _value.registerOpenTime
          : registerOpenTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
      categories: freezed == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategoryModel>?,
      rewardCoin: freezed == rewardCoin
          ? _value.rewardCoin
          : rewardCoin // ignore: cast_nullable_to_non_nullable
              as int?,
      youthUnionPoint: freezed == youthUnionPoint
          ? _value.youthUnionPoint
          : youthUnionPoint // ignore: cast_nullable_to_non_nullable
              as int?,
      certificateName: freezed == certificateName
          ? _value.certificateName
          : certificateName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalParticipants: freezed == totalParticipants
          ? _value.totalParticipants
          : totalParticipants // ignore: cast_nullable_to_non_nullable
              as int?,
      userEventState: freezed == userEventState
          ? _value.userEventState
          : userEventState // ignore: cast_nullable_to_non_nullable
              as UserEventState?,
      recruitmentType: freezed == recruitmentType
          ? _value.recruitmentType
          : recruitmentType // ignore: cast_nullable_to_non_nullable
              as EventRecruitmentType?,
      viewCount: freezed == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int?,
      lastViewedTime: freezed == lastViewedTime
          ? _value.lastViewedTime
          : lastViewedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $VenueModelCopyWith<$Res>? get venue {
    if (_value.venue == null) {
      return null;
    }

    return $VenueModelCopyWith<$Res>(_value.venue!, (value) {
      return _then(_value.copyWith(venue: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventModelImplCopyWith<$Res>
    implements $EventModelCopyWith<$Res> {
  factory _$$EventModelImplCopyWith(
          _$EventModelImpl value, $Res Function(_$EventModelImpl) then) =
      __$$EventModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? eventId,
      String? organizerName,
      VenueModel? venue,
      String? title,
      String? description,
      String? banner,
      EventStatus? status,
      DateTime? startTime,
      DateTime? endTime,
      DateTime? registerOpenTime,
      int? price,
      List<CategoryModel>? categories,
      int? rewardCoin,
      int? youthUnionPoint,
      String? certificateName,
      DateTime? createdTime,
      int? totalParticipants,
      UserEventState? userEventState,
      EventRecruitmentType? recruitmentType,
      int? viewCount,
      DateTime? lastViewedTime});

  @override
  $VenueModelCopyWith<$Res>? get venue;
}

/// @nodoc
class __$$EventModelImplCopyWithImpl<$Res>
    extends _$EventModelCopyWithImpl<$Res, _$EventModelImpl>
    implements _$$EventModelImplCopyWith<$Res> {
  __$$EventModelImplCopyWithImpl(
      _$EventModelImpl _value, $Res Function(_$EventModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = freezed,
    Object? organizerName = freezed,
    Object? venue = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? banner = freezed,
    Object? status = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? registerOpenTime = freezed,
    Object? price = freezed,
    Object? categories = freezed,
    Object? rewardCoin = freezed,
    Object? youthUnionPoint = freezed,
    Object? certificateName = freezed,
    Object? createdTime = freezed,
    Object? totalParticipants = freezed,
    Object? userEventState = freezed,
    Object? recruitmentType = freezed,
    Object? viewCount = freezed,
    Object? lastViewedTime = freezed,
  }) {
    return _then(_$EventModelImpl(
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int?,
      organizerName: freezed == organizerName
          ? _value.organizerName
          : organizerName // ignore: cast_nullable_to_non_nullable
              as String?,
      venue: freezed == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as VenueModel?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      banner: freezed == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatus?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      registerOpenTime: freezed == registerOpenTime
          ? _value.registerOpenTime
          : registerOpenTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
      categories: freezed == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategoryModel>?,
      rewardCoin: freezed == rewardCoin
          ? _value.rewardCoin
          : rewardCoin // ignore: cast_nullable_to_non_nullable
              as int?,
      youthUnionPoint: freezed == youthUnionPoint
          ? _value.youthUnionPoint
          : youthUnionPoint // ignore: cast_nullable_to_non_nullable
              as int?,
      certificateName: freezed == certificateName
          ? _value.certificateName
          : certificateName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalParticipants: freezed == totalParticipants
          ? _value.totalParticipants
          : totalParticipants // ignore: cast_nullable_to_non_nullable
              as int?,
      userEventState: freezed == userEventState
          ? _value.userEventState
          : userEventState // ignore: cast_nullable_to_non_nullable
              as UserEventState?,
      recruitmentType: freezed == recruitmentType
          ? _value.recruitmentType
          : recruitmentType // ignore: cast_nullable_to_non_nullable
              as EventRecruitmentType?,
      viewCount: freezed == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int?,
      lastViewedTime: freezed == lastViewedTime
          ? _value.lastViewedTime
          : lastViewedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventModelImpl implements _EventModel {
  const _$EventModelImpl(
      {this.eventId,
      this.organizerName,
      this.venue,
      this.title,
      this.description,
      this.banner,
      this.status = EventStatus.draft,
      this.startTime,
      this.endTime,
      this.registerOpenTime,
      this.price,
      final List<CategoryModel>? categories,
      this.rewardCoin,
      this.youthUnionPoint,
      this.certificateName,
      this.createdTime,
      this.totalParticipants,
      this.userEventState,
      this.recruitmentType,
      this.viewCount = 0,
      this.lastViewedTime})
      : _categories = categories;

  factory _$EventModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventModelImplFromJson(json);

  @override
  final int? eventId;
  @override
  final String? organizerName;
  @override
  final VenueModel? venue;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? banner;
  @override
  @JsonKey()
  final EventStatus? status;
  @override
  final DateTime? startTime;
  @override
  final DateTime? endTime;
  @override
  final DateTime? registerOpenTime;
  @override
  final int? price;
  final List<CategoryModel>? _categories;
  @override
  List<CategoryModel>? get categories {
    final value = _categories;
    if (value == null) return null;
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? rewardCoin;
  @override
  final int? youthUnionPoint;
  @override
  final String? certificateName;
  @override
  final DateTime? createdTime;
  @override
  final int? totalParticipants;
  @override
  final UserEventState? userEventState;
  @override
  final EventRecruitmentType? recruitmentType;
  @override
  @JsonKey()
  final int? viewCount;
  @override
  final DateTime? lastViewedTime;

  @override
  String toString() {
    return 'EventModel(eventId: $eventId, organizerName: $organizerName, venue: $venue, title: $title, description: $description, banner: $banner, status: $status, startTime: $startTime, endTime: $endTime, registerOpenTime: $registerOpenTime, price: $price, categories: $categories, rewardCoin: $rewardCoin, youthUnionPoint: $youthUnionPoint, certificateName: $certificateName, createdTime: $createdTime, totalParticipants: $totalParticipants, userEventState: $userEventState, recruitmentType: $recruitmentType, viewCount: $viewCount, lastViewedTime: $lastViewedTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventModelImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.organizerName, organizerName) ||
                other.organizerName == organizerName) &&
            (identical(other.venue, venue) || other.venue == venue) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.banner, banner) || other.banner == banner) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.registerOpenTime, registerOpenTime) ||
                other.registerOpenTime == registerOpenTime) &&
            (identical(other.price, price) || other.price == price) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.rewardCoin, rewardCoin) ||
                other.rewardCoin == rewardCoin) &&
            (identical(other.youthUnionPoint, youthUnionPoint) ||
                other.youthUnionPoint == youthUnionPoint) &&
            (identical(other.certificateName, certificateName) ||
                other.certificateName == certificateName) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.totalParticipants, totalParticipants) ||
                other.totalParticipants == totalParticipants) &&
            (identical(other.userEventState, userEventState) ||
                other.userEventState == userEventState) &&
            (identical(other.recruitmentType, recruitmentType) ||
                other.recruitmentType == recruitmentType) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.lastViewedTime, lastViewedTime) ||
                other.lastViewedTime == lastViewedTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        eventId,
        organizerName,
        venue,
        title,
        description,
        banner,
        status,
        startTime,
        endTime,
        registerOpenTime,
        price,
        const DeepCollectionEquality().hash(_categories),
        rewardCoin,
        youthUnionPoint,
        certificateName,
        createdTime,
        totalParticipants,
        userEventState,
        recruitmentType,
        viewCount,
        lastViewedTime
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventModelImplCopyWith<_$EventModelImpl> get copyWith =>
      __$$EventModelImplCopyWithImpl<_$EventModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventModelImplToJson(
      this,
    );
  }
}

abstract class _EventModel implements EventModel {
  const factory _EventModel(
      {final int? eventId,
      final String? organizerName,
      final VenueModel? venue,
      final String? title,
      final String? description,
      final String? banner,
      final EventStatus? status,
      final DateTime? startTime,
      final DateTime? endTime,
      final DateTime? registerOpenTime,
      final int? price,
      final List<CategoryModel>? categories,
      final int? rewardCoin,
      final int? youthUnionPoint,
      final String? certificateName,
      final DateTime? createdTime,
      final int? totalParticipants,
      final UserEventState? userEventState,
      final EventRecruitmentType? recruitmentType,
      final int? viewCount,
      final DateTime? lastViewedTime}) = _$EventModelImpl;

  factory _EventModel.fromJson(Map<String, dynamic> json) =
      _$EventModelImpl.fromJson;

  @override
  int? get eventId;
  @override
  String? get organizerName;
  @override
  VenueModel? get venue;
  @override
  String? get title;
  @override
  String? get description;
  @override
  String? get banner;
  @override
  EventStatus? get status;
  @override
  DateTime? get startTime;
  @override
  DateTime? get endTime;
  @override
  DateTime? get registerOpenTime;
  @override
  int? get price;
  @override
  List<CategoryModel>? get categories;
  @override
  int? get rewardCoin;
  @override
  int? get youthUnionPoint;
  @override
  String? get certificateName;
  @override
  DateTime? get createdTime;
  @override
  int? get totalParticipants;
  @override
  UserEventState? get userEventState;
  @override
  EventRecruitmentType? get recruitmentType;
  @override
  int? get viewCount;
  @override
  DateTime? get lastViewedTime;
  @override
  @JsonKey(ignore: true)
  _$$EventModelImplCopyWith<_$EventModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
