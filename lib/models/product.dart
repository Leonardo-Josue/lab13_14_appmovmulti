class ProductFields {
  static const List<String> values = [
    id,
    name,
    description,
    expirationDate,
    price,
  ];

  static const String tableName = 'products';
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT NOT NULL';
  static const String realType = 'REAL NOT NULL';
  static const String id = '_id';
  static const String name = 'name';
  static const String description = 'description';
  static const String expirationDate = 'expiration_date';
  static const String price = 'price';
}

class ProductModel {
  int? id;
  final String name;
  final String description;
  final DateTime expirationDate;
  final double price;

  // Constructor para inicializar un producto
  ProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.expirationDate,
    required this.price,
  });

  // Método para convertir un objeto ProductModel en un mapa (para interactuar con la base de datos)
  Map<String, Object?> toJson() => {
        ProductFields.id: id,
        ProductFields.name: name,
        ProductFields.description: description,
        ProductFields.expirationDate: expirationDate.toIso8601String(),
        ProductFields.price: price,
      };

  // Método para crear un objeto ProductModel desde un mapa (lo que devuelve la base de datos)
  factory ProductModel.fromJson(Map<String, Object?> json) => ProductModel(
        id: json[ProductFields.id] as int?,
        name: json[ProductFields.name] as String,
        description: json[ProductFields.description] as String,
        expirationDate: DateTime.parse(json[ProductFields.expirationDate] as String),
        price: json[ProductFields.price] as double,
      );

  // Método copy para crear una copia de un producto con un nuevo id
  ProductModel copy({
    int? id,
    String? name,
    String? description,
    DateTime? expirationDate,
    double? price,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      expirationDate: expirationDate ?? this.expirationDate,
      price: price ?? this.price,
    );
  }
}
