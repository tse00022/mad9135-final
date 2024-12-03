import 'package:final_project/utils/http_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_project/utils/app_state.dart';
import 'package:http/http.dart' as http;

class ShareCodeScreen extends StatefulWidget {
  const ShareCodeScreen({super.key});

  @override
  State<ShareCodeScreen> createState() => _ShareCodeScreenState();
}

class _ShareCodeScreenState extends State<ShareCodeScreen> {
  String code = 'Unset';

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Night',
            style: TextStyle(color: Colors.white, fontSize: 24)),
        backgroundColor: Colors.blue,
      ),
      body: Column(children: [Text('Code: $code')]),
    );
  }

  void _startSession() async {
    String? deviceId = Provider.of<AppState>(context, listen: false).deviceId;

    if (kDebugMode) {
      print('Device ID: $deviceId');
    }

    final response = await HttpHelper.startSession(deviceId);
    setState(() {
      code = response['data']['code'];
    });
  }
}
