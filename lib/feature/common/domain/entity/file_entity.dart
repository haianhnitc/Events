class FileEntity {
  final int? fileId;
  final String? url;
  final String? fileType;
  final int? fileSize;
  final DateTime? createdTime;

  FileEntity({
    this.fileId,
    this.url,
    this.fileType,
    this.fileSize,
    this.createdTime,
  });

  FileEntity copyWith({
    int? fileId,
    String? url,
    String? fileType,
    int? fileSize,
    DateTime? createdTime,
  }) {
    return FileEntity(
      fileId: fileId ?? this.fileId,
      url: url ?? this.url,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  @override
  String toString() => 'FileEntity(fileId: $fileId, url: $url, fileType: $fileType)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FileEntity && other.fileId == fileId;
  }

  @override
  int get hashCode => Object.hash(fileId, url, fileType, fileSize, createdTime);
}
