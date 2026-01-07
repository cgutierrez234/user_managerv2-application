import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';

class DatabaseHelper {
  // singleton
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal(); // <--- thats the constructor for this joint

  static Database? _database;

  // getter
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatbase();
    return _database!;
  }

  //Initialize that Database

  Future<Database> _initDatbase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user_manager_v2.db');

    //open or create the database
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE users(
        id TEXT PRIMARY KEY,
        name TEXT,
        age INTEGER,
        gender TEXT,
        profession TEXT
        )
      ''');
      },
    );
  }

  // CRUD OPERARTIONS

  // CREATE

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm
          .replace, // if it already exists, just replace it. no errors no fuss
    );
  }

  //READ- GET ALL USERS
  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  // READ- GETUSERBYID
  Future<User?> getUserById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // UPDATE
  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: "id = ?",
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(String id) async {
    final db = await database;
    await db.delete('users', where: "id = ?", whereArgs: [id]);
  }
}
