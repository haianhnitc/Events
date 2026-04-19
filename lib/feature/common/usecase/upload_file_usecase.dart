import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/domain/entity/file_entity.dart';
import 'package:events_app/feature/common/domain/repository/file_repository.dart';
import 'package:events_app/feature/common/usecase/upload_file_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class UploadFileUsecase implements UseCase<FileEntity, UploadFileParams> {
  final FileRepository _repository;

  UploadFileUsecase(this._repository);

  @override
  Future<Either<FailureEntity, FileEntity>> call(UploadFileParams params) async {
    return await _repository.uploadFile(
      filePath: params.filePath,
      fileType: params.fileType.apiValue,
    );
  }
}
