import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class MealNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const MealNetworkImage({
    super.key,
    required this.imageUrl,
    this.width = 120,
    this.height = 120,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  bool get _isValidUrl {
    return imageUrl != null &&
        imageUrl!.isNotEmpty &&
        (imageUrl!.startsWith('http://') ||
         imageUrl!.startsWith('https://'));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      child: SizedBox(
        width: width,
        height: height,
        child: _isValidUrl
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: fit,
                placeholder: (_, __) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (_, __, ___) => _errorWidget(),
              )
            : _errorWidget(),
      ),
    );
  }

  Widget _errorWidget() {
    return Container(
      color: Colors.grey.shade800,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported,
        color: Colors.white54,
        size: 32,
      ),
    );
  }
}
