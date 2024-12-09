import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:final_project/utils/app_state.dart';
import 'package:final_project/utils/http_helper.dart';
import 'package:final_project/utils/json_file_helper.dart';
import 'package:final_project/screens/movie_selection_screen.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({super.key});

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  String code = '';
  final int codeLength = 4;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enter the code',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Card(
          elevation: 4,
          color: colorScheme.surface,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter the Code from your Friend',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                      letterSpacing: 8,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: codeLength,
                    onChanged: (value) {
                      setState(() {
                        code = value;
                      });
                    },
                    decoration: InputDecoration(
                      counterText: "${code.length}/$codeLength",
                      counterStyle: TextStyle(
                        color: colorScheme.onSurface,
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.outline),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.outline),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: code.length == codeLength
                      ? () {
                          _joinSession(context);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    "Begin",
                    style: (Theme.of(context).textTheme.titleLarge ??
                            const TextStyle())
                        .copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _joinSession(context) async {
    String? deviceId = Provider.of<AppState>(context, listen: false).deviceId;

    try {
      final response = await HttpHelper.joinSession(code, deviceId);
      String sessionId = response['data']['session_id'];

      Provider.of<AppState>(context, listen: false).setSessionId(sessionId);
      await JsonFileHelper.setSessionId(sessionId);

      //navigate to movie selection screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MovieSelectionScreen(),
        ),
      );
    } catch (e) {
      // Show alert dialog with error message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Cannot join session'),
            content: Text('$e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
