// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_movies_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteMoviesResponse _$FavoriteMoviesResponseFromJson(
        Map<String, dynamic> json) =>
    FavoriteMoviesResponse(
      movies: (json['data'] as List<dynamic>)
          .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FavoriteMoviesResponseToJson(
        FavoriteMoviesResponse instance) =>
    <String, dynamic>{
      'data': instance.movies,
    };
