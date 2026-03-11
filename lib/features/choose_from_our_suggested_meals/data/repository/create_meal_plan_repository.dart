import 'dart:convert';
import 'dart:io';
import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CreateMealPlanRepository {
  final NetworkCaller _networkCaller;
  CreateMealPlanRepository(this._networkCaller);


  Future<NetworkResponse> createMealPlanRepository(Map<String, dynamic> mealPlanData)async{

    String tokenValue = appData.read(kKeyAccessToken) ?? '';

    LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");
    LoggerUtils.debug("📦 [REPO] createMealPlanRepository CALLED");
    LoggerUtils.debug("📦 [REPO] Using Multipart/Form-Data with FILE uploads");

    // Download images and save as temporary files
    final Map<String, File> imageFiles = {};
    
    try {
      // Download breakfast image
      final breakfastImageUrl = mealPlanData['breakfastImage']?.toString() ?? '';
      if (breakfastImageUrl.isNotEmpty) {
        final breakfastFile = await _downloadImage(breakfastImageUrl, 'breakfast');
        if (breakfastFile != null) {
          imageFiles['breakfastImage'] = breakfastFile;
          LoggerUtils.debug("📦 [REPO] ✅ Breakfast image downloaded: ${breakfastFile.path}");
        }
      }
      
      // Download lunch image
      final lunchImageUrl = mealPlanData['lunchImage']?.toString() ?? '';
      if (lunchImageUrl.isNotEmpty) {
        final lunchFile = await _downloadImage(lunchImageUrl, 'lunch');
        if (lunchFile != null) {
          imageFiles['lunchImage'] = lunchFile;
          LoggerUtils.debug("📦 [REPO] ✅ Lunch image downloaded: ${lunchFile.path}");
        }
      }
      
      // Download dinner image
      final dinnerImageUrl = mealPlanData['dinnerImage']?.toString() ?? '';
      if (dinnerImageUrl.isNotEmpty) {
        final dinnerFile = await _downloadImage(dinnerImageUrl, 'dinner');
        if (dinnerFile != null) {
          imageFiles['dinnerImage'] = dinnerFile;
          LoggerUtils.debug("📦 [REPO] ✅ Dinner image downloaded: ${dinnerFile.path}");
        }
      }
    } catch (e) {
      LoggerUtils.error("📦 [REPO] ❌ Failed to download images: $e");
    }

    // Strip base64 image data from meals JSON to avoid "Field value too long"
    // (images are already being sent as separate file attachments)
    final mealsData = Map<String, dynamic>.from(mealPlanData['meals'] as Map);
    for (final mealType in mealsData.keys) {
      final mealList = mealsData[mealType];
      if (mealList is List) {
        for (int i = 0; i < mealList.length; i++) {
          if (mealList[i] is Map) {
            final meal = Map<String, dynamic>.from(mealList[i]);
            final image = meal['image']?.toString() ?? '';
            if (_isBase64(image)) {
              meal['image'] = '';
            }
            mealList[i] = meal;
          }
        }
      }
    }

    // Prepare multipart fields (text data only)
    final Map<String, String> multipartFields = {
      'date': mealPlanData['date'].toString(),
      'meals': jsonEncode(mealsData),
    };

    LoggerUtils.debug("📦 [REPO] === MULTIPART FIELDS ===");
    LoggerUtils.debug("📦 [REPO] date: ${multipartFields['date']}");
    final mealsDebug = multipartFields['meals'] ?? '';
    LoggerUtils.debug("📦 [REPO] meals: ${mealsDebug.length > 100 ? '${mealsDebug.substring(0, 100)}...' : mealsDebug}");
    LoggerUtils.debug("📦 [REPO] === IMAGE FILES ===");
    LoggerUtils.debug("📦 [REPO] breakfastImage: ${imageFiles.containsKey('breakfastImage') ? '✅' : '❌'}");
    LoggerUtils.debug("📦 [REPO] lunchImage: ${imageFiles.containsKey('lunchImage') ? '✅' : '❌'}");
    LoggerUtils.debug("📦 [REPO] dinnerImage: ${imageFiles.containsKey('dinnerImage') ? '✅' : '❌'}");
    LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");

    // Send as multipart/form-data with FILES
    final response = await _networkCaller.multipartPostRequest(
      Endpoints.createMealPlan(),
      fields: multipartFields,
      files: imageFiles,  // Send actual image files
      headers: tokenValue.isNotEmpty ? {
        'Authorization': 'Bearer $tokenValue',
      } : {},
    );
    
    // Clean up temporary files
    for (final file in imageFiles.values) {
      try {
        await file.delete();
      } catch (e) {
        LoggerUtils.debug("📦 [REPO] Warning: Could not delete temp file: ${file.path}");
      }
    }
    
    return response;
  }
  
  /// Checks if image data is base64 encoded
  bool _isBase64(String imageData) {
    if (imageData.startsWith('data:image')) return true;
    if (imageData.startsWith('iVBORw0KGgo')) return true;
    if (imageData.startsWith('/9j/')) return true;
    return false;
  }

  // Helper method to get image as a temporary file (handles both URLs and base64)
  Future<File?> _downloadImage(String imageData, String mealType) async {
    try {
      final tempDir = await getTemporaryDirectory();

      // Handle base64 image data
      if (_isBase64(imageData)) {
        LoggerUtils.debug("📦 [REPO] Base64 image detected for $mealType, saving as file");
        // Strip the data URI prefix if present (e.g., "data:image/png;base64,")
        final String base64String = imageData.contains(',')
            ? imageData.split(',').last
            : imageData;
        // Detect extension from data URI or default to jpg
        String extension = 'jpg';
        if (imageData.startsWith('data:image/png')) {
          extension = 'png';
        } else if (imageData.startsWith('data:image/gif')) {
          extension = 'gif';
        } else if (imageData.startsWith('iVBORw0KGgo')) {
          extension = 'png';
        }
        final file = File('${tempDir.path}/${mealType}_image.$extension');
        await file.writeAsBytes(base64Decode(base64String));
        return file;
      }

      // Handle URL - download the image
      final response = await http.get(Uri.parse(imageData));
      if (response.statusCode == 200) {
        final String extension = imageData.contains('.png') ? 'png' :
                                 imageData.contains('.gif') ? 'gif' : 'jpg';
        final file = File('${tempDir.path}/${mealType}_image.$extension');
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
    } catch (e) {
      LoggerUtils.error("📦 [REPO] Failed to process $mealType image: $e");
    }
    return null;
  }
}