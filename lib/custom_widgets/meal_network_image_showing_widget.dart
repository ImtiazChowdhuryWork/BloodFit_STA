import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/endpoints.dart';

class CustomNetworkImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool isClipOval;
  final String? mealType; // Added mealType for better placeholder

  const CustomNetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.width = 120,
    this.height = 120,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.isClipOval = true,
    this.mealType,
  });

  /// Check if the image is base64 encoded
  bool get _isBase64Image {
    if (imageUrl == null || imageUrl!.isEmpty) return false;
    if (imageUrl!.startsWith('data:image')) return true;
    // Base64 typically starts with these patterns
    if (imageUrl!.startsWith('iVBORw0KGgo')) return true; // PNG
    if (imageUrl!.startsWith('/9j/')) return true; // JPEG
    if (imageUrl!.startsWith('R0lGOD')) return true; // GIF
    return false;
  }

  String get _resolvedUrl {
    if (imageUrl == null || imageUrl!.isEmpty) {
      LoggerUtils.error('MealNetworkImage → imageUrl is null or empty');
      return '';
    }

    // If it's base64, don't try to resolve as URL
    if (_isBase64Image) {
      LoggerUtils.debug('MealNetworkImage → Base64 image detected');
      return '';
    }

    if (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://')) {
      LoggerUtils.debug('MealNetworkImage → Already full URL: $imageUrl');
      return imageUrl!;
    }

    // Ensure no double slash
    final base = imageBaseUrl.endsWith('/')
        ? imageBaseUrl.substring(0, imageBaseUrl.length - 1)
        : imageBaseUrl;
    final path = imageUrl!.startsWith('/') ? imageUrl! : '/$imageUrl';
    final resolved = '$base$path';

    LoggerUtils.debug('MealNetworkImage → Resolved URL: $resolved');
    return resolved;
  }

  bool get _isValidResolvedUrl => _resolvedUrl.startsWith('http');

  Map<String, String> get _headers => {
    'Accept': 'image/*',
  };

  /// Get color based on meal type
  Color _getMealTypeColor() {
    switch (mealType?.toLowerCase()) {
      case 'breakfast':
        return const Color(0xFFFFA726); // Orange
      case 'lunch':
        return const Color(0xFF66BB6A); // Green
      case 'dinner':
        return const Color(0xFF42A5F5); // Blue
      default:
        return const Color(0xFFAB47BC); // Purple
    }
  }

  /// Get icon based on meal type
  IconData _getMealTypeIcon() {
    switch (mealType?.toLowerCase()) {
      case 'breakfast':
        return Icons.breakfast_dining;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      default:
        return Icons.restaurant;
    }
  }

  /// Get base64 data without the prefix
  String? get _base64Data {
    if (!_isBase64Image || imageUrl == null) return null;
    
    // Strip the data URI prefix if present (e.g., "data:image/png;base64,")
    if (imageUrl!.contains(',')) {
      return imageUrl!.split(',').last;
    }
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    LoggerUtils.debug('MealNetworkImage → Building with URL: $_resolvedUrl');
    LoggerUtils.debug('MealNetworkImage → Is base64: $_isBase64Image');
    LoggerUtils.debug('MealNetworkImage → Is valid: $_isValidResolvedUrl');

    // Handle base64 images
    if (_isBase64Image) {
      try {
        final base64Data = _base64Data;
        if (base64Data == null) {
          LoggerUtils.error('MealNetworkImage → Base64 data is null');
          return _buildContainer(_placeholderWidget());
        }

        return _buildContainer(
          isClipOval
              ? ClipOval(
                  child: Image.memory(
                    base64Decode(base64Data),
                    width: width,
                    height: height,
                    fit: fit,
                    errorBuilder: (_, error, __) {
                      LoggerUtils.error(
                        'MealNetworkImage → ❌ Failed to decode base64: $error',
                      );
                      return _placeholderWidget();
                    },
                  ),
                )
              : Image.memory(
                  base64Decode(base64Data),
                  width: width,
                  height: height,
                  fit: fit,
                  errorBuilder: (_, error, __) {
                    LoggerUtils.error(
                      'MealNetworkImage → ❌ Failed to decode base64: $error',
                    );
                    return _placeholderWidget();
                  },
                ),
        );
      } catch (e) {
        LoggerUtils.error('MealNetworkImage → ❌ Base64 decode error: $e');
        return _buildContainer(_placeholderWidget());
      }
    }

    // Handle invalid URLs
    if (!_isValidResolvedUrl) {
      LoggerUtils.error('MealNetworkImage → Invalid URL, showing placeholder');
      return _buildContainer(_placeholderWidget());
    }

    // Handle network images
    return _buildContainer(
      isClipOval
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: _resolvedUrl,
                httpHeaders: _headers,
                fit: fit,
                width: width,
                height: height,
                memCacheWidth: width.toInt(),
                memCacheHeight: height.toInt(),
                fadeInDuration: const Duration(milliseconds: 300),
                fadeOutDuration: const Duration(milliseconds: 300),
                placeholder: (_, __) => _placeholderWidget(),
                errorWidget: (_, error, stackTrace) {
                  LoggerUtils.error(
                    'MealNetworkImage → ❌ FAILED\n'
                    '  URL: $_resolvedUrl\n'
                    '  Error: $error',
                  );
                  return _placeholderWidget();
                },
              ),
            )
          : CachedNetworkImage(
              imageUrl: _resolvedUrl,
              httpHeaders: _headers,
              fit: fit,
              width: width,
              height: height,
              memCacheWidth: width.toInt(),
              memCacheHeight: height.toInt(),
              fadeInDuration: const Duration(milliseconds: 300),
              fadeOutDuration: const Duration(milliseconds: 300),
              placeholder: (_, __) => _placeholderWidget(),
              errorWidget: (_, error, stackTrace) {
                LoggerUtils.error(
                  'MealNetworkImage → ❌ FAILED\n'
                  '  URL: $_resolvedUrl\n'
                  '  Error: $error',
                );
                return _placeholderWidget();
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

  Widget _placeholderWidget() {
    final mealColor = _getMealTypeColor();
    final mealIcon = _getMealTypeIcon();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            mealColor.withOpacity(0.3),
            mealColor.withOpacity(0.1),
          ],
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            mealIcon,
            color: mealColor,
            size: 48,
          ),
          const SizedBox(height: 4),
          Text(
            _getMealTypeLabel(),
            style: TextStyle(
              color: mealColor.withOpacity(0.8),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getMealTypeLabel() {
    switch (mealType?.toLowerCase()) {
      case 'breakfast':
        return 'Breakfast';
      case 'lunch':
        return 'Lunch';
      case 'dinner':
        return 'Dinner';
      default:
        return 'Meal';
    }
  }
}
