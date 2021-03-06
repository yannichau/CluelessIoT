library database_handler;

import 'package:imfresh/models/device_reading.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final DatabaseHandler dbHandler = DatabaseHandler._privateConstructor();

Map<String, dynamic> readingToMap(DeviceReading reading) {
  final temp = reading.toJson();
  temp["id"] = reading.deviceId + reading.timestamp.toIso8601String();
  return temp;
}

class DatabaseHandler {
  // Singleton Instance
  DatabaseHandler._privateConstructor();

  Future<Database> openDB() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "database.db");
    return openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE periodicReadings(id TEXT PRIMARY KEY, type TEXT, timestamp TEXT,  nextWash TEXT, deviceId TEXT, humidity REAL, temperature REAL, VOC REAL)',
        );
      },
      version: 1,
    );
  }

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'database.db'),
      version: 1,
    );
  }

  Future<int> insertReadings(List<DeviceReading> readings) async {
    print("Number of readings to be inserted: " + readings.length.toString());
    int result = 0;
    final Database db = await initializeDB();
    for (var reading in readings) {
      result = await db.insert('periodicReadings', readingToMap(reading),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return result;
  }

  Future<List<DeviceReading>> getReadings() async {
    final Database db = await openDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('periodicReadings', orderBy: "timestamp DESC");
    return queryResult.map((e) => DeviceReading.fromJson(e)).toList();
  }

  Future<List<DeviceReading>> getReadingsByDevice(String deviceId) async {
    final Database db = await openDB();
    final List<Map<String, Object?>> queryResult = await db.query(
        'periodicReadings',
        orderBy: "timestamp DESC",
        where: "deviceId = ?",
        whereArgs: [deviceId]);
    return queryResult.map((e) => DeviceReading.fromJson(e)).toList();
  }

  Future<List<DeviceReading>> getLastReading(String deviceId,
      {int number = 1}) async {
    final Database db = await openDB();
    final List<Map<String, Object?>> queryResult = await db.query(
        'periodicReadings',
        orderBy: "timestamp DESC",
        limit: number,
        where: "deviceId = ?",
        whereArgs: [deviceId]);
    return queryResult.map((e) => DeviceReading.fromJson(e)).toList();
  }

  Future<void> deleteReading(String id) async {
    final db = await openDB();
    await db.delete(
      'periodicReadings',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
