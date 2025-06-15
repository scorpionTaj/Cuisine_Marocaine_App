import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CacheService {
  // In-memory cache for faster access
  static final Map<String, dynamic> _memoryCache = {};

  // Cache expiration times
  static const Duration shortCache = Duration(minutes: 5);
  static const Duration mediumCache = Duration(hours: 1);
  static const Duration longCache = Duration(days: 1);

  // Initialize SQLite database
  static Future<Database> _initDatabase() async {
    // Fix for mobile platforms - ensure proper directory path
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'cuisine_marocaine.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE cache (key TEXT PRIMARY KEY, value TEXT, timestamp INTEGER)',
        );
      },
    );
  }

  // Save data to both memory and disk cache
  static Future<void> saveData(
    String key,
    dynamic data, {
    Duration expiration = mediumCache,
  }) async {
    final expiryTime = DateTime.now().add(expiration).millisecondsSinceEpoch;
    final jsonData = jsonEncode(data);

    // Save to memory cache
    _memoryCache[key] = {
      'data': data,
      'expiry': expiryTime,
    };

    // Save to shared preferences for small data
    if (jsonData.length < 50000) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$key:data', jsonData);
      await prefs.setInt('$key:expiry', expiryTime);
    }
    // Save to SQLite for larger data
    else {
      try {
        final db = await _initDatabase();
        await db.insert(
          'cache',
          {
            'key': key,
            'value': jsonData,
            'timestamp': expiryTime,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } catch (e) {
        print('SQLite cache error: $e');
        // Fallback to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('$key:data', jsonData);
        await prefs.setInt('$key:expiry', expiryTime);
      }
    }
  }

  // Get data from cache (memory first, then disk)
  static Future<T?> getData<T>(String key) async {
    // Check memory cache first
    if (_memoryCache.containsKey(key)) {
      final cachedItem = _memoryCache[key];
      final expiryTime = cachedItem['expiry'] as int;

      // Return if not expired
      if (DateTime.now().millisecondsSinceEpoch < expiryTime) {
        return cachedItem['data'] as T?;
      } else {
        // Remove expired item
        _memoryCache.remove(key);
      }
    }

    // Check shared preferences
    final prefs = await SharedPreferences.getInstance();
    final dataJson = prefs.getString('$key:data');
    final expiryTime = prefs.getInt('$key:expiry');

    if (dataJson != null && expiryTime != null) {
      if (DateTime.now().millisecondsSinceEpoch < expiryTime) {
        final data = jsonDecode(dataJson);
        // Store in memory cache for future fast access
        _memoryCache[key] = {
          'data': data,
          'expiry': expiryTime,
        };
        return data as T?;
      } else {
        // Remove expired data
        await prefs.remove('$key:data');
        await prefs.remove('$key:expiry');
      }
    }

    // Check SQLite for larger data
    try {
      final db = await _initDatabase();
      final results = await db.query(
        'cache',
        where: 'key = ?',
        whereArgs: [key],
      );

      if (results.isNotEmpty) {
        final cachedItem = results.first;
        final expiryTime = cachedItem['timestamp'] as int;

        if (DateTime.now().millisecondsSinceEpoch < expiryTime) {
          final data = jsonDecode(cachedItem['value'] as String);
          // Store in memory cache for future fast access
          _memoryCache[key] = {
            'data': data,
            'expiry': expiryTime,
          };
          return data as T?;
        } else {
          // Remove expired data
          await db.delete('cache', where: 'key = ?', whereArgs: [key]);
        }
      }
    } catch (e) {
      print('SQLite cache retrieval error: $e');
    }

    return null;
  }

  // Clear all cache
  static Future<void> clearCache() async {
    // Clear memory cache
    _memoryCache.clear();

    // Clear shared preferences cache
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    for (final key in allKeys) {
      if (key.contains(':data') || key.contains(':expiry')) {
        await prefs.remove(key);
      }
    }

    // Clear SQLite cache
    try {
      final db = await _initDatabase();
      await db.delete('cache');
    } catch (e) {
      print('SQLite cache clear error: $e');
    }
  }

  // Clear expired cache items
  static Future<void> cleanExpiredCache() async {
    final now = DateTime.now().millisecondsSinceEpoch;

    // Clean memory cache
    _memoryCache.removeWhere((key, value) => value['expiry'] < now);

    // Clean shared preferences
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    for (final key in allKeys) {
      if (key.contains(':expiry')) {
        final expiryTime = prefs.getInt(key);
        if (expiryTime != null && expiryTime < now) {
          final dataKey = key.replaceFirst(':expiry', ':data');
          await prefs.remove(dataKey);
          await prefs.remove(key);
        }
      }
    }

    // Clean SQLite
    try {
      final db = await _initDatabase();
      await db.delete(
        'cache',
        where: 'timestamp < ?',
        whereArgs: [now],
      );
    } catch (e) {
      print('SQLite cache cleaning error: $e');
    }
  }
}
