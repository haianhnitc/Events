// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'portfolio_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PortfolioDetailModel _$PortfolioDetailModelFromJson(Map<String, dynamic> json) {
  return _PortfolioDetailModel.fromJson(json);
}

/// @nodoc
mixin _$PortfolioDetailModel {
  int? get portfolioId => throw _privateConstructorUsedError;
  UserSummaryModel? get user => throw _privateConstructorUsedError;
  int? get userId => throw _privateConstructorUsedError;
  int? get price => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get portfolioCode => throw _privateConstructorUsedError;
  bool? get isPublished => throw _privateConstructorUsedError;
  int? get viewCount => throw _privateConstructorUsedError;
  int? get downloadCount => throw _privateConstructorUsedError;
  String? get thumbnail => throw _privateConstructorUsedError;
  int? get itemCount => throw _privateConstructorUsedError;
  DateTime? get createdTime => throw _privateConstructorUsedError;
  DateTime? get publishTime => throw _privateConstructorUsedError;
  List<PortfolioItemModel>? get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PortfolioDetailModelCopyWith<PortfolioDetailModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PortfolioDetailModelCopyWith<$Res> {
  factory $PortfolioDetailModelCopyWith(PortfolioDetailModel value,
          $Res Function(PortfolioDetailModel) then) =
      _$PortfolioDetailModelCopyWithImpl<$Res, PortfolioDetailModel>;
  @useResult
  $Res call(
      {int? portfolioId,
      UserSummaryModel? user,
      int? userId,
      int? price,
      String? title,
      String? description,
      String? portfolioCode,
      bool? isPublished,
      int? viewCount,
      int? downloadCount,
      String? thumbnail,
      int? itemCount,
      DateTime? createdTime,
      DateTime? publishTime,
      List<PortfolioItemModel>? items});

  $UserSummaryModelCopyWith<$Res>? get user;
}

/// @nodoc
class _$PortfolioDetailModelCopyWithImpl<$Res,
        $Val extends PortfolioDetailModel>
    implements $PortfolioDetailModelCopyWith<$Res> {
  _$PortfolioDetailModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? portfolioId = freezed,
    Object? user = freezed,
    Object? userId = freezed,
    Object? price = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? portfolioCode = freezed,
    Object? isPublished = freezed,
    Object? viewCount = freezed,
    Object? downloadCount = freezed,
    Object? thumbnail = freezed,
    Object? itemCount = freezed,
    Object? createdTime = freezed,
    Object? publishTime = freezed,
    Object? items = freezed,
  }) {
    return _then(_value.copyWith(
      portfolioId: freezed == portfolioId
          ? _value.portfolioId
          : portfolioId // ignore: cast_nullable_to_non_nullable
              as int?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserSummaryModel?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      portfolioCode: freezed == portfolioCode
          ? _value.portfolioCode
          : portfolioCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isPublished: freezed == isPublished
          ? _value.isPublished
          : isPublished // ignore: cast_nullable_to_non_nullable
              as bool?,
      viewCount: freezed == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int?,
      downloadCount: freezed == downloadCount
          ? _value.downloadCount
          : downloadCount // ignore: cast_nullable_to_non_nullable
              as int?,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      itemCount: freezed == itemCount
          ? _value.itemCount
          : itemCount // ignore: cast_nullable_to_non_nullable
              as int?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      publishTime: freezed == publishTime
          ? _value.publishTime
          : publishTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: freezed == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<PortfolioItemModel>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserSummaryModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserSummaryModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PortfolioDetailModelImplCopyWith<$Res>
    implements $PortfolioDetailModelCopyWith<$Res> {
  factory _$$PortfolioDetailModelImplCopyWith(_$PortfolioDetailModelImpl value,
          $Res Function(_$PortfolioDetailModelImpl) then) =
      __$$PortfolioDetailModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? portfolioId,
      UserSummaryModel? user,
      int? userId,
      int? price,
      String? title,
      String? description,
      String? portfolioCode,
      bool? isPublished,
      int? viewCount,
      int? downloadCount,
      String? thumbnail,
      int? itemCount,
      DateTime? createdTime,
      DateTime? publishTime,
      List<PortfolioItemModel>? items});

  @override
  $UserSummaryModelCopyWith<$Res>? get user;
}

/// @nodoc
class __$$PortfolioDetailModelImplCopyWithImpl<$Res>
    extends _$PortfolioDetailModelCopyWithImpl<$Res, _$PortfolioDetailModelImpl>
    implements _$$PortfolioDetailModelImplCopyWith<$Res> {
  __$$PortfolioDetailModelImplCopyWithImpl(_$PortfolioDetailModelImpl _value,
      $Res Function(_$PortfolioDetailModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? portfolioId = freezed,
    Object? user = freezed,
    Object? userId = freezed,
    Object? price = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? portfolioCode = freezed,
    Object? isPublished = freezed,
    Object? viewCount = freezed,
    Object? downloadCount = freezed,
    Object? thumbnail = freezed,
    Object? itemCount = freezed,
    Object? createdTime = freezed,
    Object? publishTime = freezed,
    Object? items = freezed,
  }) {
    return _then(_$PortfolioDetailModelImpl(
      portfolioId: freezed == portfolioId
          ? _value.portfolioId
          : portfolioId // ignore: cast_nullable_to_non_nullable
              as int?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserSummaryModel?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      portfolioCode: freezed == portfolioCode
          ? _value.portfolioCode
          : portfolioCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isPublished: freezed == isPublished
          ? _value.isPublished
          : isPublished // ignore: cast_nullable_to_non_nullable
              as bool?,
      viewCount: freezed == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int?,
      downloadCount: freezed == downloadCount
          ? _value.downloadCount
          : downloadCount // ignore: cast_nullable_to_non_nullable
              as int?,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      itemCount: freezed == itemCount
          ? _value.itemCount
          : itemCount // ignore: cast_nullable_to_non_nullable
              as int?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      publishTime: freezed == publishTime
          ? _value.publishTime
          : publishTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: freezed == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<PortfolioItemModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PortfolioDetailModelImpl implements _PortfolioDetailModel {
  const _$PortfolioDetailModelImpl(
      {this.portfolioId,
      this.user,
      this.userId,
      this.price,
      this.title,
      this.description,
      this.portfolioCode,
      this.isPublished,
      this.viewCount,
      this.downloadCount,
      this.thumbnail,
      this.itemCount,
      this.createdTime,
      this.publishTime,
      final List<PortfolioItemModel>? items})
      : _items = items;

  factory _$PortfolioDetailModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PortfolioDetailModelImplFromJson(json);

  @override
  final int? portfolioId;
  @override
  final UserSummaryModel? user;
  @override
  final int? userId;
  @override
  final int? price;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? portfolioCode;
  @override
  final bool? isPublished;
  @override
  final int? viewCount;
  @override
  final int? downloadCount;
  @override
  final String? thumbnail;
  @override
  final int? itemCount;
  @override
  final DateTime? createdTime;
  @override
  final DateTime? publishTime;
  final List<PortfolioItemModel>? _items;
  @override
  List<PortfolioItemModel>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PortfolioDetailModel(portfolioId: $portfolioId, user: $user, userId: $userId, price: $price, title: $title, description: $description, portfolioCode: $portfolioCode, isPublished: $isPublished, viewCount: $viewCount, downloadCount: $downloadCount, thumbnail: $thumbnail, itemCount: $itemCount, createdTime: $createdTime, publishTime: $publishTime, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PortfolioDetailModelImpl &&
            (identical(other.portfolioId, portfolioId) ||
                other.portfolioId == portfolioId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.portfolioCode, portfolioCode) ||
                other.portfolioCode == portfolioCode) &&
            (identical(other.isPublished, isPublished) ||
                other.isPublished == isPublished) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.downloadCount, downloadCount) ||
                other.downloadCount == downloadCount) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.publishTime, publishTime) ||
                other.publishTime == publishTime) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      portfolioId,
      user,
      userId,
      price,
      title,
      description,
      portfolioCode,
      isPublished,
      viewCount,
      downloadCount,
      thumbnail,
      itemCount,
      createdTime,
      publishTime,
      const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PortfolioDetailModelImplCopyWith<_$PortfolioDetailModelImpl>
      get copyWith =>
          __$$PortfolioDetailModelImplCopyWithImpl<_$PortfolioDetailModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PortfolioDetailModelImplToJson(
      this,
    );
  }
}

