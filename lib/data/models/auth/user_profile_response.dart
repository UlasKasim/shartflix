import 'package:json_annotation/json_annotation.dart';

part 'user_profile_response.g.dart';

@JsonSerializable()
class UserProfileResponse {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final String? email;
  @JsonKey(includeIfNull: false)
  final String? photoUrl;
  final String? token;

  const UserProfileResponse({
    this.id,
    this.name,
    this.email,
    this.photoUrl,
    this.token,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$UserProfileResponseFromJson(json['data'] as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$UserProfileResponseToJson(this);
}
