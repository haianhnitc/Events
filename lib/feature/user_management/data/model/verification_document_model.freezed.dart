// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verification_document_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VerificationDocumentModel _$VerificationDocumentModelFromJson(
    Map<String, dynamic> json) {
  return _VerificationDocumentModel.fromJson(json);
}

/// @nodoc
mixin _$VerificationDocumentModel {
  int? get verificationDocumentId => throw _privateConstructorUsedError;
  UserSummaryModel? get userSummary => throw _privateConstructorUsedError;
  DocumentType? get documentType => throw _privateConstructorUsedError;
  String? get fileUrl => throw _privateConstructorUsedError;
  String? get originalFileName => throw _privateConstructorUsedError;
  DateTime? get createdTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VerificationDocumentModelCopyWith<VerificationDocumentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationDocumentModelCopyWith<$Res> {
  factory $VerificationDocumentModelCopyWith(VerificationDocumentModel value,
          $Res Function(VerificationDocumentModel) then) =
      _$VerificationDocumentModelCopyWithImpl<$Res, VerificationDocumentModel>;
  @useResult
  $Res call(
      {int? verificationDocumentId,
      UserSummaryModel? userSummary,
      DocumentType? documentType,
      String? fileUrl,
      String? originalFileName,
      DateTime? createdTime});

  $UserSummaryModelCopyWith<$Res>? get userSummary;
}

/// @nodoc
class _$VerificationDocumentModelCopyWithImpl<$Res,
        $Val extends VerificationDocumentModel>
    implements $VerificationDocumentModelCopyWith<$Res> {
  _$VerificationDocumentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? verificationDocumentId = freezed,
    Object? userSummary = freezed,
    Object? documentType = freezed,
    Object? fileUrl = freezed,
    Object? originalFileName = freezed,
    Object? createdTime = freezed,
  }) {
    return _then(_value.copyWith(
      verificationDocumentId: freezed == verificationDocumentId
          ? _value.verificationDocumentId
          : verificationDocumentId // ignore: cast_nullable_to_non_nullable
              as int?,
      userSummary: freezed == userSummary
          ? _value.userSummary
          : userSummary // ignore: cast_nullable_to_non_nullable
              as UserSummaryModel?,
      documentType: freezed == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as DocumentType?,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      originalFileName: freezed == originalFileName
          ? _value.originalFileName
          : originalFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserSummaryModelCopyWith<$Res>? get userSummary {
    if (_value.userSummary == null) {
      return null;
    }

    return $UserSummaryModelCopyWith<$Res>(_value.userSummary!, (value) {
      return _then(_value.copyWith(userSummary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VerificationDocumentModelImplCopyWith<$Res>
    implements $VerificationDocumentModelCopyWith<$Res> {
  factory _$$VerificationDocumentModelImplCopyWith(
          _$VerificationDocumentModelImpl value,
          $Res Function(_$VerificationDocumentModelImpl) then) =
      __$$VerificationDocumentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? verificationDocumentId,
      UserSummaryModel? userSummary,
      DocumentType? documentType,
      String? fileUrl,
      String? originalFileName,
      DateTime? createdTime});

  @override
  $UserSummaryModelCopyWith<$Res>? get userSummary;
}

/// @nodoc
class __$$VerificationDocumentModelImplCopyWithImpl<$Res>
    extends _$VerificationDocumentModelCopyWithImpl<$Res,
        _$VerificationDocumentModelImpl>
    implements _$$VerificationDocumentModelImplCopyWith<$Res> {
  __$$VerificationDocumentModelImplCopyWithImpl(
      _$VerificationDocumentModelImpl _value,
      $Res Function(_$VerificationDocumentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? verificationDocumentId = freezed,
    Object? userSummary = freezed,
    Object? documentType = freezed,
    Object? fileUrl = freezed,
    Object? originalFileName = freezed,
    Object? createdTime = freezed,
  }) {
    return _then(_$VerificationDocumentModelImpl(
      verificationDocumentId: freezed == verificationDocumentId
          ? _value.verificationDocumentId
          : verificationDocumentId // ignore: cast_nullable_to_non_nullable
              as int?,
      userSummary: freezed == userSummary
          ? _value.userSummary
          : userSummary // ignore: cast_nullable_to_non_nullable
              as UserSummaryModel?,
      documentType: freezed == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as DocumentType?,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      originalFileName: freezed == originalFileName
          ? _value.originalFileName
          : originalFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerificationDocumentModelImpl implements _VerificationDocumentModel {
  const _$VerificationDocumentModelImpl(
      {this.verificationDocumentId,
      this.userSummary,
      this.documentType,
      this.fileUrl,
      this.originalFileName,
      this.createdTime});

  factory _$VerificationDocumentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerificationDocumentModelImplFromJson(json);

  @override
  final int? verificationDocumentId;
  @override
  final UserSummaryModel? userSummary;
  @override
  final DocumentType? documentType;
  @override
  final String? fileUrl;
  @override
  final String? originalFileName;
  @override
  final DateTime? createdTime;

  @override
  String toString() {
    return 'VerificationDocumentModel(verificationDocumentId: $verificationDocumentId, userSummary: $userSummary, documentType: $documentType, fileUrl: $fileUrl, originalFileName: $originalFileName, createdTime: $createdTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationDocumentModelImpl &&
            (identical(other.verificationDocumentId, verificationDocumentId) ||
                other.verificationDocumentId == verificationDocumentId) &&
            (identical(other.userSummary, userSummary) ||
                other.userSummary == userSummary) &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.originalFileName, originalFileName) ||
                other.originalFileName == originalFileName) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, verificationDocumentId,
      userSummary, documentType, fileUrl, originalFileName, createdTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationDocumentModelImplCopyWith<_$VerificationDocumentModelImpl>
      get copyWith => __$$VerificationDocumentModelImplCopyWithImpl<
          _$VerificationDocumentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerificationDocumentModelImplToJson(
      this,
    );
  }
}

abstract class _VerificationDocumentModel implements VerificationDocumentModel {
  const factory _VerificationDocumentModel(
      {final int? verificationDocumentId,
      final UserSummaryModel? userSummary,
      final DocumentType? documentType,
      final String? fileUrl,
      final String? originalFileName,
      final DateTime? createdTime}) = _$VerificationDocumentModelImpl;

  factory _VerificationDocumentModel.fromJson(Map<String, dynamic> json) =
      _$VerificationDocumentModelImpl.fromJson;

  @override
  int? get verificationDocumentId;
  @override
  UserSummaryModel? get userSummary;
  @override
  DocumentType? get documentType;
  @override
  String? get fileUrl;
  @override
  String? get originalFileName;
  @override
  DateTime? get createdTime;
  @override
  @JsonKey(ignore: true)
  _$$VerificationDocumentModelImplCopyWith<_$VerificationDocumentModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
