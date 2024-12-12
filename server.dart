import 'dart:convert';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

// Initialize SQLite
Future<Database> initializeDatabase() async {
  sqfliteFfiInit();
  final databaseFactory = databaseFactoryFfi;
  final db = await databaseFactory.openDatabase('movies.db');

  await db.execute('''
    CREATE TABLE IF NOT EXISTS movies (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      genre TEXT,
      rating REAL,
      description TEXT,
      image TEXT
    )
  ''');

  return db;
}

// Fetch movies from the database
Future<List<Map<String, dynamic>>> getMovies(Database db) async {
  return await db.query('movies');
}

// Insert a new movie into the database
Future<void> addMovie(Database db, Map<String, dynamic> movie) async {
  await db.insert('movies', movie);
}

// Set up CORS
Response addCorsHeaders(Request request, Response response) {
  return response.change(
    headers: {
      HttpHeaders.accessControlAllowOriginHeader: '*',
      HttpHeaders.accessControlAllowMethodsHeader: 'GET, POST, OPTIONS',
      HttpHeaders.accessControlAllowHeadersHeader: 'Content-Type',
    },
  );
}

void main() async {
  final db = await initializeDatabase();
  final router = Router();

  router.options('/movies', (Request request) async {
    return addCorsHeaders(request, Response.ok(''));
  });

  router.get('/movies', (Request request) async {
    try {
      final movies = await getMovies(db);
      return addCorsHeaders(request, Response.ok(json.encode(movies), headers: {'Content-Type': 'application/json'}));
    } catch (e) {
      return addCorsHeaders(request, Response.internalServerError(body: 'Error fetching movies: $e'));
    }
  });

router.post('/movies', (Request request) async {
  try {
    var payload = await request.readAsString();
    var data = json.decode(payload);
    var title = data['title'];
    var genre = data['genre'];
    var rating = data['rating'];
    var description = data['description'];

    var conn = await connectToDatabase();
    await conn.query(
      'INSERT INTO movies (title, genre, rating, description) VALUES (?, ?, ?, ?)',
      [title, genre, rating, description],
    );
    await conn.close();

    return Response.ok('Movie added successfully');
  } catch (e) {
    return Response.internalServerError(body: 'Error: $e');
  }
});

  final server = await io.serve(router, 'localhost', 8080);
  print('Server listening on port ${server.port}');
}
