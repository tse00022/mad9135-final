import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_project/utils/app_state.dart';

class MovieSelectionScreen extends StatefulWidget {
  const MovieSelectionScreen({super.key});

  @override
  State<MovieSelectionScreen> createState() => _MovieSelectionScreenState();
}

class _MovieSelectionScreenState extends State<MovieSelectionScreen> {
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
          MovieCard(
            title: 'Trolls Band Together',
            imageUrl:
                'https://picsum.photos/250?image=9', // Add your image path
            rating: 7.2,
            releaseDate: '2023-10-12',
            onTap: () {
              // Handle movie selection
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Usage'),
                    content: const Text('Swipe left to dislike, right to like'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Understood'),
                      ),
                    ],
                  );
                },
              );
            },
            onDismissed: (direction) {
              String swipeDirection = direction == DismissDirection.endToStart
                  ? "right to left"
                  : "left to right";
            },
          ),
          // Add more MovieCard widgets as needed
        ],
      ),
    );
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
