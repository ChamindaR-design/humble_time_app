import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class ExportImportService {
  /// Exports journal entries to a timestamped JSON file
  static Future<File> exportEntriesToJson(List<Map<String, dynamic>> entries) async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file = File('${directory.path}/journal_export_$timestamp.json');
    final json = jsonEncode(entries);

    return file.writeAsString(json);
  }

  /// Exports reflections (already encoded as JSON string) to a timestamped file
  static Future<File> exportReflectionsToJson(String json) async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file = File('${directory.path}/reflections_export_$timestamp.json');

    return file.writeAsString(json);
  }

  /// Imports a JSON file and returns a list of maps
  static Future<List<Map<String, dynamic>>?> importEntriesFromJson() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      final data = jsonDecode(content);

      return (data as List)
          .cast<Map<String, dynamic>>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    return null;
  }
}
