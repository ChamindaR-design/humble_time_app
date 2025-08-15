import 'package:hive/hive.dart';

part 'actuals_entry.g.dart';

@HiveType(typeId: 7) // Use a unique typeId not used elsewhere
class ActualsEntry extends HiveObject {
  @HiveField(0)
  String text;

  @HiveField(1)
  DateTime createdAt;

  ActualsEntry({
    required this.text,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
