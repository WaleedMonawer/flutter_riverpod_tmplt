import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../storage/local_storage.dart';
import '../logger.dart';
import '../result.dart';

abstract class StatePersistenceService {
  Future<void> saveState<T>(String key, T state);
  Future<T?> loadState<T>(String key, T Function(Map<String, dynamic>) fromJson);
  Future<void> clearState(String key);
  Future<void> clearAllStates();
  Future<bool> hasState(String key);
  Future<List<String>> getAllKeys();
}

class LocalStatePersistenceService implements StatePersistenceService {
  final LocalStorage _storage;
  static const String _prefix = 'app_state_';

  LocalStatePersistenceService(this._storage);

  @override
  Future<void> saveState<T>(String key, T state) async {
    try {
      final fullKey = '$_prefix$key';
      final jsonData = _convertToJson(state);
      
      final result = await _storage.set(fullKey, jsonData);
      
      if (result.isSuccess) {
        if (kDebugMode) {
          Logger.info('💾 State saved: $key');
        }
      } else {
        if (kDebugMode) {
          Logger.error('💾 Failed to save state: $key - ${result.errorMessage}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        Logger.error('💾 Error saving state: $key - $e');
      }
    }
  }

  @override
  Future<T?> loadState<T>(String key, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final fullKey = '$_prefix$key';
      final result = await _storage.get(fullKey);
      
      if (result.isSuccess && result.data != null) {
        final jsonData = result.data as String;
        final mapData = jsonDecode(jsonData) as Map<String, dynamic>;
        final state = fromJson(mapData);
        
        if (kDebugMode) {
          Logger.info('💾 State loaded: $key');
        }
        
        return state;
      } else {
        if (kDebugMode) {
          Logger.info('💾 No state found: $key');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        Logger.error('💾 Error loading state: $key - $e');
      }
      return null;
    }
  }

  @override
  Future<void> clearState(String key) async {
    try {
      final fullKey = '$_prefix$key';
      final result = await _storage.remove(fullKey);
      
      if (result.isSuccess) {
        if (kDebugMode) {
          Logger.info('💾 State cleared: $key');
        }
      } else {
        if (kDebugMode) {
          Logger.error('💾 Failed to clear state: $key - ${result.errorMessage}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        Logger.error('💾 Error clearing state: $key - $e');
      }
    }
  }

  @override
  Future<void> clearAllStates() async {
    try {
      final keys = await getAllKeys();
      for (final key in keys) {
        await clearState(key);
      }
      
      if (kDebugMode) {
        Logger.info('💾 All states cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        Logger.error('💾 Error clearing all states: $e');
      }
    }
  }

  @override
  Future<bool> hasState(String key) async {
    try {
      final fullKey = '$_prefix$key';
      final result = await _storage.get(fullKey);
      return result.isSuccess && result.data != null;
    } catch (e) {
      if (kDebugMode) {
        Logger.error('💾 Error checking state: $key - $e');
      }
      return false;
    }
  }

  @override
  Future<List<String>> getAllKeys() async {
    try {
      // Note: This is a simplified implementation
      // In a real app, you might want to store a list of keys separately
      // or use a different approach to get all keys
      if (kDebugMode) {
        Logger.info('💾 Getting all state keys');
      }
      return []; // Placeholder
    } catch (e) {
      if (kDebugMode) {
        Logger.error('💾 Error getting all keys: $e');
      }
      return [];
    }
  }

  String _convertToJson<T>(T state) {
    if (state is Map) {
      return jsonEncode(state);
    } else if (state is List) {
      return jsonEncode(state);
    } else if (state is String) {
      return jsonEncode({'value': state});
    } else if (state is int) {
      return jsonEncode({'value': state});
    } else if (state is double) {
      return jsonEncode({'value': state});
    } else if (state is bool) {
      return jsonEncode({'value': state});
    } else {
      // For custom objects, try to convert to JSON
      try {
        return jsonEncode(state);
      } catch (e) {
        // If direct conversion fails, try to convert to map
        if (state.toString().contains('{')) {
          return state.toString();
        } else {
          return jsonEncode({'value': state.toString()});
        }
      }
    }
  }
}

class MockStatePersistenceService implements StatePersistenceService {
  final Map<String, String> _mockStorage = {};

  @override
  Future<void> saveState<T>(String key, T state) async {
    _mockStorage[key] = jsonEncode({'value': state.toString()});
    Logger.info('💾 Mock: State saved: $key');
  }

  @override
  Future<T?> loadState<T>(String key, T Function(Map<String, dynamic>) fromJson) async {
    final data = _mockStorage[key];
    if (data != null) {
      final mapData = jsonDecode(data) as Map<String, dynamic>;
      final state = fromJson(mapData);
      Logger.info('💾 Mock: State loaded: $key');
      return state;
    }
    Logger.info('💾 Mock: No state found: $key');
    return null;
  }

  @override
  Future<void> clearState(String key) async {
    _mockStorage.remove(key);
    Logger.info('💾 Mock: State cleared: $key');
  }

  @override
  Future<void> clearAllStates() async {
    _mockStorage.clear();
    Logger.info('💾 Mock: All states cleared');
  }

  @override
  Future<bool> hasState(String key) async {
    final hasKey = _mockStorage.containsKey(key);
    Logger.info('💾 Mock: Has state $key: $hasKey');
    return hasKey;
  }

  @override
  Future<List<String>> getAllKeys() async {
    final keys = _mockStorage.keys.toList();
    Logger.info('💾 Mock: All keys: $keys');
    return keys;
  }
} 