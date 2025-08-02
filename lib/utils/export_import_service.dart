import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class ExportImportService {
  static Future<File> exportEntriesToJson(List<Map<String, dynamic>> entries) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/journal_export.json');
    final json = jsonEncode(entries);

    return file.writeAsString(json);
  }

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
