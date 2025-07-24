import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final String? email;
  @JsonKey(includeIfNull: false)
  final String? photoUrl;
  final String? token;

  const LoginResponse({
    this.id,
    this.name,
    this.email,
    this.photoUrl,
    this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json['data'] as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
