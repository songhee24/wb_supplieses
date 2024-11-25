import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseDatasource {
  static final LocalDatabaseDatasource instance = LocalDatabaseDatasource._init();
  static Database? _database;

  LocalDatabaseDatasource._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      group_id TEXT,
      sellers_article TEXT,
      article_wb TEXT,
      product_name TEXT,
      category TEXT,
      brand TEXT,
      barcode TEXT,
      size TEXT,
      russian_size TEXT
    )
    ''');

    // await db.execute('''
    // CREATE TABLE orders (
    //   id INTEGER PRIMARY KEY AUTOINCREMENT,
    //   order_id TEXT,
    //   customer_name TEXT,
    //   total_amount REAL
    // )
    // ''');
  }
}