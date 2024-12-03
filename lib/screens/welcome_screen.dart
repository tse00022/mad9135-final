import 'package:flutter/material.dart';
import 'package:final_project/screens/share_code_screen.dart';
import 'package:flutter/widgets.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    super.key,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Movie Night',
            style: TextStyle(color: Colors.white, fontSize: 24)),
        backgroundColor: Colors.blue,
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShareCodeScreen(),
                    ));
              },
              child: Text("Start Session"))
        ],
      )),
    );
  }
}
