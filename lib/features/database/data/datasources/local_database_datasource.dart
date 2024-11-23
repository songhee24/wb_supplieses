import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product_model.dart';

class LocalDatabaseDatasource {
  static final LocalDatabaseDatasource instance = LocalDatabaseDatasource._init();
  static Database? _database;

  LocalDatabaseDatasource._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('products.db');
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
  }

  Future<int> insertProduct(ProductModel product) async {
    final db = await instance.database;
    return await db.insert('products', product.toMap());
  }

  Future<List<ProductModel>> getAllProducts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    print('maps $maps');
    return List.generate(maps.length, (i) => ProductModel.fromMap(maps[i]));
  }

  Future<void> insertBulkProducts(List<ProductModel> products) async {
    final db = await instance.database;
    final batch = db.batch();

    for (var product in products) {
      print('insertBulkProducts product $product');
      batch.insert('products', product.toMap());
    }

    await batch.commit(noResult: true);
  }

  Future<void> deleteAllProducts() async {
    final db = await instance.database;
    await db.delete('products');
  }
}