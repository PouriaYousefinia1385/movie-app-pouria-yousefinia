import 'dart:convert';
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

// Database connection
Future<MySqlConnection> connectToDatabase() async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: '1234',
    db: 'movie_db',
  ));
  return conn;
}

// Preload movies into the database
Future<void> preloadMovies() async {
  final movies = [
    {'title': 'Inception', 'genre': 'Action', 'rating': 8.8},
    {'title': 'The Notebook', 'genre': 'Romance', 'rating': 7.8},
    {'title': 'Get Out', 'genre': 'Horror', 'rating': 7.7},
    {'title': 'Superbad', 'genre': 'Comedy', 'rating': 7.6},
    {'title': 'The Dark Knight', 'genre': 'Action', 'rating': 9.0},
    {'title': 'Pride and Prejudice', 'genre': 'Romance', 'rating': 8.1},
    {'title': 'A Quiet Place', 'genre': 'Horror', 'rating': 7.5},
    {'title': '21 Jump Street', 'genre': 'Comedy', 'rating': 7.2},
    {'title': 'Mad Max: Fury Road', 'genre': 'Action', 'rating': 8.1},
    {'title': 'Titanic', 'genre': 'Romance', 'rating': 7.8},
    {'title': 'The Conjuring', 'genre': 'Horror', 'rating': 7.5},
    {'title': 'The Hangover', 'genre': 'Comedy', 'rating': 7.7},
    {'title': 'John Wick', 'genre': 'Action', 'rating': 7.4},
    {'title': 'La La Land', 'genre': 'Romance', 'rating': 8.0},
    {'title': 'Hereditary', 'genre': 'Horror', 'rating': 7.3},
    {'title': 'Step Brothers', 'genre': 'Comedy', 'rating': 6.9},
    {'title': 'Avengers: Endgame', 'genre': 'Action', 'rating': 8.4},
    {'title': 'The Fault in Our Stars', 'genre': 'Romance', 'rating': 7.7},
    {'title': 'The Shining', 'genre': 'Horror', 'rating': 8.4},
    {'title': 'Anchorman', 'genre': 'Comedy', 'rating': 7.2},
    {'title': 'Spider-Man: No Way Home', 'genre': 'Action', 'rating': 8.3},
    {'title': 'Crazy, Stupid, Love.', 'genre': 'Romance', 'rating': 7.4},
    {'title': 'Us', 'genre': 'Horror', 'rating': 6.9},
    {'title': 'Borat', 'genre': 'Comedy', 'rating': 7.3},
    {'title': 'Black Panther', 'genre': 'Action', 'rating': 7.3},
    {'title': 'Me Before You', 'genre': 'Romance', 'rating': 7.4},
    {'title': 'It Follows', 'genre': 'Horror', 'rating': 6.8},
    {'title': 'The Grand Budapest Hotel', 'genre': 'Comedy', 'rating': 8.1},
    {'title': 'Mission: Impossible - Fallout', 'genre': 'Action', 'rating': 7.8},
    {'title': 'The Vow', 'genre': 'Romance', 'rating': 6.8},
    {'title': 'Midsommar', 'genre': 'Horror', 'rating': 7.1},
    {'title': 'Clueless', 'genre': 'Comedy', 'rating': 6.8},
    {'title': 'The Bourne Identity', 'genre': 'Action', 'rating': 7.9},
    {'title': 'A Star is Born', 'genre': 'Romance', 'rating': 7.6},
    {'title': 'Sinister', 'genre': 'Horror', 'rating': 6.8},
    {'title': 'The Truman Show', 'genre': 'Comedy', 'rating': 8.1},
    {'title': 'Casino Royale', 'genre': 'Action', 'rating': 8.0},
    {'title': 'The Holiday', 'genre': 'Romance', 'rating': 6.9},
    {'title': 'The Ring', 'genre': 'Horror', 'rating': 7.1},
    {'title': 'Napoleon Dynamite', 'genre': 'Comedy', 'rating': 6.9},
    {'title': 'The Avengers', 'genre': 'Action', 'rating': 8.0},
    {'title': 'Romeo + Juliet', 'genre': 'Romance', 'rating': 6.7},
    {'title': 'The Cabin in the Woods', 'genre': 'Horror', 'rating': 7.0},
    {'title': 'Game Night', 'genre': 'Comedy', 'rating': 7.0},
    {'title': 'Top Gun: Maverick', 'genre': 'Action', 'rating': 8.3},
    {'title': 'Before Sunrise', 'genre': 'Romance', 'rating': 8.1},
    {'title': 'The Others', 'genre': 'Horror', 'rating': 7.6},

  ];

  var conn = await connectToDatabase();
  for (var movie in movies) {
    await conn.query(
      'INSERT IGNORE INTO movies (title, genre, rating) VALUES (?, ?, ?)',
      [movie['title'], movie['genre'], movie['rating']],
    );
  }
  await conn.close();
}

// Fetch movies
Future<List<Map<String, dynamic>>> getMovies() async {
  var conn = await connectToDatabase();
  var results = await conn.query('SELECT id,'title', genre, rating FROM movies');

  List<Map<String, dynamic>> movies = [];
  for (var row in results) {
    movies.add({
      'id': row[0],
      'title': row[1],
      'genre': row[2],
      'rating': row[3],
    });
  }
  await conn.close();
  return movies;
}

// Routes
Router setupRouter() {
  final router = Router();

  // Fetch movies
  router.get('/movies', (Request request) async {
    try {
      final movies = await getMovies();
      return Response.ok(json.encode(movies), headers: {
        'Content-Type': 'application/json',
      });
    } catch (e) {
      return Response.internalServerError(body: 'Error: $e');
    }
  });

  // Add a movie
  router.post('/movies', (Request request) async {
    try {
      var payload = await request.readAsString();
      var data = json.decode(payload);
      var'title' = data['title'];
      var genre = data['genre'];
      var rating = data['rating'];

      var conn = await connectToDatabase();
      await conn.query(
        'INSERT INTO movies (title, genre, rating) VALUES (?, ?, ?)',
        [title, genre, rating],
      );
      await conn.close();

      return Response.ok('Movie added successfully');
    } catch (e) {
      return Response.internalServerError(body: 'Error: $e');
    }
  });

  return router;
}

// Main server
void main() async {
  await preloadMovies();
  final router = setupRouter();
  var server = await io.serve(router, 'localhost', 8080);
  print('Server listening on port ${server.port}');
}
