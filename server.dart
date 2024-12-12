import 'dart:convert';
import 'dart:io';
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

// اتصال به پایگاه داده MySQL
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

// دریافت لیست فیلم‌ها از دیتابیس
Future<List<Map<String, dynamic>>> getMovies() async {
  var conn = await connectToDatabase();
  var results = await conn.query('SELECT id, title, genre, rating FROM movies');

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

// تنظیمات CORS به صورت دستی
Response addCorsHeaders(Request request, Response response) {
  return response.change(
    headers: {
      HttpHeaders.accessControlAllowOriginHeader: '*', // اجازه دسترسی از همه دامنه‌ها
      HttpHeaders.accessControlAllowMethodsHeader: 'GET, POST, DELETE, OPTIONS',
      HttpHeaders.accessControlAllowHeadersHeader: 'Content-Type',
    },
  );
}

// راه‌اندازی سرور
void main() async {
  final router = Router();

  // روت برای پاسخ به درخواست‌های OPTIONS (برای CORS Pre-flight)
  router.options('/movies', (Request request) async {
    return addCorsHeaders(request, Response.ok(''));
  });

  // روت برای دریافت لیست فیلم‌ها
  router.get('/movies', (Request request) async {
    try {
      List<Map<String, dynamic>> movies = await getMovies();
      Response response = Response.ok(
        json.encode(movies),
        headers: {'Content-Type': 'application/json'},
      );
      return addCorsHeaders(request, response);
    } catch (e) {
      Response response = Response.internalServerError(body: 'Error: $e');
      return addCorsHeaders(request, response);
    }
  });

  // روت برای افزودن فیلم جدید
  router.post('/movies', (Request request) async {
    try {
      var payload = await request.readAsString();
      var data = json.decode(payload);
      var title = data['title'];
      var genre = data['genre'];
      var rating = data['rating'];

      var conn = await connectToDatabase();
      await conn.query(
        'INSERT INTO movies (title, genre, rating) VALUES (?, ?, ?)',
        [title, genre, rating],
      );
      await conn.close();

      Response response = Response.ok('فیلم با موفقیت اضافه شد');
      return addCorsHeaders(request, response);
    } catch (e) {
      Response response = Response.internalServerError(body: 'Error: $e');
      return addCorsHeaders(request, response);
    }
  });

  // روت برای حذف فیلم
  router.delete('/movies/<id>', (Request request, String id) async {
    try {
      var conn = await connectToDatabase();
      var result = await conn.query('DELETE FROM movies WHERE id = ?', [int.parse(id)]);
      await conn.close();

      Response response;
      if (result.affectedRows == 0) {
        response = Response.notFound('فیلمی با این ID پیدا نشد');
      } else {
        response = Response.ok('فیلم با موفقیت حذف شد');
      }

      return addCorsHeaders(request, response);
    } catch (e) {
      Response response = Response.internalServerError(body: 'Error: $e');
      return addCorsHeaders(request, response);
    }
  });

  // راه‌اندازی سرور روی پورت 8080
  var server = await io.serve(router, 'localhost', 8080);
  print('Server listening on port ${server.port}');
}
