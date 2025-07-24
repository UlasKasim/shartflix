import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

part 'upload_photo_request.g.dart';

@JsonSerializable()
class UploadPhotoRequest {
  // Exclude from JSON but make it nullable for JSON generator
  @JsonKey(includeFromJson: false, includeToJson: false)
  final MultipartFile? file;

  // Optional metadata that can be serialized
  final String? filename;
  final String? contentType;

  const UploadPhotoRequest({
    this.file,
    this.filename,
    this.contentType,
  });

  // Build runner will generate this - uses _json constructor
  factory UploadPhotoRequest.fromJson(Map<String, dynamic> json) =>
      _$UploadPhotoRequestFromJson(json);

  // Build runner will generate this
  Map<String, dynamic> toJson() {
    // Manual override for FormData
    if (file != null) {
      return {
        'file': file!,
      };
    }
    // Fallback to generated JSON
    return _$UploadPhotoRequestToJson(this);
  }

  // Factory method for actual usage
  static Future<UploadPhotoRequest> fromFilePath(
    String filePath, {
    String? filename,
    MediaType? contentType,
  }) async {
    final actualFilename = filename ?? path.basename(filePath);
    final extension = path.extension(filePath).toLowerCase();
    final mimeType = extension == '.jpg' || extension == '.jpeg'
        ? MediaType('image', 'jpeg')
        : extension == '.png'
            ? MediaType('image', 'png')
            : MediaType('application', 'octet-stream');

    final multipartFile = await MultipartFile.fromFile(
      filePath,
      filename: actualFilename,
    );

    return UploadPhotoRequest(
      file: multipartFile,
      filename: actualFilename,
      contentType: mimeType.toString(),
    );
  }

  // Helper method to convert to FormData
  FormData toFormData() {
    if (file == null) {
      throw StateError('File is required for FormData conversion');
    }
    return FormData.fromMap({
      'file': file!,
    });
  }
}
