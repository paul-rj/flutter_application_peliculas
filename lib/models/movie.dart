class Movie {
  String id;
  String title;
  String director;
  String genre;
  int year;
  String? imageUrl; // URL opcional de la imagen

  Movie({
    required this.id,
    required this.title,
    required this.director,
    required this.genre,
    required this.year,
    this.imageUrl,
  });

  /// Crear instancia Movie desde Firestore
  factory Movie.fromMap(Map<String, dynamic> map, String id) {
    return Movie(
      id: id,
      title: map['title'] ?? '',
      director: map['director'] ?? '',
      genre: map['genre'] ?? '',
      year: map['year'] ?? 0,
      imageUrl: map['imageUrl'], // URL personalizada si existe
    );
  }

  /// Convertir Movie a mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'director': director,
      'genre': genre,
      'year': year,
      'imageUrl': imageUrl,
    };
  }

  /// ¿Tiene imagen personalizada?
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  /// Devuelve URL para mostrar: personalizada o una por defecto
  String get displayImageUrl => hasImage ? imageUrl! : _getDefaultMovieImage();

  /// Imagen por defecto basada en el género
  String _getDefaultMovieImage() {
    switch (genre.toLowerCase()) {
      case 'acción':
      case 'action':
        return 'https://media.gq.com.mx/photos/5be9df325c1fcbd1504c3507/4:3/w_1600,h_1200,c_limit/john_whick_327.jpg';
      case 'comedia':
      case 'comedy':
        return 'https://images.unsplash.com/photo-1594736797933-d0ceaa3ba44b?w=300&h=400&fit=crop';
      case 'drama':
        return 'https://images.unsplash.com/photo-1518676590629-3dcbd9c5a5c9?w=300&h=400&fit=crop';
      case 'terror':
      case 'horror':
        return 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300&h=400&fit=crop';
      case 'romance':
        return 'https://images.unsplash.com/photo-1516280440614-37939bbacd81?w=300&h=400&fit=crop';
      case 'ciencia ficción':
      case 'sci-fi':
        return 'https://images.unsplash.com/photo-1446776877081-d282a0f896e2?w=300&h=400&fit=crop';
      case 'fantasía':
      case 'fantasy':
        return 'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=300&h=400&fit=crop';
      default:
        return 'https://images.unsplash.com/photo-1489599808821-8d3b3c7d1ec4?w=300&h=400&fit=crop';
    }
  }

  /// Crear copia de Movie con modificaciones opcionales
  Movie copyWith({
    String? id,
    String? title,
    String? director,
    String? genre,
    int? year,
    String? imageUrl,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      director: director ?? this.director,
      genre: genre ?? this.genre,
      year: year ?? this.year,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() {
    return 'Movie(id: $id, title: $title, director: $director, genre: $genre, year: $year, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Movie &&
        other.id == id &&
        other.title == title &&
        other.director == director &&
        other.genre == genre &&
        other.year == year &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        director.hashCode ^
        genre.hashCode ^
        year.hashCode ^
        imageUrl.hashCode;
  }
}
