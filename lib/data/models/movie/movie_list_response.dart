import 'package:json_annotation/json_annotation.dart';
import 'package:shartflix/data/models/movie/pagination.dart';

import 'movie_model.dart';

part 'movie_list_response.g.dart';

@JsonSerializable()
class MovieListResponse {
  final List<MovieModel> movies;
  final Pagination pagination;

  const MovieListResponse({
    required this.movies,
    required this.pagination,
  });

  factory MovieListResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieListResponseFromJson(json['data'] as Map<String, dynamic>);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'data': _$MovieListResponseToJson(this),
      };
}
