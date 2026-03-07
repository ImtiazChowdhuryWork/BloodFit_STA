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

    // Prepare multipart fields (text data only)
    final Map<String, String> multipartFields = {
      'date': mealPlanData['date'].toString(),
      'meals': jsonEncode(mealPlanData['meals']),
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
  
  // Helper method to download image from URL and save as temporary file
  Future<File?> _downloadImage(String imageUrl, String mealType) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final String extension = imageUrl.contains('.png') ? 'png' : 
                                 imageUrl.contains('.gif') ? 'gif' : 'jpg';
        final file = File('${tempDir.path}/${mealType}_image.$extension');
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
    } catch (e) {
      LoggerUtils.error("📦 [REPO] Failed to download $mealType image: $e");
    }
    return null;
  }
}