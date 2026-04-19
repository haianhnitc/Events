import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class UploadFileParams {
  final String filePath;
  final FileType fileType;

  const UploadFileParams({
    required this.filePath,
    required this.fileType,
  });
}
