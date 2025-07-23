import 'package:json_annotation/json_annotation.dart';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse {
  @JsonKey(name: '_id')
  final String? id; // Nullable to handle edge cases
  final String? name; // Nullable
  final String? email; // Nullable
  @JsonKey(includeIfNull: false)
  final String? photoUrl; // Nullable to handle "" or null
  final String? token; // Nullable

  const RegisterResponse({
    this.id,
    this.name,
    this.email,
    this.photoUrl,
    this.token,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(
          json['data'] as Map<String, dynamic>); // Map from 'data'

  Map<String, dynamic> toJson() => <String, dynamic>{
        'data': _$RegisterResponseToJson(this),
      };
}
