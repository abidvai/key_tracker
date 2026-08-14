import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('keys_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE keys (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key_name TEXT NOT NULL,
        room_id TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE handovers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key_id INTEGER NOT NULL,
        person_name TEXT NOT NULL,
        handover_time TEXT NOT NULL,
        expected_return_time TEXT NOT NULL,
        returned_time TEXT,
        status TEXT NOT NULL,
        FOREIGN KEY (key_id) REFERENCES keys (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> insertInitialKeys() async {
    final db = await instance.database;
    final keys = [
      {'key_name': 'Meeting Room', 'room_id': 'MR-01', 'status': 'Available'},
      {'key_name': 'Server Room', 'room_id': 'SR-01', 'status': 'Available'},
      {'key_name': 'Store Room', 'room_id': 'ST-01', 'status': 'Available'},
      {'key_name': 'Main Gate', 'room_id': 'MG-01', 'status': 'Available'},
    ];

    for (var key in keys) {
      await db.insert('keys', key, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  Future<List<Map<String, dynamic>>> getAllKeys() async {
    final db = await instance.database;
    return await db.query('keys');
  }

  Future<void> takeKey(int keyId, String personName, String expectedReturnTime) async {
    final db = await instance.database;
    final now = DateTime.now().toIso8601String();

    await db.transaction((txn) async {
      await txn.insert('handovers', {
        'key_id': keyId,
        'person_name': personName,
        'handover_time': now,
        'expected_return_time': expectedReturnTime,
        'status': 'Taken'
      });

      await txn.update(
        'keys',
        {'status': 'Taken'},
        where: 'id = ?',
        whereArgs: [keyId],
      );
    });
  }

  Future<void> returnKey(int keyId) async {
    final db = await instance.database;
    final now = DateTime.now().toIso8601String();

    await db.transaction((txn) async {
      await txn.update(
        'handovers',
        {'returned_time': now, 'status': 'Returned'},
        where: 'key_id = ? AND status = ?',
        whereArgs: [keyId, 'Taken'],
      );

      await txn.update(
        'keys',
        {'status': 'Available'},
        where: 'id = ?',
        whereArgs: [keyId],
      );
    });
  }

  Future<List<Map<String, dynamic>>> getHandoverHistory() async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT h.*, k.key_name, k.room_id 
      FROM handovers h
      JOIN keys k ON h.key_id = k.id
      ORDER BY h.handover_time DESC
    ''');
  }
}
