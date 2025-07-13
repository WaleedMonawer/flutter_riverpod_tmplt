import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod_tmplt/core/domain/entities/result.dart';

abstract class LocalStorage {
  Future<Result<T?>> get<T>(String key);
  Future<Result<bool>> set<T>(String key, T value);
  Future<Result<bool>> remove(String key);
  Future<Result<bool>> clear();
}

class SharedPreferencesStorage implements LocalStorage {
  final SharedPreferences _prefs;
  
  SharedPreferencesStorage(this._prefs);
  
  static Future<SharedPreferencesStorage> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferencesStorage(prefs);
  }

  @override
  Future<Result<T?>> get<T>(String key) async {
    try {
      if (!_prefs.containsKey(key)) {
        return Result.success(null);
      }
      
      final value = _prefs.get(key);
      if (value == null) {
        return Result.success(null);
      }
      
      // Handle different types
      if (T == String) {
        return Result.success(value as T);
      } else if (T == int) {
        return Result.success(value as T);
      } else if (T == double) {
        return Result.success(value as T);
      } else if (T == bool) {
        return Result.success(value as T);
      } else if (T == List<String>) {
        return Result.success(value as T);
      } else {
        // For complex objects, try to decode JSON
        if (value is String) {
          final decoded = jsonDecode(value);
          return Result.success(decoded as T);
        }
        return Result.success(value as T);
      }
    } catch (e) {
      return Result.failure('Failed to get value for key $key: $e');
    }
  }

  @override
  Future<Result<bool>> set<T>(String key, T value) async {
    try {
      if (value == null) {
        return Result.success(await _prefs.remove(key));
      }
      
      // Handle different types
      if (value is String || value is int || value is double || value is bool || value is List<String>) {
        return Result.success(await _prefs.setString(key, value.toString()));
      } else {
        // For complex objects, encode as JSON
        final encoded = jsonEncode(value);
        return Result.success(await _prefs.setString(key, encoded));
      }
    } catch (e) {
      return Result.failure('Failed to set value for key $key: $e');
    }
  }

  @override
  Future<Result<bool>> remove(String key) async {
    try {
      return Result.success(await _prefs.remove(key));
    } catch (e) {
      return Result.failure('Failed to remove key $key: $e');
    }
  }

  @override
  Future<Result<bool>> clear() async {
    try {
      return Result.success(await _prefs.clear());
    } catch (e) {
      return Result.failure('Failed to clear storage: $e');
    }
  }
} 