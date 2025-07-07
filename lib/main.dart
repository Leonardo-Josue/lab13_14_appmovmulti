import 'package:flutter/material.dart';
import 'package:productos_app/views/product_view.dart';  // Importar correctamente

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productos App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductView(),
    );
  }
}
