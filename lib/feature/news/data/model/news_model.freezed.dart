// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NewsModel _$NewsModelFromJson(Map<String, dynamic> json) {
  return _NewsModel.fromJson(json);
}

/// @nodoc
mixin _$NewsModel {
  int? get newsId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  String? get banner => throw _privateConstructorUsedError;
  String? get tag => throw _privateConstructorUsedError;
  NewsTargetType? get targetType => throw _privateConstructorUsedError;
  int? get targetId => throw _privateConstructorUsedError;
  int? get totalRewardCoin => throw _privateConstructorUsedError;
  int? get remainingRewardCoin => throw _privateConstructorUsedError;
  int? get rewardPerMinute => throw _privateConstructorUsedError;
  int? get viewCount => throw _privateConstructorUsedError;
  DateTime? get createdTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NewsModelCopyWith<NewsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewsModelCopyWith<$Res> {
  factory $NewsModelCopyWith(NewsModel value, $Res Function(NewsModel) then) =
      _$NewsModelCopyWithImpl<$Res, NewsModel>;
  @useResult
  $Res call(
      {int? newsId,
      String? title,
      String? content,
      String? banner,
      String? tag,
      NewsTargetType? targetType,
      int? targetId,
      int? totalRewardCoin,
      int? remainingRewardCoin,
      int? rewardPerMinute,
      int? viewCount,
      DateTime? createdTime});
}

/// @nodoc
class _$NewsModelCopyWithImpl<$Res, $Val extends NewsModel>
    implements $NewsModelCopyWith<$Res> {
  _$NewsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newsId = freezed,
    Object? title = freezed,
    Object? content = freezed,
    Object? banner = freezed,
    Object? tag = freezed,
    Object? targetType = freezed,
    Object? targetId = freezed,
    Object? totalRewardCoin = freezed,
    Object? remainingRewardCoin = freezed,
    Object? rewardPerMinute = freezed,
    Object? viewCount = freezed,
    Object? createdTime = freezed,
  }) {
    return _then(_value.copyWith(
      newsId: freezed == newsId
          ? _value.newsId
          : newsId // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      banner: freezed == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as String?,
      tag: freezed == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String?,
      targetType: freezed == targetType
          ? _value.targetType
          : targetType // ignore: cast_nullable_to_non_nullable
              as NewsTargetType?,
      targetId: freezed == targetId
          ? _value.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as int?,
      totalRewardCoin: freezed == totalRewardCoin
          ? _value.totalRewardCoin
          : totalRewardCoin // ignore: cast_nullable_to_non_nullable
              as int?,
      remainingRewardCoin: freezed == remainingRewardCoin
          ? _value.remainingRewardCoin
          : remainingRewardCoin // ignore: cast_nullable_to_non_nullable
              as int?,
      rewardPerMinute: freezed == rewardPerMinute
          ? _value.rewardPerMinute
          : rewardPerMinute // ignore: cast_nullable_to_non_nullable
              as int?,
      viewCount: freezed == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NewsModelImplCopyWith<$Res>
    implements $NewsModelCopyWith<$Res> {
  factory _$$NewsModelImplCopyWith(
          _$NewsModelImpl value, $Res Function(_$NewsModelImpl) then) =
      __$$NewsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? newsId,
      String? title,
      String? content,
      String? banner,
      String? tag,
      NewsTargetType? targetType,
      int? targetId,
      int? totalRewardCoin,
      int? remainingRewardCoin,
      int? rewardPerMinute,
      int? viewCount,
      DateTime? createdTime});
}

/// @nodoc
class __$$NewsModelImplCopyWithImpl<$Res>
    extends _$NewsModelCopyWithImpl<$Res, _$NewsModelImpl>
    implements _$$NewsModelImplCopyWith<$Res> {
  __$$NewsModelImplCopyWithImpl(
      _$NewsModelImpl _value, $Res Function(_$NewsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newsId = freezed,
    Object? title = freezed,
    Object? content = freezed,
    Object? banner = freezed,
    Object? tag = freezed,
    Object? targetType = freezed,
    Object? targetId = freezed,
    Object? totalRewardCoin = freezed,
    Object? remainingRewardCoin = freezed,
    Object? rewardPerMinute = freezed,
    Object? viewCount = freezed,
    Object? createdTime = freezed,
  }) {
    return _then(_$NewsModelImpl(
      newsId: freezed == newsId
          ? _value.newsId
          : newsId // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      banner: freezed == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as String?,
      tag: freezed == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String?,
      targetType: freezed == targetType
          ? _value.targetType
          : targetType // ignore: cast_nullable_to_non_nullable
              as NewsTargetType?,
      targetId: freezed == targetId
          ? _value.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as int?,
      totalRewardCoin: freezed == totalRewardCoin
          ? _value.totalRewardCoin
          : totalRewardCoin // ignore: cast_nullable_to_non_nullable
              as int?,
      remainingRewardCoin: freezed == remainingRewardCoin
          ? _value.remainingRewardCoin
          : remainingRewardCoin // ignore: cast_nullable_to_non_nullable
              as int?,
      rewardPerMinute: freezed == rewardPerMinute
          ? _value.rewardPerMinute
          : rewardPerMinute // ignore: cast_nullable_to_non_nullable
              as int?,
      viewCount: freezed == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NewsModelImpl implements _NewsModel {
  const _$NewsModelImpl(
      {this.newsId,
      this.title,
      this.content,
      this.banner,
      this.tag,
      this.targetType,
      this.targetId,
      this.totalRewardCoin = 0,
      this.remainingRewardCoin = 0,
      this.rewardPerMinute = 0,
      this.viewCount = 0,
      this.createdTime});

  factory _$NewsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NewsModelImplFromJson(json);

  @override
  final int? newsId;
  @override
  final String? title;
  @override
  final String? content;
  @override
  final String? banner;
  @override
  final String? tag;
  @override
  final NewsTargetType? targetType;
  @override
  final int? targetId;
  @override
  @JsonKey()
  final int? totalRewardCoin;
  @override
  @JsonKey()
  final int? remainingRewardCoin;
  @override
  @JsonKey()
  final int? rewardPerMinute;
  @override
  @JsonKey()
  final int? viewCount;
  @override
  final DateTime? createdTime;

  @override
  String toString() {
    return 'NewsModel(newsId: $newsId, title: $title, content: $content, banner: $banner, tag: $tag, targetType: $targetType, targetId: $targetId, totalRewardCoin: $totalRewardCoin, remainingRewardCoin: $remainingRewardCoin, rewardPerMinute: $rewardPerMinute, viewCount: $viewCount, createdTime: $createdTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewsModelImpl &&
            (identical(other.newsId, newsId) || other.newsId == newsId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.banner, banner) || other.banner == banner) &&
            (identical(other.tag, tag) || other.tag == tag) &&
            (identical(other.targetType, targetType) ||
                other.targetType == targetType) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.totalRewardCoin, totalRewardCoin) ||
                other.totalRewardCoin == totalRewardCoin) &&
            (identical(other.remainingRewardCoin, remainingRewardCoin) ||
                other.remainingRewardCoin == remainingRewardCoin) &&
            (identical(other.rewardPerMinute, rewardPerMinute) ||
                other.rewardPerMinute == rewardPerMinute) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      newsId,
      title,
      content,
      banner,
      tag,
      targetType,
      targetId,
      totalRewardCoin,
      remainingRewardCoin,
      rewardPerMinute,
      viewCount,
      createdTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NewsModelImplCopyWith<_$NewsModelImpl> get copyWith =>
      __$$NewsModelImplCopyWithImpl<_$NewsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NewsModelImplToJson(
      this,
    );
  }
}

abstract class _NewsModel implements NewsModel {
  const factory _NewsModel(
      {final int? newsId,
      final String? title,
      final String? content,
      final String? banner,
      final String? tag,
      final NewsTargetType? targetType,
      final int? targetId,
      final int? totalRewardCoin,
      final int? remainingRewardCoin,
      final int? rewardPerMinute,
      final int? viewCount,
      final DateTime? createdTime}) = _$NewsModelImpl;

  factory _NewsModel.fromJson(Map<String, dynamic> json) =
      _$NewsModelImpl.fromJson;

  @override
  int? get newsId;
  @override
  String? get title;
  @override
  String? get content;
  @override
  String? get banner;
  @override
  String? get tag;
  @override
  NewsTargetType? get targetType;
  @override
  int? get targetId;
  @override
  int? get totalRewardCoin;
  @override
  int? get remainingRewardCoin;
  @override
  int? get rewardPerMinute;
  @override
  int? get viewCount;
  @override
  DateTime? get createdTime;
  @override
  @JsonKey(ignore: true)
  _$$NewsModelImplCopyWith<_$NewsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
