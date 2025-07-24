import 'package:json_annotation/json_annotation.dart';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final String? email;
  @JsonKey(includeIfNull: false)
  final String? photoUrl;
  final String? token;

  const RegisterResponse({
    this.id,
    this.name,
    this.email,
    this.photoUrl,
    this.token,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json['data'] as Map<String, dynamic>);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'data': _$RegisterResponseToJson(this),
      };
}
