import 'package:json_annotation/json_annotation.dart';

import 'movie_model.dart';

part 'favorite_movies_response.g.dart';

@JsonSerializable()
class FavoriteMoviesResponse {
  @JsonKey(name: 'data')
  final List<MovieModel> movies;

  const FavoriteMoviesResponse({
    required this.movies,
  });

  factory FavoriteMoviesResponse.fromJson(Map<String, dynamic> json) =>
      _$FavoriteMoviesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteMoviesResponseToJson(this);
}
