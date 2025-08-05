class Movie {
  String id;
  String title;
  String director;
  String genre;
  int year;

  Movie({
    required this.id,
    required this.title,
    required this.director,
    required this.genre,
    required this.year,
  });

  factory Movie.fromMap(Map<String, dynamic> map, String id) {
    return Movie(
      id: id,
      title: map['title'] ?? '',
      director: map['director'] ?? '',
      genre: map['genre'] ?? '',
      year: map['year'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'director': director,
      'genre': genre,
      'year': year,
    };
  }
}
