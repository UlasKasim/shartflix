// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toggle_favorite_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ToggleFavoriteResponse _$ToggleFavoriteResponseFromJson(
        Map<String, dynamic> json) =>
    ToggleFavoriteResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ToggleFavoriteResponseToJson(
        ToggleFavoriteResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
    };
