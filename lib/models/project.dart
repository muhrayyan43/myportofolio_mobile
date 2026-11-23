import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

/// Satu proyek portofolio, sesuai `ProjectSerializer` di situs Django.
@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    required this.title,
    required this.description,
    required this.techStack,
    required this.year,
    this.url,
    this.id,
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
  });

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);

  @JsonKey(includeToJson: false)
  final int? id;

  final String title;
  final String description;
  final String techStack;
  final int year;

  /// Tautan proyek, `null` jika tidak diisi (`URLField(null=True)` di Django).
  final String? url;

  /// Jumlah star. Field ini dan dua field berikutnya dihitung server
  @JsonKey(includeToJson: false)
  final int starCount;

  /// Apakah pengguna yang sedang login sudah memberi star.
  @JsonKey(includeToJson: false)
  final bool isStarred;

  /// Username pemberi star, dipisahkan koma.
  @JsonKey(includeToJson: false)
  final String starredByNames;

  /// Body JSON untuk POST: hanya field yang boleh diisi klien.
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
