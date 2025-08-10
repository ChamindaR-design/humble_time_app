enum DateTimeFormat {
  onlyTime,
  onlyTimeAndSinceStart,
  none,
}

String dateTimeFormat(DateTime time, {DateTimeFormat format = DateTimeFormat.onlyTime}) {
  switch (format) {
    case DateTimeFormat.onlyTime:
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    case DateTimeFormat.onlyTimeAndSinceStart:
      final now = DateTime.now();
      final duration = now.difference(time);
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      final since = hours > 0
          ? '${hours}h ${minutes}m ago'
          : '${minutes}m ago';
      final formattedTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      return '$formattedTime • $since';
    case DateTimeFormat.none:
      return time.toIso8601String();
  }
}
