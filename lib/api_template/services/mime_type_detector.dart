class MimeTypeDetector {
  static String getMimeType(String fileName) {
    final mimeTypes = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'pdf': 'application/pdf',
      'txt': 'text/plain',
      'html': 'text/html',
      'css': 'text/css',
      'csv': 'text/csv',
      'json': 'application/json',
      'xml': 'application/xml',
      'zip': 'application/zip',
      'mp4': 'video/mp4',
      'mp3': 'audio/mpeg',
    };
    final extension = fileName.split('.').last.toLowerCase();

    return mimeTypes[extension] ?? 'image/png';
  }
}
