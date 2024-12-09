// ignore_for_file: use_build_context_synchronously

import 'package:final_project/screens/welcome_screen.dart';
import 'package:final_project/utils/http_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_project/utils/app_state.dart';

class MovieSelectionScreen extends StatefulWidget {
  const MovieSelectionScreen({super.key});

  @override
  State<MovieSelectionScreen> createState() => _MovieSelectionScreenState();
}

class _MovieSelectionScreenState extends State<MovieSelectionScreen> {
  List<Map<String, dynamic>> movies = [];
  int currentIndex = 0;
  int page = 1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getMovies(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Movie Choices',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(context.watch<AppState>().sessionId),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (movies.isEmpty)
            const Center(child: Text('No movies available'))
          else
            MovieCard(
              title: movies[currentIndex]['title'] ?? '',
              imageUrl:
                  'https://image.tmdb.org/t/p/w500${movies[currentIndex]['poster_path']}',
              rating: (movies[currentIndex]['vote_average'] ?? 0).toDouble(),
              releaseDate: movies[currentIndex]['release_date'] ?? '',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Usage'),
                      content:
                          const Text('Swipe left to dislike, right to like'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Understood'),
                        ),
                      ],
                    );
                  },
                );
              },
              onDismissed: (direction) {
                handleDismiss(direction, context);
              },
            ),
        ],
      ),
    );
  }

  void handleDismiss(DismissDirection direction, BuildContext context) async {
    // guard context the use with a 'mounted'
    if (!context.mounted) return;

    String action =
        direction == DismissDirection.endToStart ? "dislike" : "like";
    try {
      final response = await HttpHelper.voteMovie(
        Provider.of<AppState>(context, listen: false).sessionId,
        movies[currentIndex]['id'].toString(),
        action == "like",
      );

      //{data: {message: thanks for voting., movie_id: 912649, match: true, num_devices: 1, submitted_movie: 1182387}}

      bool match = response['data']['match'];
      if (match) {
        String movieId = response['data']['movie_id'].toString();
        // Find the index of the movie that matches the movieId
        int matchIndex = movies.indexWhere(
          (movie) => movie['id'].toString() == movieId,
        );

        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.movie,
                      size: 40,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${movies[matchIndex]['title']} Winner!",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${movies[matchIndex]['poster_path']}',
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${movies[matchIndex]['title']} is the matching movie!",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const WelcomeScreen()),
                          (Route<dynamic> route) =>
                              false, // This removes all previous routes
                        )
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }

      setState(() {
        currentIndex++;
      });

      if (currentIndex >= movies.length - 3) {
        page++;
        await getMovies(context);
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Cannot vote movie'),
              content: Text('$e'),
              actions: [
                TextButton(
                  onPressed: () => {Navigator.pop(context)},
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> getMovies(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await HttpHelper.getPopularMovies(page);
      setState(() {
        // If it's the first page, replace the list
        // If it's not the first page, append to the existing list
        if (page == 1) {
          movies = List<Map<String, dynamic>>.from(response['results']);
        } else {
          movies.addAll(List<Map<String, dynamic>>.from(response['results']));
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Cannot get movies'),
              content: Text('$e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}

class MovieCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double rating;
  final String releaseDate;
  final VoidCallback onTap;
  final Function(DismissDirection)? onDismissed; // Add this parameter

  const MovieCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.releaseDate,
    required this.onTap,
    this.onDismissed, // Add this parameter
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(title), // Using title as the key, assuming it's unique
      direction: DismissDirection.horizontal,
      onDismissed: onDismissed,
      // You can customize the background when sliding
      // Background for right to left swipe (showing when swiping from left)
      background: Container(
        color: Colors.green, // Green background for positive action
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Icon(
              Icons.thumb_up,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
      // Background for left to right swipe (showing when swiping from right)
      secondaryBackground: Container(
        color: Colors.red, // Red background for negative action
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.thumb_down,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const CircularProgressIndicator();
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Error loading image');
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          releaseDate,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            rating.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
