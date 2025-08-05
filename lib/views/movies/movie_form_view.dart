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
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header con botón de regreso
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2))],
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF2d3748)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    isEditing ? 'Editar Película' : 'Nueva Película',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2d3748)),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Icono principal
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Icon(isEditing ? Icons.edit_outlined : Icons.add_outlined, size: 40, color: Colors.white),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Formulario
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(_title, 'Título', Icons.movie_outlined),
                      const SizedBox(height: 16),
                      _buildTextField(_director, 'Director', Icons.person_outlined),
                      const SizedBox(height: 16),
                      _buildTextField(_genre, 'Género', Icons.category_outlined),
                      const SizedBox(height: 16),
                      _buildTextField(_year, 'Año', Icons.calendar_today_outlined, TextInputType.number),
                      const SizedBox(height: 32),
                      _buildGradientButton(isEditing ? 'Actualizar' : 'Guardar', () async {
                        if (_formKey.currentState!.validate()) {
                          final movie = Movie(
                            id: editingMovie?.id ?? '',
                            title: _title.text,
                            director: _director.text,
                            genre: _genre.text,
                            year: int.tryParse(_year.text) ?? 0,
                          );
                          try {
                            if (isEditing) {
                              await service.updateMovie(movie);
                            } else {
                              await service.addMovie(movie);
                            }
                            if (mounted) Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                          }
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, [TextInputType? keyboardType]) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es requerido';
          }
          if (label == 'Año' && int.tryParse(value) == null) {
            return 'Ingresa un año válido';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildGradientButton(String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: const Color(0xFF667eea).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}