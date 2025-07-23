import 'package:json_annotation/json_annotation.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'Title')
  final String? title;
  @JsonKey(name: 'Plot')
  final String? description;
  @JsonKey(name: 'Poster')
  final String? posterUrl;
  final bool? isFavorite;
  @JsonKey(name: 'Year')
  final String? year;
  @JsonKey(name: 'Rated')
  final String? rated;
  @JsonKey(name: 'Released')
  final String? released;
  @JsonKey(name: 'Runtime')
  final String? runtime;
  @JsonKey(name: 'Genre')
  final String? genre;
  @JsonKey(name: 'Director')
  final String? director;
  @JsonKey(name: 'Writer')
  final String? writer;
  @JsonKey(name: 'Actors')
  final String? actors;
  @JsonKey(name: 'Language')
  final String? language;
  @JsonKey(name: 'Country')
  final String? country;
  @JsonKey(name: 'Awards')
  final String? awards;
  @JsonKey(name: 'Metascore')
  final String? metascore;
  final String? imdbRating;
  final String? imdbVotes;
  final String? imdbID;
  @JsonKey(name: 'Type')
  final String? type;
  @JsonKey(name: 'Response')
  final String? response;
  @JsonKey(name: 'Images')
  final List<String>? images;
  @JsonKey(name: 'ComingSoon')
  final bool? comingSoon;

  const MovieModel({
    this.id,
    this.title,
    this.description,
    this.posterUrl,
    this.isFavorite,
    this.year,
    this.rated,
    this.released,
    this.runtime,
    this.genre,
    this.director,
    this.writer,
    this.actors,
    this.language,
    this.country,
    this.awards,
    this.metascore,
    this.imdbRating,
    this.imdbVotes,
    this.imdbID,
    this.type,
    this.response,
    this.images,
    this.comingSoon,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  MovieModel copyWith({
    String? id,
    String? title,
    String? description,
    String? posterUrl,
    bool? isFavorite,
    String? year,
    String? rated,
    String? released,
    String? runtime,
    String? genre,
    String? director,
    String? writer,
    String? actors,
    String? language,
    String? country,
    String? awards,
    String? metascore,
    String? imdbRating,
    String? imdbVotes,
    String? imdbID,
    String? type,
    String? response,
    List<String>? images,
    bool? comingSoon,
  }) {
    return MovieModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      posterUrl: posterUrl ?? this.posterUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      year: year ?? this.year,
      rated: rated ?? this.rated,
      released: released ?? this.released,
      runtime: runtime ?? this.runtime,
      genre: genre ?? this.genre,
      director: director ?? this.director,
      writer: writer ?? this.writer,
      actors: actors ?? this.actors,
      language: language ?? this.language,
      country: country ?? this.country,
      awards: awards ?? this.awards,
      metascore: metascore ?? this.metascore,
      imdbRating: imdbRating ?? this.imdbRating,
      imdbVotes: imdbVotes ?? this.imdbVotes,
      imdbID: imdbID ?? this.imdbID,
      type: type ?? this.type,
      response: response ?? this.response,
      images: images ?? this.images,
      comingSoon: comingSoon ?? this.comingSoon,
    );
  }
}
