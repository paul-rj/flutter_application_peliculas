import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../../services/movie_service.dart';

class MovieFormView extends StatefulWidget {
  const MovieFormView({super.key});

  @override
  State<MovieFormView> createState() => _MovieFormViewState();
}

class _MovieFormViewState extends State<MovieFormView> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _director = TextEditingController();
  final _genre = TextEditingController();
  final _year = TextEditingController();

  Movie? editingMovie;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Movie) {
      editingMovie = args;
      _title.text = args.title;
      _director.text = args.director;
      _genre.text = args.genre;
      _year.text = args.year.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = MovieService();
    final isEditing = editingMovie != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar Película' : 'Nueva Película')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _title, decoration: const InputDecoration(labelText: 'Título')),
              const SizedBox(height: 10),
              TextFormField(controller: _director, decoration: const InputDecoration(labelText: 'Director')),
              const SizedBox(height: 10),
              TextFormField(controller: _genre, decoration: const InputDecoration(labelText: 'Género')),
              const SizedBox(height: 10),
              TextFormField(controller: _year, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Año')),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final movie = Movie(
                    id: editingMovie?.id ?? '',
                    title: _title.text,
                    director: _director.text,
                    genre: _genre.text,
                    year: int.tryParse(_year.text) ?? 0,
                  );
                  if (isEditing) {
                    await service.updateMovie(movie);
                  } else {
                    await service.addMovie(movie);
                  }
                  if (mounted) Navigator.pop(context);
                },
                child: Text(isEditing ? 'Actualizar' : 'Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
