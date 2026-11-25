import 'package:json_annotation/json_annotation.dart';

/// DRF `DateField` hanya menerima "YYYY-MM-DD", bukan hasil `toIso8601String()`.
class DateOnlyConverter implements JsonConverter<DateTime, String> {
  const DateOnlyConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
