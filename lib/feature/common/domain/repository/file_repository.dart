import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/common/domain/entity/file_entity.dart';

abstract class FileRepository {
  Future<Either<FailureEntity, FileEntity>> uploadFile({
    required String filePath,
    required String fileType,
  });

  Future<Either<FailureEntity, void>> deleteFile(int fileId);
}
