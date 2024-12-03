import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter/material.dart';
import 'package:final_project/screens/share_code_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:final_project/utils/app_state.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    super.key,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _initializeDeviceId();
  }

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

  void _initializeDeviceId() async {
    String deviceId = await _fetchDeviceId();
    Provider.of<AppState>(context, listen: false).setDeviceId(deviceId);
  }

  Future<String> _fetchDeviceId() async {
    String deviceId;

    try {
      if (Platform.isAndroid) {
        const androidIdPlugin = AndroidId();
        deviceId = await androidIdPlugin.getId() ?? "Unknown Android ID";
      } else if (Platform.isIOS) {
        final deviceInfoPlugin = DeviceInfoPlugin();
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? "Unknown iOS UUID";
      } else {
        deviceId = 'Unsupported platform';
      }
    } catch (e) {
      deviceId = "Error: $e";
    }
    print('Device ID: $deviceId');
    return deviceId;
  }
}
