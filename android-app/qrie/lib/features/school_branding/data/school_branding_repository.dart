import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';
import '../models/school_branding_config.dart';

class SchoolBrandingRepository {
  final ApiClient _apiClient;
  static const _cacheKey = 'qrie_cached_school_branding';

  SchoolBrandingRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Loads cached branding immediately to avoid theme flashing
  Future<SchoolBrandingConfig> getCachedBranding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJsonStr = prefs.getString(_cacheKey);
      if (cachedJsonStr != null) {
        final map = jsonDecode(cachedJsonStr) as Map<String, dynamic>;
        return SchoolBrandingConfig.fromJson(map);
      }
    } catch (_) {
      // Fallback on read failure
    }
    return SchoolBrandingConfig.dpsDefault();
  }

  /// Refreshes school branding from API and caches it
  Future<SchoolBrandingConfig> fetchAndCacheBranding({String? schoolCode}) async {
    try {
      final path = schoolCode != null
          ? '/public/school/branding?school_code=$schoolCode'
          : '/student/school/branding';

      final response = await _apiClient.get(path);
      if (response is Map<String, dynamic>) {
        final config = SchoolBrandingConfig.fromJson(response);
        await _saveToCache(config);
        return config;
      }
    } catch (_) {
      // Offline or network error: return cached or default
    }
    return await getCachedBranding();
  }

  Future<void> _saveToCache(SchoolBrandingConfig config) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonEncode(config.toJson()));
    } catch (_) {}
  }

  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
    } catch (_) {}
  }
}
