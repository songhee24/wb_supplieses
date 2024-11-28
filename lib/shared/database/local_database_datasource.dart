import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseDatasource {
  static final LocalDatabaseDatasource instance = LocalDatabaseDatasource._init();
  static Database? _database;

  LocalDatabaseDatasource._init();

  Future<void> _deleteDatabase(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    await deleteDatabase(path); // Deletes the database file
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    await _deleteDatabase('app.db');
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
    // Create the Products table
    await db.execute('''
    CREATE TABLE exel_products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      group_id TEXT,
      box_id TEXT,
      sellers_article TEXT,
      article_wb TEXT,
      product_name TEXT,
      category TEXT,
      brand TEXT,
      barcode TEXT,
      size TEXT,
      russian_size TEXT,
      count INTEGER
    )
    ''');

    // Create the Boxes table
    await db.execute('''
    CREATE TABLE box (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      supplies_id TEXT NOT NULL,
      box_number INTEGER NOT NULL
    )
    ''');

    // Create the products inside box table
    await db.execute('''
    CREATE TABLE box_products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      box_id TEXT,
      group_id TEXT,
      sellers_article TEXT,
      article_wb TEXT,
      product_name TEXT,
      category TEXT,
      brand TEXT,
      barcode TEXT,
      size TEXT,
      russian_size TEXT,
      count INTEGER,
      FOREIGN KEY (box_id) REFERENCES Boxes (id) ON DELETE CASCADE
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