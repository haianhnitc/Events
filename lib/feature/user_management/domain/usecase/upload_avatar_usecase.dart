import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/usecase/upload_file_params.dart';
import 'package:events_app/feature/common/usecase/upload_file_usecase.dart';
import 'package:injectable/injectable.dart';

class UploadAvatarParams {
  final String filePath;

  const UploadAvatarParams({
    required this.filePath,
  });
}

@injectable
class UploadAvatarUsecase implements UseCase<String, UploadAvatarParams> {
  UploadAvatarUsecase();

  @override
  Future<Either<FailureEntity, String>> call(UploadAvatarParams params) async {
    final uploadFileUsecase = networkGetIt<UploadFileUsecase>();
    final result = await uploadFileUsecase(
      UploadFileParams(filePath: params.filePath, fileType: FileType.avatar),
    );
    return result.map((file) => file.url ?? '');
  }
}
