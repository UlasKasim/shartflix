import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: '_id')
  final String? id; // Nullable
  final String? name; // Nullable
  final String? email; // Nullable
  @JsonKey(includeIfNull: false)
  final String? photoUrl; // Nullable to handle "" or null
  final String? token; // Nullable

  const LoginResponse({
    this.id,
    this.name,
    this.email,
    this.photoUrl,
    this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(
          json['data'] as Map<String, dynamic>); // Map from 'data'

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
