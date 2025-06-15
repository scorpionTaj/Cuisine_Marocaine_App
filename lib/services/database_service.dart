import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Directory; // Add import for creating directory

class DatabaseService {
  static Database? _db;
  static bool _initialized = false;

  static Future<void> _initializeDatabaseFactory() async {
    // No-op factory init; use default sqflite on all platforms
    _initialized = true;
  }

  static Future<Database> get database async {
    if (_db != null) return _db!;

    // Ensure factory is initialized
    await _initializeDatabaseFactory();

    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    try {
      final dbPath = await getDatabasesPath();
      // Ensure the database directory exists on mobile platforms
      await Directory(dbPath).create(recursive: true);
      final path = join(dbPath, 'app_auth.db');

      print("Database path: $path");

      // Ensure the database directory exists
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          print("Creating database tables");
          // Users table for authentication
          await db.execute('''
            CREATE TABLE users(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              username TEXT UNIQUE,
              password TEXT
            )
          ''');

          // Add a default user
          await db.insert('users', {'username': 'imad', 'password': '123456'});
          print("Default user created");

          // Reservations table
          await db.execute('''
            CREATE TABLE reservations(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              username TEXT,
              date TEXT,
              time TEXT,
              guests INTEGER,
              dish TEXT,
              table_number INTEGER,
              notes TEXT,
              FOREIGN KEY (username) REFERENCES users(username)
            )
          ''');
          print("Reservations table created");
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          // Handle database upgrades here if needed
          if (oldVersion < 1) {
            // Upgrade logic if coming from a version before 1
          }
        },
      );
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> getUser(String username) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('users') ?? '{}';
      final Map<String, dynamic> usersMap = jsonDecode(usersJson);
      if (usersMap.containsKey(username)) {
        return {'username': username, 'password': usersMap[username]};
      }
      return null;
    }
    try {
      final db = await database;
      final res = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );
      if (res.isNotEmpty) return res.first;
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  static Future<bool> createUser(String username, String password) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('users') ?? '{}';
      final Map<String, dynamic> usersMap = jsonDecode(usersJson);
      if (usersMap.containsKey(username)) return false;
      usersMap[username] = password;
      await prefs.setString('users', jsonEncode(usersMap));
      return true;
    }
    try {
      final db = await database;
      await db.insert('users', {
        'username': username,
        'password': password,
      });
      return true;
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllReservations() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final resJson = prefs.getString('reservations') ?? '[]';
      final List list = jsonDecode(resJson);
      return List<Map<String, dynamic>>.from(list);
    }
    try {
      final db = await database;
      return await db.query(
        'reservations',
        orderBy: 'date ASC, time ASC'
      );
    } catch (e) {
      print('Error getting all reservations: $e');
      return [];
    }
  }

  static Future<int> createReservation({
    required String username,
    required String date,
    required String time,
    required int guests,
    required String dish,
    required int tableNumber,
    String? notes,
  }) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final resJson = prefs.getString('reservations') ?? '[]';
      final List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(jsonDecode(resJson));
      final newId = list.isEmpty ? 1 : (list.map((e) => e['id'] as int).reduce((a, b) => a > b ? a : b) + 1);
      final newRes = {
        'id': newId,
        'username': username,
        'date': date,
        'time': time,
        'guests': guests,
        'dish': dish,
        'table_number': tableNumber,
        'notes': notes ?? '',
      };
      list.add(newRes);
      await prefs.setString('reservations', jsonEncode(list));
      return newId;
    }
    try {
      final db = await database;
      return await db.insert('reservations', {
        'username': username,
        'date': date,
        'time': time,
        'guests': guests,
        'dish': dish,
        'table_number': tableNumber,
        'notes': notes ?? '',
      });
    } catch (e) {
      print('Error creating reservation: $e');
      return -1;
    }
  }

  static Future<List<Map<String, dynamic>>> getUserReservations(String username) async {
    if (kIsWeb) {
      final all = await getAllReservations();
      return all.where((e) => e['username'] == username).toList();
    }
    try {
      final db = await database;
      return await db.query(
        'reservations',
        where: 'username = ?',
        whereArgs: [username],
        orderBy: 'date ASC, time ASC',
      );
    } catch (e) {
      print('Error getting user reservations: $e');
      return [];
    }
  }

  static Future<bool> deleteReservation(int id) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final resJson = prefs.getString('reservations') ?? '[]';
      final List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(jsonDecode(resJson));
      list.removeWhere((e) => e['id'] == id);
      await prefs.setString('reservations', jsonEncode(list));
      return true;
    }
    try {
      final db = await database;
      await db.delete(
        'reservations',
        where: 'id = ?',
        whereArgs: [id],
      );
      return true;
    } catch (e) {
      print('Error deleting reservation: $e');
      return false;
    }
  }
}
