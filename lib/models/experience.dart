import 'package:json_annotation/json_annotation.dart';
import 'package:myportofolio_mobile/utils/json_converters.dart';

part 'experience.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Experience {
  const Experience({
    required this.title,
    required this.description,
    required this.category,
    required this.startedAt,
    this.endedAt,
    this.thumbnail,
    this.id,
    this.categoryDisplay = '',
    this.isOngoing = false,
    this.createdAt,
    this.updatedAt,
    this.starCount = 0,
    this.isStarred = false,
  });

  factory Experience.fromJson(Map<String, dynamic> json) => _$ExperienceFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;

  final String title;
  final String description;
  final String category;
  final String? thumbnail;

  @DateOnlyConverter()
  final DateTime startedAt;

  @DateOnlyConverter()
  final DateTime? endedAt;

  @JsonKey(includeToJson: false)
  final String categoryDisplay;

  @JsonKey(includeToJson: false)
  final bool isOngoing;

  @JsonKey(includeToJson: false)
  final DateTime? createdAt;

  @JsonKey(includeToJson: false)
  final DateTime? updatedAt;

  @JsonKey(includeToJson: false)
  final int starCount;

  @JsonKey(includeToJson: false)
  final bool isStarred;

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}
