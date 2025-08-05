import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../../services/movie_service.dart';

class MovieListView extends StatelessWidget {
  const MovieListView({super.key});

  @override
  Widget build(BuildContext context) {
    final movieService = MovieService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/movie-form');
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: StreamBuilder<List<Movie>>(
        stream: movieService.getMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final movies = snapshot.data ?? [];
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return ListTile(
                title: Text(movie.title),
                subtitle: Text('${movie.director} - ${movie.year}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await movieService.deleteMovie(movie.id);
                  },
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/movie-form',
                    arguments: movie,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
