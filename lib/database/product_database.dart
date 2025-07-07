import 'package:sqflite_common_ffi/sqflite_ffi.dart';  // Importar sqflite_common_ffi para escritorio
import 'package:path/path.dart';
import 'package:productos_app/models/product.dart';  // Asegúrate de tener el modelo ProductModel

class ProductDatabase {
  static final ProductDatabase instance = ProductDatabase._internal();
  static Database? _database;

  ProductDatabase._internal();

  // Inicialización del databaseFactory para utilizarlo en plataformas de escritorio
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    // Inicializamos el databaseFactory para plataformas de escritorio
    databaseFactory = databaseFactoryFfi;
    _database = await _initDatabase();
    return _database!;
  }

  // Método para inicializar la base de datos
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'products.db');

    // Abre la base de datos (la creamos si no existe)
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,  // Crea la base de datos si no existe
    );
  }

  // Crear la base de datos con la tabla 'Product'
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${ProductFields.tableName} (
        ${ProductFields.id} ${ProductFields.idType},
        ${ProductFields.name} ${ProductFields.textType},
        ${ProductFields.description} ${ProductFields.textType},
        ${ProductFields.expirationDate} ${ProductFields.textType},
        ${ProductFields.price} ${ProductFields.realType}
      )
    ''');
  }

  // Crear un nuevo producto
  Future<void> create(ProductModel product) async {
    final db = await database;
    await db.insert(ProductFields.tableName, product.toJson());
  }

  // Leer todos los productos
  Future<List<ProductModel>> readAll() async {
    final db = await database;
    final result = await db.query(ProductFields.tableName);
    return result.map((json) => ProductModel.fromJson(json)).toList();
  }

  // Leer un producto por su ID
  Future<ProductModel> read(int id) async {
    final db = await database;
    final result = await db.query(
      ProductFields.tableName,
      where: '${ProductFields.id} = ?',
      whereArgs: [id],
    );
    return ProductModel.fromJson(result.first);
  }

  // Actualizar un producto
  Future<void> update(ProductModel product) async {
    final db = await database;
    await db.update(
      ProductFields.tableName,
      product.toJson(),
      where: '${ProductFields.id} = ?',
      whereArgs: [product.id],
    );
  }

  // Eliminar un producto por su ID
  Future<void> delete(int id) async {
    final db = await database;
    await db.delete(
      ProductFields.tableName,
      where: '${ProductFields.id} = ?',
      whereArgs: [id],
    );
  }
}
