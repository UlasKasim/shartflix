import 'package:json_annotation/json_annotation.dart';

part 'user_profile_response.g.dart';

@JsonSerializable()
class UserProfileResponse {
  @JsonKey(name: '_id')
  final String? id; // Nullable
  final String? name; // Nullable
  final String? email; // Nullable
  @JsonKey(includeIfNull: false)
  final String? photoUrl; // Nullable to handle "" or null
  final String? token; // Nullable

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
