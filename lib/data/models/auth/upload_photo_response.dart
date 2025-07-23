import 'package:json_annotation/json_annotation.dart';

part 'upload_photo_response.g.dart';

//TODO
@JsonSerializable()
class UploadPhotoResponse {
  @JsonKey(name: 'photoUrl')
  final String photoUrl;

  const UploadPhotoResponse({
    required this.photoUrl,
  });

  factory UploadPhotoResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadPhotoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UploadPhotoResponseToJson(this);
}
