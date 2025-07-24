// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_photo_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadPhotoRequest _$UploadPhotoRequestFromJson(Map<String, dynamic> json) =>
    UploadPhotoRequest(
      filename: json['filename'] as String?,
      contentType: json['contentType'] as String?,
    );

Map<String, dynamic> _$UploadPhotoRequestToJson(UploadPhotoRequest instance) =>
    <String, dynamic>{
      'filename': instance.filename,
      'contentType': instance.contentType,
    };
