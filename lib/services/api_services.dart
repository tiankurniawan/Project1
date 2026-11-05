import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  static const baseUrl =
      'https://jsonplaceholder.typicode.com';

  Future<List<Post>> fetchPosts() async {
    final res = await http.get(Uri.parse('$baseUrl/posts'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Post.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat (${res.statusCode})');
  }
  Future<Post> createPost(String title, String body) async {
  final res = await http.post(
    Uri.parse('$baseUrl/posts'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(
      {'title': title, 'body': body, 'userId': 1}),
  );
  if (res.statusCode == 201) {
    return Post.fromJson(jsonDecode(res.body));
  }
  throw Exception('Gagal mengirim (${res.statusCode})');
}
}
