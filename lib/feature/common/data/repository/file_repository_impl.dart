import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/common/data/datasource/file_datasource.dart';
import 'package:events_app/feature/common/data/model/file_model.dart';
import 'package:events_app/feature/common/domain/entity/file_entity.dart';
import 'package:events_app/feature/common/domain/repository/file_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FileRepository)
class FileRepositoryImpl implements FileRepository {
  final FileDatasource _datasource;

  FileRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, FileEntity>> uploadFile({
    required String filePath,
    required String fileType,
  }) async {
    final response = await _datasource.uploadFile(
      filePath: filePath,
      fileType: fileType,
    );
    return response.toEither().map((model) => model.toEntity());
  }

  @override
  Future<Either<FailureEntity, void>> deleteFile(int fileId) async {
    final response = await _datasource.deleteFile(fileId);
    return response.toEitherUnit();
  }
}
