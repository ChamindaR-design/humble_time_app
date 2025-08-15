import 'package:flutter/foundation.dart';
import 'package:humble_time_app/models/actuals_entry.dart';
import 'package:humble_time_app/features/actuals/services/actuals_hive_service.dart';

class ActualsStore extends ChangeNotifier {
  static final ActualsStore instance = ActualsStore._internal();
  ActualsStore._internal();

  List<ActualsEntry> _entries = [];

  List<ActualsEntry> get entries => List.unmodifiable(_entries);

  Future<void> init() async {
    await ActualsHiveService.init();
    _entries = ActualsHiveService.getAllEntries();
    notifyListeners();
  }

  Future<void> addEntry(String text) async {
    if (text.trim().isEmpty) return;
    final entry = ActualsEntry(text: text.trim());
    await ActualsHiveService.saveEntry(entry);
    _entries = ActualsHiveService.getAllEntries();
    notifyListeners();
  }

  Future<void> clear() async {
    await ActualsHiveService.clearAll();
    _entries = [];
    notifyListeners();
  }
}
