import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpHelper {
  static String movieNightApiUrl = "https://movie-night-api.onrender.com";

  static startSession(String? deviceId) async {
    final response = await http.get(
      Uri.parse("$movieNightApiUrl/start-session?device_id=$deviceId"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to start session');
    }
  }
}
