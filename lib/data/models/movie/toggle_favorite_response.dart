import 'package:json_annotation/json_annotation.dart';

part 'toggle_favorite_response.g.dart';

@JsonSerializable()
class ToggleFavoriteResponse {
  final bool? success;
  final String? message;

  const ToggleFavoriteResponse({
    this.success,
    this.message,
  });

  factory ToggleFavoriteResponse.fromJson(Map<String, dynamic> json) =>
      _$ToggleFavoriteResponseFromJson(json['data'] as Map<String, dynamic>);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'data': _$ToggleFavoriteResponseToJson(this),
      };
}