abstract class _PortfolioDetailModel implements PortfolioDetailModel {
  const factory _PortfolioDetailModel(
      {final int? portfolioId,
      final UserSummaryModel? user,
      final int? userId,
      final int? price,
      final String? title,
      final String? description,
      final String? portfolioCode,
      final bool? isPublished,
      final int? viewCount,
      final int? downloadCount,
      final String? thumbnail,
      final int? itemCount,
      final DateTime? createdTime,
      final DateTime? publishTime,
      final List<PortfolioItemModel>? items}) = _$PortfolioDetailModelImpl;

  factory _PortfolioDetailModel.fromJson(Map<String, dynamic> json) =
      _$PortfolioDetailModelImpl.fromJson;

  @override
  int? get portfolioId;
  @override
  UserSummaryModel? get user;
  @override
  int? get userId;
  @override
  int? get price;
  @override
  String? get title;
  @override
  String? get description;
  @override
  String? get portfolioCode;
  @override
  bool? get isPublished;
  @override
  int? get viewCount;
  @override
  int? get downloadCount;
  @override
  String? get thumbnail;
  @override
  int? get itemCount;
  @override
  DateTime? get createdTime;
  @override
  DateTime? get publishTime;
  @override
  List<PortfolioItemModel>? get items;
  @override
  @JsonKey(ignore: true)
  _$$PortfolioDetailModelImplCopyWith<_$PortfolioDetailModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
