// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_analytics_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventAnalyticsModel _$EventAnalyticsModelFromJson(Map<String, dynamic> json) {
  return _EventAnalyticsModel.fromJson(json);
}

/// @nodoc
mixin _$EventAnalyticsModel {
  int? get eventId => throw _privateConstructorUsedError;
  String? get eventTitle => throw _privateConstructorUsedError;
  GenderDistributionModel? get genderDistribution =>
      throw _privateConstructorUsedError;
  List<CategoryDistributionModel>? get majorDistribution =>
      throw _privateConstructorUsedError;
  List<CategoryDistributionModel>? get schoolDistribution =>
      throw _privateConstructorUsedError;
  List<CategoryDistributionModel>? get ageDistribution =>
      throw _privateConstructorUsedError;
  List<TimelineDataModel>? get checkInTimeline =>
      throw _privateConstructorUsedError;
  DateTime? get lastUpdateTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventAnalyticsModelCopyWith<EventAnalyticsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventAnalyticsModelCopyWith<$Res> {
  factory $EventAnalyticsModelCopyWith(
          EventAnalyticsModel value, $Res Function(EventAnalyticsModel) then) =
      _$EventAnalyticsModelCopyWithImpl<$Res, EventAnalyticsModel>;
  @useResult
  $Res call(
      {int? eventId,
      String? eventTitle,
      GenderDistributionModel? genderDistribution,
      List<CategoryDistributionModel>? majorDistribution,
      List<CategoryDistributionModel>? schoolDistribution,
      List<CategoryDistributionModel>? ageDistribution,
      List<TimelineDataModel>? checkInTimeline,
      DateTime? lastUpdateTime});

  $GenderDistributionModelCopyWith<$Res>? get genderDistribution;
}

/// @nodoc
class _$EventAnalyticsModelCopyWithImpl<$Res, $Val extends EventAnalyticsModel>
    implements $EventAnalyticsModelCopyWith<$Res> {
  _$EventAnalyticsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = freezed,
    Object? eventTitle = freezed,
    Object? genderDistribution = freezed,
    Object? majorDistribution = freezed,
    Object? schoolDistribution = freezed,
    Object? ageDistribution = freezed,
    Object? checkInTimeline = freezed,
    Object? lastUpdateTime = freezed,
  }) {
    return _then(_value.copyWith(
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int?,
      eventTitle: freezed == eventTitle
          ? _value.eventTitle
          : eventTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      genderDistribution: freezed == genderDistribution
          ? _value.genderDistribution
          : genderDistribution // ignore: cast_nullable_to_non_nullable
              as GenderDistributionModel?,
      majorDistribution: freezed == majorDistribution
          ? _value.majorDistribution
          : majorDistribution // ignore: cast_nullable_to_non_nullable
              as List<CategoryDistributionModel>?,
      schoolDistribution: freezed == schoolDistribution
          ? _value.schoolDistribution
          : schoolDistribution // ignore: cast_nullable_to_non_nullable
              as List<CategoryDistributionModel>?,
      ageDistribution: freezed == ageDistribution
          ? _value.ageDistribution
          : ageDistribution // ignore: cast_nullable_to_non_nullable
              as List<CategoryDistributionModel>?,
      checkInTimeline: freezed == checkInTimeline
          ? _value.checkInTimeline
          : checkInTimeline // ignore: cast_nullable_to_non_nullable
              as List<TimelineDataModel>?,
      lastUpdateTime: freezed == lastUpdateTime
          ? _value.lastUpdateTime
          : lastUpdateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GenderDistributionModelCopyWith<$Res>? get genderDistribution {
    if (_value.genderDistribution == null) {
      return null;
    }

    return $GenderDistributionModelCopyWith<$Res>(_value.genderDistribution!,
        (value) {
      return _then(_value.copyWith(genderDistribution: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventAnalyticsModelImplCopyWith<$Res>
    implements $EventAnalyticsModelCopyWith<$Res> {
  factory _$$EventAnalyticsModelImplCopyWith(_$EventAnalyticsModelImpl value,
          $Res Function(_$EventAnalyticsModelImpl) then) =
      __$$EventAnalyticsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? eventId,
      String? eventTitle,
      GenderDistributionModel? genderDistribution,
      List<CategoryDistributionModel>? majorDistribution,
      List<CategoryDistributionModel>? schoolDistribution,
      List<CategoryDistributionModel>? ageDistribution,
      List<TimelineDataModel>? checkInTimeline,
      DateTime? lastUpdateTime});

  @override
  $GenderDistributionModelCopyWith<$Res>? get genderDistribution;
}

/// @nodoc
class __$$EventAnalyticsModelImplCopyWithImpl<$Res>
    extends _$EventAnalyticsModelCopyWithImpl<$Res, _$EventAnalyticsModelImpl>
    implements _$$EventAnalyticsModelImplCopyWith<$Res> {
  __$$EventAnalyticsModelImplCopyWithImpl(_$EventAnalyticsModelImpl _value,
      $Res Function(_$EventAnalyticsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = freezed,
    Object? eventTitle = freezed,
    Object? genderDistribution = freezed,
    Object? majorDistribution = freezed,
    Object? schoolDistribution = freezed,
    Object? ageDistribution = freezed,
    Object? checkInTimeline = freezed,
    Object? lastUpdateTime = freezed,
  }) {
    return _then(_$EventAnalyticsModelImpl(
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int?,
      eventTitle: freezed == eventTitle
          ? _value.eventTitle
          : eventTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      genderDistribution: freezed == genderDistribution
          ? _value.genderDistribution
          : genderDistribution // ignore: cast_nullable_to_non_nullable
              as GenderDistributionModel?,
      majorDistribution: freezed == majorDistribution
          ? _value._majorDistribution
          : majorDistribution // ignore: cast_nullable_to_non_nullable
              as List<CategoryDistributionModel>?,
      schoolDistribution: freezed == schoolDistribution
          ? _value._schoolDistribution
          : schoolDistribution // ignore: cast_nullable_to_non_nullable
              as List<CategoryDistributionModel>?,
      ageDistribution: freezed == ageDistribution
          ? _value._ageDistribution
          : ageDistribution // ignore: cast_nullable_to_non_nullable
              as List<CategoryDistributionModel>?,
      checkInTimeline: freezed == checkInTimeline
          ? _value._checkInTimeline
          : checkInTimeline // ignore: cast_nullable_to_non_nullable
              as List<TimelineDataModel>?,
      lastUpdateTime: freezed == lastUpdateTime
          ? _value.lastUpdateTime
          : lastUpdateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventAnalyticsModelImpl implements _EventAnalyticsModel {
  const _$EventAnalyticsModelImpl(
      {this.eventId,
      this.eventTitle,
      this.genderDistribution,
      final List<CategoryDistributionModel>? majorDistribution,
      final List<CategoryDistributionModel>? schoolDistribution,
      final List<CategoryDistributionModel>? ageDistribution,
      final List<TimelineDataModel>? checkInTimeline,
      this.lastUpdateTime})
      : _majorDistribution = majorDistribution,
        _schoolDistribution = schoolDistribution,
        _ageDistribution = ageDistribution,
        _checkInTimeline = checkInTimeline;

  factory _$EventAnalyticsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventAnalyticsModelImplFromJson(json);

  @override
  final int? eventId;
  @override
  final String? eventTitle;
  @override
  final GenderDistributionModel? genderDistribution;
  final List<CategoryDistributionModel>? _majorDistribution;
  @override
  List<CategoryDistributionModel>? get majorDistribution {
    final value = _majorDistribution;
    if (value == null) return null;
    if (_majorDistribution is EqualUnmodifiableListView)
      return _majorDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<CategoryDistributionModel>? _schoolDistribution;
  @override
  List<CategoryDistributionModel>? get schoolDistribution {
    final value = _schoolDistribution;
    if (value == null) return null;
    if (_schoolDistribution is EqualUnmodifiableListView)
      return _schoolDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<CategoryDistributionModel>? _ageDistribution;
  @override
  List<CategoryDistributionModel>? get ageDistribution {
    final value = _ageDistribution;
    if (value == null) return null;
    if (_ageDistribution is EqualUnmodifiableListView) return _ageDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<TimelineDataModel>? _checkInTimeline;
  @override
  List<TimelineDataModel>? get checkInTimeline {
    final value = _checkInTimeline;
    if (value == null) return null;
    if (_checkInTimeline is EqualUnmodifiableListView) return _checkInTimeline;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? lastUpdateTime;

  @override
  String toString() {
    return 'EventAnalyticsModel(eventId: $eventId, eventTitle: $eventTitle, genderDistribution: $genderDistribution, majorDistribution: $majorDistribution, schoolDistribution: $schoolDistribution, ageDistribution: $ageDistribution, checkInTimeline: $checkInTimeline, lastUpdateTime: $lastUpdateTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventAnalyticsModelImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.eventTitle, eventTitle) ||
                other.eventTitle == eventTitle) &&
            (identical(other.genderDistribution, genderDistribution) ||
                other.genderDistribution == genderDistribution) &&
            const DeepCollectionEquality()
                .equals(other._majorDistribution, _majorDistribution) &&
            const DeepCollectionEquality()
                .equals(other._schoolDistribution, _schoolDistribution) &&
            const DeepCollectionEquality()
                .equals(other._ageDistribution, _ageDistribution) &&
            const DeepCollectionEquality()
                .equals(other._checkInTimeline, _checkInTimeline) &&
            (identical(other.lastUpdateTime, lastUpdateTime) ||
                other.lastUpdateTime == lastUpdateTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      eventId,
      eventTitle,
      genderDistribution,
      const DeepCollectionEquality().hash(_majorDistribution),
      const DeepCollectionEquality().hash(_schoolDistribution),
      const DeepCollectionEquality().hash(_ageDistribution),
      const DeepCollectionEquality().hash(_checkInTimeline),
      lastUpdateTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventAnalyticsModelImplCopyWith<_$EventAnalyticsModelImpl> get copyWith =>
      __$$EventAnalyticsModelImplCopyWithImpl<_$EventAnalyticsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventAnalyticsModelImplToJson(
      this,
    );
  }
}

abstract class _EventAnalyticsModel implements EventAnalyticsModel {
  const factory _EventAnalyticsModel(
      {final int? eventId,
      final String? eventTitle,
      final GenderDistributionModel? genderDistribution,
      final List<CategoryDistributionModel>? majorDistribution,
      final List<CategoryDistributionModel>? schoolDistribution,
      final List<CategoryDistributionModel>? ageDistribution,
      final List<TimelineDataModel>? checkInTimeline,
      final DateTime? lastUpdateTime}) = _$EventAnalyticsModelImpl;

  factory _EventAnalyticsModel.fromJson(Map<String, dynamic> json) =
      _$EventAnalyticsModelImpl.fromJson;

  @override
  int? get eventId;
  @override
  String? get eventTitle;
  @override
  GenderDistributionModel? get genderDistribution;
  @override
  List<CategoryDistributionModel>? get majorDistribution;
  @override
  List<CategoryDistributionModel>? get schoolDistribution;
  @override
  List<CategoryDistributionModel>? get ageDistribution;
  @override
  List<TimelineDataModel>? get checkInTimeline;
  @override
  DateTime? get lastUpdateTime;
  @override
  @JsonKey(ignore: true)
  _$$EventAnalyticsModelImplCopyWith<_$EventAnalyticsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
