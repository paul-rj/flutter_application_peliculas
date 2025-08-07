import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';

class MovieService {
  final CollectionReference _movieCollection =
      FirebaseFirestore.instance.collection('movies');

  Stream<List<Movie>> getMovies() {
    return _movieCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Movie.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> addMovie(Movie movie) async {
    await _movieCollection.add(movie.toMap());
  }

  Future<void> updateMovie(Movie movie) async {
    await _movieCollection.doc(movie.id).update(movie.toMap());
  }

  Future<void> deleteMovie(String id) async {
    await _movieCollection.doc(id).delete();
  }
}
