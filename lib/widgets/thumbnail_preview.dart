import 'package:material_ui/material_ui.dart';

/// Pratinjau gambar dari [url] berukuran tetap [size] x [size].
///
/// Sebelum gambar pertama tampil, kotak berisi ikon gambar; selama data
/// diunduh, tampil indikator progres dari `loadingBuilder`. Jika gambar gagal
/// dimuat (URL bukan gambar, server menolak, atau diblokir CORS di web),
/// `errorBuilder` menampilkan ikon dan teks "Gambar tidak bisa dimuat". Isi
/// kotak diperkecil bila perlu, jadi tidak pernah overflow meskipun teks
/// diperbesar.
class ThumbnailPreview extends StatelessWidget {
  const ThumbnailPreview({super.key, required this.url, this.size = 120});

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      label: 'Pratinjau thumbnail',
      image: true,
      child: SizedBox.square(
        dimension: size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ColoredBox(
            color: colorScheme.surfaceContainerHighest,
            child: Image.network(
              url,
              fit: BoxFit.cover,
              // Di web, pakai elemen <img> jika gambar tidak bisa diambil
              // langsung karena aturan CORS server gambar.
              webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (frame != null || wasSynchronouslyLoaded) return child;
                return _PreviewMessage(icon: Icons.image_outlined, color: colorScheme.outline);
              },
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                final total = progress.expectedTotalBytes;
                return Center(
                  child: CircularProgressIndicator(
                    value: total == null ? null : progress.cumulativeBytesLoaded / total,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return _PreviewMessage(
                  icon: Icons.broken_image_outlined,
                  color: colorScheme.onSurfaceVariant,
                  text: 'Gambar tidak bisa dimuat',
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Ikon dan teks opsional di tengah kotak pratinjau, diperkecil agar muat.
class _PreviewMessage extends StatelessWidget {
  const _PreviewMessage({required this.icon, required this.color, this.text});

  final IconData icon;
  final Color color;
  final String? text;

  @override
  Widget build(BuildContext context) {
    final text = this.text;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          width: 104,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 36),
              if (text != null) ...[
                const SizedBox(height: 4),
                Text(text, textAlign: TextAlign.center, style: TextStyle(color: color)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
