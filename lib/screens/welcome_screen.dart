import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:final_project/screens/enter_code_screen.dart';
import 'package:final_project/screens/movie_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:final_project/screens/share_code_screen.dart';
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
    _initializeDeviceId(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Movie Night',
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.primary,
      ),
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    //Button for starting a new session
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShareCodeScreen(),
                        ),
                      );
                    },
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
                      "Start Session",
                      style: (Theme.of(context).textTheme.titleLarge ??
                              const TextStyle())
                          .copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  )),
              SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: context.watch<AppState>().sessionId.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MovieSelectionScreen(),
                              ),
                            );
                          },
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
                      "Resume Session", // Also fixed the button text
                      style: (Theme.of(context).textTheme.titleLarge ??
                              const TextStyle())
                          .copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  )),
              SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EnterCodeScreen(),
                        ),
                      );
                    },
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
                      "Enter Code", // Also fixed the button text
                      style: (Theme.of(context).textTheme.titleLarge ??
                              const TextStyle())
                          .copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void _initializeDeviceId(context) async {
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
    return deviceId;
  }
}
