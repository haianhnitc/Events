import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class VerificationDocumentEntity {
  final int? verificationDocumentId;
  final int? userId;
  final DocumentType? documentType;
  final String? fileUrl;
  final String? originalFileName;
  final DateTime? createdTime;

  VerificationDocumentEntity({
    this.verificationDocumentId,
    this.userId,
    this.documentType,
    this.fileUrl,
    this.originalFileName,
    this.createdTime,
  });
}
