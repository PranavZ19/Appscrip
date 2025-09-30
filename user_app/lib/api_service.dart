import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user.dart';

class ApiService {
  static const String url = 'http://jsonplaceholder.typicode.com/users';


  Future<List<User>> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"User-Agent": "Mozilla/5.0 (compatible; Flutter app)"}, // Added to avoid 403
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception caught in fetchUsers: $e');
      throw Exception('Failed to load users: $e');
    }
  }
}
