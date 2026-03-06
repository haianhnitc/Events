import 'package:freezed_annotation/freezed_annotation.dart';

part 'common_meta.freezed.dart';
part 'common_meta.g.dart';

@freezed
@JsonSerializable(fieldRename: FieldRename.snake)
class CommonMeta with _$CommonMeta {
  const factory CommonMeta({
    dynamic code,
    dynamic page,
    dynamic size,
    dynamic total,
    dynamic message,
    dynamic requestId,
  }) = _CommonMeta;

  factory CommonMeta.fromJson(Map<String, dynamic> json) =>
      _$CommonMetaFromJson(json);
}
