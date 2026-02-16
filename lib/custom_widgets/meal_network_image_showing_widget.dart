import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/endpoints.dart';

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

  String get _resolvedUrl {
    if (imageUrl == null || imageUrl!.isEmpty) {
      LoggerUtils.error('MealNetworkImage → imageUrl is null or empty');
      return '';
    }

    if (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://')) {
      LoggerUtils.debug('MealNetworkImage → Already full URL: $imageUrl');
      return imageUrl!;
    }

    // Ensure no double slash
    // ✅ Replace with this
final base = imageBaseUrl.endsWith('/')
    ? imageBaseUrl.substring(0, imageBaseUrl.length - 1)
    : imageBaseUrl;
    final path = imageUrl!.startsWith('/') ? imageUrl! : '/$imageUrl';
    final resolved = '$base$path';

    LoggerUtils.debug('MealNetworkImage → Resolved URL: $resolved');
    return resolved;
  }

  bool get _isValidResolvedUrl => _resolvedUrl.startsWith('http');

  // 🔑 Add your auth token here if needed
  Map<String, String> get _headers => {
    'Accept': 'image/*',
    // Uncomment and add token if your server requires auth:
    // 'Authorization': 'Bearer ${YourAuthController.token}',
  };

  @override
  Widget build(BuildContext context) {
    LoggerUtils.debug('MealNetworkImage → Building with URL: $_resolvedUrl');
    LoggerUtils.debug('MealNetworkImage → Is valid: $_isValidResolvedUrl');

    if (!_isValidResolvedUrl) {
      LoggerUtils.error('MealNetworkImage → Invalid URL, showing error widget');
      return _buildContainer(_errorWidget());
    }

    return _buildContainer(
      CachedNetworkImage(
        imageUrl: _resolvedUrl,
        httpHeaders: _headers, // ✅ Pass headers
        fit: fit,
        width: width,
        height: height,
        placeholder: (_, __) {
          LoggerUtils.debug('MealNetworkImage → ⏳ Loading...');
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        },
        errorWidget: (_, error, stackTrace) {
          // 🔥 This will now show the actual error (403, 404, etc.)
          LoggerUtils.error(
            'MealNetworkImage → ❌ FAILED\n'
            '  URL: $_resolvedUrl\n'
            '  Error: $error\n'
            '  Stack: $stackTrace',
          );
          return _errorWidget(error: error.toString());
        },
      ),
    );
  }

  Widget _buildContainer(Widget child) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      child: SizedBox(width: width, height: height, child: child),
    );
  }

  Widget _errorWidget({String? error}) {
    return Container(
      color: Colors.grey.shade800,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image_not_supported, color: Colors.white54, size: 28),
          if (error != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                // Shows "403", "404", etc. on the widget in debug
                error.length > 20 ? '${error.substring(0, 20)}...' : error,
                style: const TextStyle(color: Colors.white38, fontSize: 9),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}




