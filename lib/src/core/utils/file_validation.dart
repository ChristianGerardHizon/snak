/// File validation utilities for upload constraints.
///
/// Provides validation for file size and type restrictions.
abstract class FileValidation {
  /// Maximum file size in bytes (5 MB).
  static const int maxFileSizeBytes = 5 * 1024 * 1024; // 5242880 bytes

  /// Maximum file size in megabytes.
  static const double maxFileSizeMB = 5.0;

  /// Allowed file extensions for upload.
  static const List<String> allowedExtensions = [
    // Images
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'bmp',
    'heic',
    // Videos
    'mp4',
    'mov',
    'avi',
    'webm',
    '3gp',
    // Documents
    'pdf',
  ];

  /// Image file extensions.
  static const List<String> imageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'bmp',
    'heic',
  ];

  /// Video file extensions.
  static const List<String> videoExtensions = [
    'mp4',
    'mov',
    'avi',
    'webm',
    '3gp',
  ];

  /// Document file extensions.
  static const List<String> documentExtensions = [
    'pdf',
  ];

  /// Validates file size and returns error message if invalid.
  ///
  /// Returns `null` if the file size is within limits.
  static String? validateFileSize(int sizeInBytes) {
    if (sizeInBytes > maxFileSizeBytes) {
      final sizeMB = (sizeInBytes / (1024 * 1024)).toStringAsFixed(1);
      return 'File size ($sizeMB MB) exceeds the $maxFileSizeMB MB limit';
    }
    return null;
  }

  /// Validates file extension and returns error message if invalid.
  ///
  /// Returns `null` if the file type is allowed.
  static String? validateFileExtension(String fileName) {
    final ext = _getExtension(fileName);
    if (!allowedExtensions.contains(ext)) {
      return 'File type ".$ext" is not supported. Allowed: images, videos, and PDFs';
    }
    return null;
  }

  /// Validates both file size and extension.
  ///
  /// Returns the first error message encountered, or `null` if valid.
  static String? validate(String fileName, int sizeInBytes) {
    return validateFileExtension(fileName) ?? validateFileSize(sizeInBytes);
  }

  /// Checks if file size is within limits.
  static bool isFileSizeValid(int sizeInBytes) {
    return sizeInBytes <= maxFileSizeBytes;
  }

  /// Checks if file extension is allowed.
  static bool isFileExtensionValid(String fileName) {
    final ext = _getExtension(fileName);
    return allowedExtensions.contains(ext);
  }

  /// Checks if the file is an image based on extension.
  static bool isImage(String fileName) {
    final ext = _getExtension(fileName);
    return imageExtensions.contains(ext);
  }

  /// Checks if the file is a video based on extension.
  static bool isVideo(String fileName) {
    final ext = _getExtension(fileName);
    return videoExtensions.contains(ext);
  }

  /// Checks if the file is a document based on extension.
  static bool isDocument(String fileName) {
    final ext = _getExtension(fileName);
    return documentExtensions.contains(ext);
  }

  /// Formats file size for display.
  ///
  /// Returns human-readable size string (e.g., "1.5 MB", "500 KB").
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  /// Gets the file extension in lowercase.
  static String _getExtension(String fileName) {
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  /// Returns a user-friendly description of allowed file types.
  static String get allowedTypesDescription =>
      'Images (JPG, PNG, GIF, WebP), Videos (MP4, MOV, AVI), and PDFs';
}
