import 'package:flutter/material.dart';

/// Header profil di atas kartu identitas: avatar berisi inisial, sapaan, dan
/// keterangan singkat.
///
/// Avatar dibungkus [ExcludeSemantics] karena hanya hiasan; nama lengkap
/// sudah dibacakan pembaca layar dari InfoCard.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.greeting,
    required this.subtitle,
  });

  final String name;
  final String greeting;
  final String subtitle;

  /// Inisial dari huruf pertama dua kata pertama [fullName] dalam huruf
  /// kapital: `Muhammad Rayyan Basalamah` menjadi `MR`.
  static String initialsOf(String fullName) {
    final words = fullName.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty);
    return words.take(2).map((word) => word[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      children: [
        ExcludeSemantics(
          child: CircleAvatar(
            radius: 28,
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            child: Text(
              initialsOf(name),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}