import 'package:json_annotation/json_annotation.dart';

part 'upload_photo_response.g.dart';

@JsonSerializable()
class UploadPhotoResponse {
  @JsonKey(name: 'photoUrl')
  final String photoUrl;

  const UploadPhotoResponse({
    required this.photoUrl,
  });

  factory UploadPhotoResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadPhotoResponseFromJson(json['data'] as Map<String, dynamic>);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'data': _$UploadPhotoResponseToJson(this),
      };
}
