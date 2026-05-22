// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventSummaryModel _$EventSummaryModelFromJson(Map<String, dynamic> json) {
  return _EventSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$EventSummaryModel {
  int? get eventId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get banner => throw _privateConstructorUsedError;
  DateTime? get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  DateTime? get registerOpenTime => throw _privateConstructorUsedError;
  EventStatus? get status => throw _privateConstructorUsedError;
  int? get price => throw _privateConstructorUsedError;
  String? get certificateName => throw _privateConstructorUsedError;
  List<CategoryModel>? get categories => throw _privateConstructorUsedError;
  int? get capacity => throw _privateConstructorUsedError;
  int? get totalParticipants => throw _privateConstructorUsedError;
  UserEventState? get userEventState => throw _privateConstructorUsedError;
  int? get youthUnionPoint => throw _privateConstructorUsedError;
  EventRecruitmentType? get recruitmentType =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventSummaryModelCopyWith<EventSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventSummaryModelCopyWith<$Res> {
  factory $EventSummaryModelCopyWith(
          EventSummaryModel value, $Res Function(EventSummaryModel) then) =
      _$EventSummaryModelCopyWithImpl<$Res, EventSummaryModel>;
  @useResult
  $Res call(
      {int? eventId,
      String? title,
      String? banner,
      DateTime? startTime,
      DateTime? endTime,
      DateTime? registerOpenTime,
      EventStatus? status,
      int? price,
      String? certificateName,
      List<CategoryModel>? categories,
      int? capacity,
      int? totalParticipants,
      UserEventState? userEventState,
      int? youthUnionPoint,
      EventRecruitmentType? recruitmentType});
}

/// @nodoc
class _$EventSummaryModelCopyWithImpl<$Res, $Val extends EventSummaryModel>
    implements $EventSummaryModelCopyWith<$Res> {
  _$EventSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = freezed,
    Object? title = freezed,
    Object? banner = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? registerOpenTime = freezed,
    Object? status = freezed,
    Object? price = freezed,
    Object? certificateName = freezed,
    Object? categories = freezed,
    Object? capacity = freezed,
    Object? totalParticipants = freezed,
    Object? userEventState = freezed,
    Object? youthUnionPoint = freezed,
    Object? recruitmentType = freezed,
  }) {
    return _then(_value.copyWith(
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      banner: freezed == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as String?,
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
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatus?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
      certificateName: freezed == certificateName
          ? _value.certificateName
          : certificateName // ignore: cast_nullable_to_non_nullable
              as String?,
      categories: freezed == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategoryModel>?,
      capacity: freezed == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int?,
      totalParticipants: freezed == totalParticipants
          ? _value.totalParticipants
          : totalParticipants // ignore: cast_nullable_to_non_nullable
              as int?,
      userEventState: freezed == userEventState
          ? _value.userEventState
          : userEventState // ignore: cast_nullable_to_non_nullable
              as UserEventState?,
      youthUnionPoint: freezed == youthUnionPoint
          ? _value.youthUnionPoint
          : youthUnionPoint // ignore: cast_nullable_to_non_nullable
              as int?,
      recruitmentType: freezed == recruitmentType
          ? _value.recruitmentType
          : recruitmentType // ignore: cast_nullable_to_non_nullable
              as EventRecruitmentType?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventSummaryModelImplCopyWith<$Res>
    implements $EventSummaryModelCopyWith<$Res> {
  factory _$$EventSummaryModelImplCopyWith(_$EventSummaryModelImpl value,
          $Res Function(_$EventSummaryModelImpl) then) =
      __$$EventSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? eventId,
      String? title,
      String? banner,
      DateTime? startTime,
      DateTime? endTime,
      DateTime? registerOpenTime,
      EventStatus? status,
      int? price,
      String? certificateName,
      List<CategoryModel>? categories,
      int? capacity,
      int? totalParticipants,
      UserEventState? userEventState,
      int? youthUnionPoint,
      EventRecruitmentType? recruitmentType});
}

/// @nodoc
class __$$EventSummaryModelImplCopyWithImpl<$Res>
    extends _$EventSummaryModelCopyWithImpl<$Res, _$EventSummaryModelImpl>
    implements _$$EventSummaryModelImplCopyWith<$Res> {
  __$$EventSummaryModelImplCopyWithImpl(_$EventSummaryModelImpl _value,
      $Res Function(_$EventSummaryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = freezed,
    Object? title = freezed,
    Object? banner = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? registerOpenTime = freezed,
    Object? status = freezed,
    Object? price = freezed,
    Object? certificateName = freezed,
    Object? categories = freezed,
    Object? capacity = freezed,
    Object? totalParticipants = freezed,
    Object? userEventState = freezed,
    Object? youthUnionPoint = freezed,
    Object? recruitmentType = freezed,
  }) {
    return _then(_$EventSummaryModelImpl(
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      banner: freezed == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as String?,
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
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatus?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
      certificateName: freezed == certificateName
          ? _value.certificateName
          : certificateName // ignore: cast_nullable_to_non_nullable
              as String?,
      categories: freezed == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategoryModel>?,
      capacity: freezed == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int?,
      totalParticipants: freezed == totalParticipants
          ? _value.totalParticipants
          : totalParticipants // ignore: cast_nullable_to_non_nullable
              as int?,
      userEventState: freezed == userEventState
          ? _value.userEventState
          : userEventState // ignore: cast_nullable_to_non_nullable
              as UserEventState?,
      youthUnionPoint: freezed == youthUnionPoint
          ? _value.youthUnionPoint
          : youthUnionPoint // ignore: cast_nullable_to_non_nullable
              as int?,
      recruitmentType: freezed == recruitmentType
          ? _value.recruitmentType
          : recruitmentType // ignore: cast_nullable_to_non_nullable
              as EventRecruitmentType?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventSummaryModelImpl implements _EventSummaryModel {
  const _$EventSummaryModelImpl(
      {this.eventId,
      this.title,
      this.banner,
      this.startTime,
      this.endTime,
      this.registerOpenTime,
      this.status,
      this.price,
      this.certificateName,
      final List<CategoryModel>? categories,
      this.capacity,
      this.totalParticipants,
      this.userEventState,
      this.youthUnionPoint,
      this.recruitmentType})
      : _categories = categories;

  factory _$EventSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventSummaryModelImplFromJson(json);

  @override
  final int? eventId;
  @override
  final String? title;
  @override
  final String? banner;
  @override
  final DateTime? startTime;
  @override
  final DateTime? endTime;
  @override
  final DateTime? registerOpenTime;
  @override
  final EventStatus? status;
  @override
  final int? price;
  @override
  final String? certificateName;
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
  final int? capacity;
  @override
  final int? totalParticipants;
  @override
  final UserEventState? userEventState;
  @override
  final int? youthUnionPoint;
  @override
  final EventRecruitmentType? recruitmentType;

  @override
  String toString() {
    return 'EventSummaryModel(eventId: $eventId, title: $title, banner: $banner, startTime: $startTime, endTime: $endTime, registerOpenTime: $registerOpenTime, status: $status, price: $price, certificateName: $certificateName, categories: $categories, capacity: $capacity, totalParticipants: $totalParticipants, userEventState: $userEventState, youthUnionPoint: $youthUnionPoint, recruitmentType: $recruitmentType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventSummaryModelImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.banner, banner) || other.banner == banner) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.registerOpenTime, registerOpenTime) ||
                other.registerOpenTime == registerOpenTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.certificateName, certificateName) ||
                other.certificateName == certificateName) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.totalParticipants, totalParticipants) ||
                other.totalParticipants == totalParticipants) &&
            (identical(other.userEventState, userEventState) ||
                other.userEventState == userEventState) &&
            (identical(other.youthUnionPoint, youthUnionPoint) ||
                other.youthUnionPoint == youthUnionPoint) &&
            (identical(other.recruitmentType, recruitmentType) ||
                other.recruitmentType == recruitmentType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      eventId,
      title,
      banner,
      startTime,
      endTime,
      registerOpenTime,
      status,
      price,
      certificateName,
      const DeepCollectionEquality().hash(_categories),
      capacity,
      totalParticipants,
      userEventState,
      youthUnionPoint,
      recruitmentType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventSummaryModelImplCopyWith<_$EventSummaryModelImpl> get copyWith =>
      __$$EventSummaryModelImplCopyWithImpl<_$EventSummaryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventSummaryModelImplToJson(
      this,
    );
  }
}

abstract class _EventSummaryModel implements EventSummaryModel {
  const factory _EventSummaryModel(
      {final int? eventId,
      final String? title,
      final String? banner,
      final DateTime? startTime,
      final DateTime? endTime,
      final DateTime? registerOpenTime,
      final EventStatus? status,
      final int? price,
      final String? certificateName,
      final List<CategoryModel>? categories,
      final int? capacity,
      final int? totalParticipants,
      final UserEventState? userEventState,
      final int? youthUnionPoint,
      final EventRecruitmentType? recruitmentType}) = _$EventSummaryModelImpl;

  factory _EventSummaryModel.fromJson(Map<String, dynamic> json) =
      _$EventSummaryModelImpl.fromJson;

  @override
  int? get eventId;
  @override
  String? get title;
  @override
  String? get banner;
  @override
  DateTime? get startTime;
  @override
  DateTime? get endTime;
  @override
  DateTime? get registerOpenTime;
  @override
  EventStatus? get status;
  @override
  int? get price;
  @override
  String? get certificateName;
  @override
  List<CategoryModel>? get categories;
  @override
  int? get capacity;
  @override
  int? get totalParticipants;
  @override
  UserEventState? get userEventState;
  @override
  int? get youthUnionPoint;
  @override
  EventRecruitmentType? get recruitmentType;
  @override
  @JsonKey(ignore: true)
  _$$EventSummaryModelImplCopyWith<_$EventSummaryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
