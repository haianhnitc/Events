// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'portfolio_create_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PortfolioItemCreateModel _$PortfolioItemCreateModelFromJson(
    Map<String, dynamic> json) {
  return _PortfolioItemCreateModel.fromJson(json);
}

/// @nodoc
mixin _$PortfolioItemCreateModel {
  int get eventParticipantId => throw _privateConstructorUsedError;
  String? get displayTitle => throw _privateConstructorUsedError;
  String? get displayRole => throw _privateConstructorUsedError;
  String? get displayNote => throw _privateConstructorUsedError;
  int? get displayOrder => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PortfolioItemCreateModelCopyWith<PortfolioItemCreateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PortfolioItemCreateModelCopyWith<$Res> {
  factory $PortfolioItemCreateModelCopyWith(PortfolioItemCreateModel value,
          $Res Function(PortfolioItemCreateModel) then) =
      _$PortfolioItemCreateModelCopyWithImpl<$Res, PortfolioItemCreateModel>;
  @useResult
  $Res call(
      {int eventParticipantId,
      String? displayTitle,
      String? displayRole,
      String? displayNote,
      int? displayOrder});
}

/// @nodoc
class _$PortfolioItemCreateModelCopyWithImpl<$Res,
        $Val extends PortfolioItemCreateModel>
    implements $PortfolioItemCreateModelCopyWith<$Res> {
  _$PortfolioItemCreateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventParticipantId = null,
    Object? displayTitle = freezed,
    Object? displayRole = freezed,
    Object? displayNote = freezed,
    Object? displayOrder = freezed,
  }) {
    return _then(_value.copyWith(
      eventParticipantId: null == eventParticipantId
          ? _value.eventParticipantId
          : eventParticipantId // ignore: cast_nullable_to_non_nullable
              as int,
      displayTitle: freezed == displayTitle
          ? _value.displayTitle
          : displayTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      displayRole: freezed == displayRole
          ? _value.displayRole
          : displayRole // ignore: cast_nullable_to_non_nullable
              as String?,
      displayNote: freezed == displayNote
          ? _value.displayNote
          : displayNote // ignore: cast_nullable_to_non_nullable
              as String?,
      displayOrder: freezed == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PortfolioItemCreateModelImplCopyWith<$Res>
    implements $PortfolioItemCreateModelCopyWith<$Res> {
  factory _$$PortfolioItemCreateModelImplCopyWith(
          _$PortfolioItemCreateModelImpl value,
          $Res Function(_$PortfolioItemCreateModelImpl) then) =
      __$$PortfolioItemCreateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int eventParticipantId,
      String? displayTitle,
      String? displayRole,
      String? displayNote,
      int? displayOrder});
}

/// @nodoc
class __$$PortfolioItemCreateModelImplCopyWithImpl<$Res>
    extends _$PortfolioItemCreateModelCopyWithImpl<$Res,
        _$PortfolioItemCreateModelImpl>
    implements _$$PortfolioItemCreateModelImplCopyWith<$Res> {
  __$$PortfolioItemCreateModelImplCopyWithImpl(
      _$PortfolioItemCreateModelImpl _value,
      $Res Function(_$PortfolioItemCreateModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventParticipantId = null,
    Object? displayTitle = freezed,
    Object? displayRole = freezed,
    Object? displayNote = freezed,
    Object? displayOrder = freezed,
  }) {
    return _then(_$PortfolioItemCreateModelImpl(
      eventParticipantId: null == eventParticipantId
          ? _value.eventParticipantId
          : eventParticipantId // ignore: cast_nullable_to_non_nullable
              as int,
      displayTitle: freezed == displayTitle
          ? _value.displayTitle
          : displayTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      displayRole: freezed == displayRole
          ? _value.displayRole
          : displayRole // ignore: cast_nullable_to_non_nullable
              as String?,
      displayNote: freezed == displayNote
          ? _value.displayNote
          : displayNote // ignore: cast_nullable_to_non_nullable
              as String?,
      displayOrder: freezed == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PortfolioItemCreateModelImpl implements _PortfolioItemCreateModel {
  const _$PortfolioItemCreateModelImpl(
      {required this.eventParticipantId,
      this.displayTitle,
      this.displayRole,
      this.displayNote,
      this.displayOrder});

  factory _$PortfolioItemCreateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PortfolioItemCreateModelImplFromJson(json);

  @override
  final int eventParticipantId;
  @override
  final String? displayTitle;
  @override
  final String? displayRole;
  @override
  final String? displayNote;
  @override
  final int? displayOrder;

  @override
  String toString() {
    return 'PortfolioItemCreateModel(eventParticipantId: $eventParticipantId, displayTitle: $displayTitle, displayRole: $displayRole, displayNote: $displayNote, displayOrder: $displayOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PortfolioItemCreateModelImpl &&
            (identical(other.eventParticipantId, eventParticipantId) ||
                other.eventParticipantId == eventParticipantId) &&
            (identical(other.displayTitle, displayTitle) ||
                other.displayTitle == displayTitle) &&
            (identical(other.displayRole, displayRole) ||
                other.displayRole == displayRole) &&
            (identical(other.displayNote, displayNote) ||
                other.displayNote == displayNote) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, eventParticipantId, displayTitle,
      displayRole, displayNote, displayOrder);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PortfolioItemCreateModelImplCopyWith<_$PortfolioItemCreateModelImpl>
      get copyWith => __$$PortfolioItemCreateModelImplCopyWithImpl<
          _$PortfolioItemCreateModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PortfolioItemCreateModelImplToJson(
      this,
    );
  }
}

abstract class _PortfolioItemCreateModel implements PortfolioItemCreateModel {
  const factory _PortfolioItemCreateModel(
      {required final int eventParticipantId,
      final String? displayTitle,
      final String? displayRole,
      final String? displayNote,
      final int? displayOrder}) = _$PortfolioItemCreateModelImpl;

  factory _PortfolioItemCreateModel.fromJson(Map<String, dynamic> json) =
      _$PortfolioItemCreateModelImpl.fromJson;

  @override
  int get eventParticipantId;
  @override
  String? get displayTitle;
  @override
  String? get displayRole;
  @override
  String? get displayNote;
  @override
  int? get displayOrder;
  @override
  @JsonKey(ignore: true)
  _$$PortfolioItemCreateModelImplCopyWith<_$PortfolioItemCreateModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PortfolioCreateModel _$PortfolioCreateModelFromJson(Map<String, dynamic> json) {
  return _PortfolioCreateModel.fromJson(json);
}

/// @nodoc
mixin _$PortfolioCreateModel {
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError;
  int get coinUsed => throw _privateConstructorUsedError;
  List<PortfolioItemCreateModel>? get items =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PortfolioCreateModelCopyWith<PortfolioCreateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PortfolioCreateModelCopyWith<$Res> {
  factory $PortfolioCreateModelCopyWith(PortfolioCreateModel value,
          $Res Function(PortfolioCreateModel) then) =
      _$PortfolioCreateModelCopyWithImpl<$Res, PortfolioCreateModel>;
  @useResult
  $Res call(
      {String title,
      String? description,
      int price,
      int coinUsed,
      List<PortfolioItemCreateModel>? items});
}

/// @nodoc
class _$PortfolioCreateModelCopyWithImpl<$Res,
        $Val extends PortfolioCreateModel>
    implements $PortfolioCreateModelCopyWith<$Res> {
  _$PortfolioCreateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? price = null,
    Object? coinUsed = null,
    Object? items = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      coinUsed: null == coinUsed
          ? _value.coinUsed
          : coinUsed // ignore: cast_nullable_to_non_nullable
              as int,
      items: freezed == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<PortfolioItemCreateModel>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PortfolioCreateModelImplCopyWith<$Res>
    implements $PortfolioCreateModelCopyWith<$Res> {
  factory _$$PortfolioCreateModelImplCopyWith(_$PortfolioCreateModelImpl value,
          $Res Function(_$PortfolioCreateModelImpl) then) =
      __$$PortfolioCreateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String? description,
      int price,
      int coinUsed,
      List<PortfolioItemCreateModel>? items});
}

/// @nodoc
class __$$PortfolioCreateModelImplCopyWithImpl<$Res>
    extends _$PortfolioCreateModelCopyWithImpl<$Res, _$PortfolioCreateModelImpl>
    implements _$$PortfolioCreateModelImplCopyWith<$Res> {
  __$$PortfolioCreateModelImplCopyWithImpl(_$PortfolioCreateModelImpl _value,
      $Res Function(_$PortfolioCreateModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? price = null,
    Object? coinUsed = null,
    Object? items = freezed,
  }) {
    return _then(_$PortfolioCreateModelImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      coinUsed: null == coinUsed
          ? _value.coinUsed
          : coinUsed // ignore: cast_nullable_to_non_nullable
              as int,
      items: freezed == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<PortfolioItemCreateModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PortfolioCreateModelImpl implements _PortfolioCreateModel {
  const _$PortfolioCreateModelImpl(
      {required this.title,
      this.description,
      this.price = 0,
      this.coinUsed = 0,
      final List<PortfolioItemCreateModel>? items})
      : _items = items;

  factory _$PortfolioCreateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PortfolioCreateModelImplFromJson(json);

  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey()
  final int price;
  @override
  @JsonKey()
  final int coinUsed;
  final List<PortfolioItemCreateModel>? _items;
  @override
  List<PortfolioItemCreateModel>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PortfolioCreateModel(title: $title, description: $description, price: $price, coinUsed: $coinUsed, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PortfolioCreateModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.coinUsed, coinUsed) ||
                other.coinUsed == coinUsed) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, title, description, price,
      coinUsed, const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PortfolioCreateModelImplCopyWith<_$PortfolioCreateModelImpl>
      get copyWith =>
          __$$PortfolioCreateModelImplCopyWithImpl<_$PortfolioCreateModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PortfolioCreateModelImplToJson(
      this,
    );
  }
}

abstract class _PortfolioCreateModel implements PortfolioCreateModel {
  const factory _PortfolioCreateModel(
          {required final String title,
          final String? description,
          final int price,
          final int coinUsed,
          final List<PortfolioItemCreateModel>? items}) =
      _$PortfolioCreateModelImpl;

  factory _PortfolioCreateModel.fromJson(Map<String, dynamic> json) =
      _$PortfolioCreateModelImpl.fromJson;

  @override
  String get title;
  @override
  String? get description;
  @override
  int get price;
  @override
  int get coinUsed;
  @override
  List<PortfolioItemCreateModel>? get items;
  @override
  @JsonKey(ignore: true)
  _$$PortfolioCreateModelImplCopyWith<_$PortfolioCreateModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
