import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  static Future<bool> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: json.encode({
        'username': username,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      User.userId = data['userId'];
      User.username = data['username'];
      return true;
    } else {
      print('Failed to log in');
      return false;
    }
  }

  static Future<List<dynamic>> fetchRestaurants() async {
    final response = await http.get(Uri.parse('$baseUrl/restaurants'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to load restaurants');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> fetchRestaurantDetails(int restaurantId) async {
    final response = await http.get(Uri.parse('$baseUrl/restaurants/$restaurantId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to load restaurant details');
      return null;
    }
  }

  static Future<bool> submitReview(int restaurantId, int rating, String comment) async {
    if (User.userId == null) {
      print('User not logged in');
      return false;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/reviews'),
      body: json.encode({
        'userId': User.userId,
        'restaurantId': restaurantId,
        'rating': rating,
        'comment': comment,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Failed to submit review');
      return false;
    }
  }
}
