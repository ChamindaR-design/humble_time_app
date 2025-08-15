import 'package:humble_time_app/features/reflection/models/reflection_entry.dart';

class ReflectionStore {
  ReflectionStore._();
  static final instance = ReflectionStore._();

  final List<ReflectionEntry> _entries = [];

  List<ReflectionEntry> get all => List.unmodifiable(_entries);

  void save(ReflectionEntry entry) {
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry;
    } else {
      _entries.add(entry);
    }
  }

  ReflectionEntry? getById(String id) {
    try {
      return _entries.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  void delete(String id) {
    _entries.removeWhere((e) => e.id == id);
  }

  void clear() {
    _entries.clear();
  }
}
