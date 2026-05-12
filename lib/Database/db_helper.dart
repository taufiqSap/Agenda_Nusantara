import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';
import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            judul TEXT NOT NULL,
            deskripsi TEXT,
            tanggal TEXT,
            kategori TEXT,
            selesai INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS users (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              username TEXT UNIQUE NOT NULL,
              password TEXT NOT NULL
            )
          ''');
        }
      },
    );
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final result = await db.query('tasks', orderBy: 'id DESC');
    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Task>> getTasksByCategory(String kategori) async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'kategori = ?',
      whereArgs: [kategori],
      orderBy: 'id DESC',
    );
    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future<List<Task>> searchTasks(String keyword) async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'judul LIKE ? OR deskripsi LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
      orderBy: 'id DESC',
    );
    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future<List<Task>> getCompletedTasks() async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'selesai = 1',
      orderBy: 'id DESC',
    );
    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future<List<Task>> getPendingTasks() async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'selesai = 0',
      orderBy: 'id DESC',
    );
    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future<List<Task>> getTasksByDate(String tanggal) async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'tanggal = ?',
      whereArgs: [tanggal],
      orderBy: 'id DESC',
    );
    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future<int> getTaskCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM tasks');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getTaskCountByStatus(int status) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE selesai = ?',
      [status],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> updateTaskStatus(int id, int status) async {
    final db = await database;
    return await db.update(
      'tasks',
      {'selesai': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // User operations
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> validateLogin(String username, String password) async {
    final db = await database;
    try {
      final result = await db.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );
      if (result.isNotEmpty) {
        return User.fromMap(result.first);
      }
      return null;
    } catch (e) {
      print('Error validating login: $e');
      return null;
    }
  }

  Future<bool> userExists(String username) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final result = await db.query('users');
    return result.map((e) => User.fromMap(e)).toList();
  }

  Future<int> deleteMultipleTasks(List<int> ids) async {
    final db = await database;
    final placeholders = List.filled(ids.length, '?').join(',');
    return await db.rawDelete(
      'DELETE FROM tasks WHERE id IN ($placeholders)',
      ids,
    );
  }

  Future<List<Task>> getTasksWithPagination({
    int limit = 10,
    int offset = 0,
  }) async {
    final db = await database;
    final result = await db.query(
      'tasks',
      orderBy: 'id DESC',
      limit: limit,
      offset: offset,
    );
    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future<List<Task>> getTasksSorted({
    String orderBy = 'id',
    bool ascending = false,
  }) async {
    final db = await database;
    final order = ascending ? 'ASC' : 'DESC';
    final result = await db.query('tasks', orderBy: '$orderBy $order');
    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future<List<Task>> getTasksByFilters({
    String? kategori,
    int? status,
    String? keyword,
  }) async {
    final db = await database;
    List<String> conditions = [];
    List<dynamic> args = [];

    if (kategori != null) {
      conditions.add('kategori = ?');
      args.add(kategori);
    }
    if (status != null) {
      conditions.add('selesai = ?');
      args.add(status);
    }
    if (keyword != null) {
      conditions.add('(judul LIKE ? OR deskripsi LIKE ?)');
      args.add('%$keyword%');
      args.add('%$keyword%');
    }

    final whereClause = conditions.isNotEmpty ? conditions.join(' AND ') : null;
    final result = await db.query(
      'tasks',
      where: whereClause,
      whereArgs: args.isNotEmpty ? args : null,
      orderBy: 'id DESC',
    );
    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future<int> clearAllTasks() async {
    final db = await database;
    return await db.delete('tasks');
  }

  Future<void> batchInsertTasks(List<Task> tasks) async {
    final db = await database;
    await db.transaction((txn) async {
      for (var task in tasks) {
        await txn.insert('tasks', task.toMap());
      }
    });
  }

  Future<void> transactionInsertTwoTasks(Task task1, Task task2) async {
    final db = await database;   
    try {
      await db.transaction((txn) async {
        await txn.insert('tasks', task1.toMap());
        await txn.insert('tasks', task2.toMap());
      });
    } catch (e) {
      print('Transaction gagal: $e');
      rethrow;
    }
  }
}
