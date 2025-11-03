import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
class FailureEntity with _$FailureEntity {
  const FailureEntity._();

  const factory FailureEntity.serverFailure(String code, String message) =
      ServerFailure;
  const factory FailureEntity.dataParsingFailure() = DataParsingFailure;
  const factory FailureEntity.noConnectionFailure() = NoConnectionFailure;
  const factory FailureEntity.systemFailure(String code, String message) =
      SystemFailure;

  String? errorCode() {
    if (this is ServerFailure) return (this as ServerFailure).code;
    if (this is SystemFailure) return (this as SystemFailure).code;
    if (this is DataParsingFailure) return '12002';
    if (this is NoConnectionFailure) return '12001';
    return '12003';
  }
}
