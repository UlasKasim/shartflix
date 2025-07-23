class MovieEntity {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  final bool isFavorite;
  final String year;
  final String genre;
  final String? rated;
  final String? released;
  final String? runtime;
  final String? director;
  final String? writer;
  final String? actors;
  final String? language;
  final String? country;
  final String? awards;
  final String? metascore;
  final String? imdbRating;
  final String? imdbVotes;
  final String? imdbID;
  final String? type;
  final List<String>? images;
  final bool? comingSoon;

  const MovieEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.isFavorite,
    required this.year,
    required this.genre,
    this.rated,
    this.released,
    this.runtime,
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
    this.images,
    this.comingSoon,
  });

  MovieEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? posterUrl,
    bool? isFavorite,
    String? year,
    String? genre,
    String? rated,
    String? released,
    String? runtime,
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
    List<String>? images,
    bool? comingSoon,
  }) {
    return MovieEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      posterUrl: posterUrl ?? this.posterUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      year: year ?? this.year,
      genre: genre ?? this.genre,
      rated: rated ?? this.rated,
      released: released ?? this.released,
      runtime: runtime ?? this.runtime,
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
      images: images ?? this.images,
      comingSoon: comingSoon ?? this.comingSoon,
    );
  }
}
