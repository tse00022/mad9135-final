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

  // Make a GET request to the TMDB database api
  // curl --request GET \
  //    --url 'https://api.themoviedb.org/3/movie/popular?language=en-US&page=1' \
  //    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiYTRlYzllN2VjMTNlOTEyNjBiYWFiMjBjOGQ3MDA2YSIsInN1YiI6IjY1NTIzYzU4OTY1M2Y2MTNmNTg4ZDQxMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.3IyzfFjpEjGZp_mB4xO7bB56bDaxSGn4orHFN9Acgz0' \
  //    --header 'accept: application/json'
  static getPopularMovies(int page) async {
    final response = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/movie/popular?language=en-US&page=$page"),
      headers: {
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiYTRlYzllN2VjMTNlOTEyNjBiYWFiMjBjOGQ3MDA2YSIsInN1YiI6IjY1NTIzYzU4OTY1M2Y2MTNmNTg4ZDQxMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.3IyzfFjpEjGZp_mB4xO7bB56bDaxSGn4orHFN9Acgz0",
        "accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }
}
