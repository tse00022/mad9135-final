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
      throw Exception(response.body);
    }
  }

  static joinSession(String code, String? deviceId) async {
    final response = await http.get(
      Uri.parse(
          "$movieNightApiUrl/join-session?code=$code&device_id=$deviceId"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static voteMovie(String sessionId, String movieId, bool vote) async {
    final response = await http.get(
      Uri.parse(
          "$movieNightApiUrl/vote-movie?session_id=$sessionId&movie_id=$movieId&vote=$vote"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }
}
