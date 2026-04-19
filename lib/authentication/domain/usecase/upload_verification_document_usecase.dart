import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/domain/repository/auth_repository.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/user_management/domain/entity/verification_document_entity.dart';
import 'package:injectable/injectable.dart';

class UploadVerificationDocumentParams {
  final int fileId;
  final String documentType;

  const UploadVerificationDocumentParams({
    required this.fileId,
    required this.documentType,
  });
}

@injectable
class UploadVerificationDocumentUsecase
    implements UseCase<VerificationDocumentEntity, UploadVerificationDocumentParams> {
  final AuthRepository _repository;

  UploadVerificationDocumentUsecase(this._repository);

  @override
  Future<Either<FailureEntity, VerificationDocumentEntity>> call(
    UploadVerificationDocumentParams params,
  ) {
    return _repository.uploadVerificationDocument(
      fileId: params.fileId,
      documentType: params.documentType,
    );
  }
}
