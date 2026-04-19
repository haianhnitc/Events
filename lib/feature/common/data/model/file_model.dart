import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/file_entity.dart';

part 'file_model.freezed.dart';
part 'file_model.g.dart';

@freezed
class FileModel with _$FileModel {
  const factory FileModel({
    int? fileId,
    String? url,
    String? fileType,
    int? fileSize,
    DateTime? createdTime,
  }) = _FileModel;

  factory FileModel.fromJson(Map<String, dynamic> json) =>
      _$FileModelFromJson(json);

  factory FileModel.fromEntity(FileEntity entity) {
    return FileModel(
      fileId: entity.fileId,
      url: entity.url,
      fileType: entity.fileType,
      fileSize: entity.fileSize,
      createdTime: entity.createdTime,
    );
  }
}

extension FileModelExtension on FileModel {
  FileEntity toEntity() {
    return FileEntity(
      fileId: fileId,
      url: url,
      fileType: fileType,
      fileSize: fileSize,
      createdTime: createdTime,
    );
  }
}
