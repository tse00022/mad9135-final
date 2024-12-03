import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_project/utils/app_state.dart';

class ShareCodeScreen extends StatefulWidget {
  const ShareCodeScreen({super.key});

  @override
  State<ShareCodeScreen> createState() => _ShareCodeScreenState();
}

class _ShareCodeScreenState extends State<ShareCodeScreen> {
  @override
  void initState() {
    super.initState();
    _startSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text('Share Code'),
    ));
  }

  void _startSession() {
    print("checkpoint 1 ");
    String? deviceId = Provider.of<AppState>(context, listen: false).deviceId;
    print("deviceId from share screen $deviceId");
  }
}
