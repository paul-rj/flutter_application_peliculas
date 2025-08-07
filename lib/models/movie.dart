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

  /// Crear instancia Movie desde un documento de Firestore
  factory Movie.fromMap(Map<String, dynamic> map, String id) {
    return Movie(
      id: id,
      title: map['title'] ?? '',
      director: map['director'] ?? '',
      genre: map['genre'] ?? '',
      year: map['year'] ?? 0,
    );
  }

  /// Convertir Movie a mapa para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'director': director,
      'genre': genre,
      'year': year,
    };
  }

  /// Crear una copia modificada del objeto Movie
  Movie copyWith({
    String? id,
    String? title,
    String? director,
    String? genre,
    int? year,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      director: director ?? this.director,
      genre: genre ?? this.genre,
      year: year ?? this.year,
    );
  }

  @override
  String toString() {
    return 'Movie(id: $id, title: $title, director: $director, genre: $genre, year: $year)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Movie &&
        other.id == id &&
        other.title == title &&
        other.director == director &&
        other.genre == genre &&
        other.year == year;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        director.hashCode ^
        genre.hashCode ^
        year.hashCode;
  }
}
