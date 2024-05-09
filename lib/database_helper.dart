import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task5/product_model.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper; // Singleton DatabaseHelper
  static Database? _database; // Singleton Database

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._();
    return _databaseHelper!;
  }

  DatabaseHelper._();

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    // Open/create the database at a given path
    String path = join(await getDatabasesPath(), 'ecommerce.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE products(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price REAL)');
  }

  Future<int> insertProduct(Product product) async {
    Database db = await database;
    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> getProducts() async {
    Database db = await database;
    List<Map<String, dynamic>> productList = await db.query('products');
    return productList.map((product) => Product(
      id: product['id'],
      name: product['name'],
      price: product['price'],
    )).toList();
  }
}