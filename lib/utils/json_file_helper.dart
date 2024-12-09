import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// A helper class to read and write data to a JSON file (data.json)
// The datastructure is
// {
//     "session_id": "",
//     "liked_movies": ["details about that movie1", "details about that movie2"]
// }
class JsonFileHelper {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.json');
  }

  static Future<void> writeData(Map<String, dynamic> data) async {
    final file = await _localFile;
    final jsonData = json.encode(data);
    await file.writeAsString(jsonData);
  }

  static Future<Map<String, dynamic>> readData() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return json.decode(contents);
    } catch (e) {
      return {};
    }
  }

  static Future<void> clearData() async {
    final file = await _localFile;
    await file.writeAsString('');
  }

  static Future<void> setSessionId(String sessionId) async {
    final data = await readData();
    data['session_id'] = sessionId;
    await writeData(data);
  }

  static Future<String> getSessionId() async {
    final data = await readData();
    return data['session_id'] ?? '';
  }
}
