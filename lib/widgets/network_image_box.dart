import 'package:flutter/material.dart';

/// Network image with loading spinner and error fallback.
class NetworkImageBox extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  const NetworkImageBox({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final placeholderColor = Colors.grey.shade300;

    if (url.isEmpty) {
      return _placeholder(placeholderColor, Icons.restaurant);
    }

    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          width: width,
          height: height,
          color: placeholderColor,
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) =>
          _placeholder(placeholderColor, Icons.broken_image_outlined),
    );
  }

  Widget _placeholder(Color color, IconData icon) {
    return Container(
      width: width,
      height: height,
      color: color,
      child: Icon(icon, color: Colors.grey),
    );
  }
}
