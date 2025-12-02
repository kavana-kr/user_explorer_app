import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user_explorer_app/models/user_model.dart';

class ApiService {
  // base API endpoint for fetching user data
  static const String baseUrl = "https://jsonplaceholder.typicode.com/users";

  // fetches all users from the API and converts them into UserModel list
  static Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    // successful response
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body); // decode JSON list
      return data.map((e) => UserModel.fromJson(e)).toList(); // convert to UserModel list
    } else {
      // throw error if API call fails
      throw Exception('Failed to load users');
    }
  }
}
