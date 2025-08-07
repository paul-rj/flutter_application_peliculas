import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../../services/movie_service.dart';

class MovieCatalogView extends StatelessWidget {
  const MovieCatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    final movieService = MovieService();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        title: const Text('Catálogo de Películas', style: TextStyle(color: Color(0xFF2d3748))),
        iconTheme: const IconThemeData(color: Color(0xFF2d3748)),
        elevation: 0,
      ),
      body: StreamBuilder<List<Movie>>(
        stream: movieService.getMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF667eea)));
          }

          final movies = snapshot.data ?? [];

          // Agrupar películas por género
          final groupedByGenre = <String, List<Movie>>{};
          for (var movie in movies) {
            groupedByGenre.putIfAbsent(movie.genre, () => []).add(movie);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: groupedByGenre.entries.map((entry) {
              final genre = entry.key;
              final genreMovies = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(genre, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2d3748))),
                  const SizedBox(height: 8),
                  ...genreMovies.map((movie) => _buildCatalogCard(context, movie)).toList(),
                  const SizedBox(height: 24),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildCatalogCard(BuildContext context, Movie movie) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          const Icon(Icons.movie_outlined, color: Color(0xFF667eea), size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2d3748))),
                Text('Director: ${movie.director}', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Aquí podrías usar una lógica para guardar en favoritos
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Te gustó "${movie.title}"')),
              );
            },
            icon: const Icon(Icons.favorite_border, color: Color(0xFF764ba2)),
          ),
        ],
      ),
    );
  }
}

