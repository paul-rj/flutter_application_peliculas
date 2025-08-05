import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';

class MovieService {
  final _collection = FirebaseFirestore.instance.collection('movies');

  Stream<List<Movie>> getMovies() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Movie.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> addMovie(Movie movie) async {
    await _collection.add(movie.toMap());
  }

  Future<void> updateMovie(Movie movie) async {
    await _collection.doc(movie.id).update(movie.toMap());
  }

  Future<void> deleteMovie(String id) async {
    await _collection.doc(id).delete();
  }

  Future<Movie?> getMovieById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return Movie.fromMap(doc.data()!, doc.id);
  }
}
